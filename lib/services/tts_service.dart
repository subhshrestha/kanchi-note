import 'dart:io';

import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { idle, playing, loading, error }

class TtsService {
  final FlutterTts _flutterTts = FlutterTts();
  TtsState _state = TtsState.idle;
  String? _currentlyPlayingPhrase;
  String? _errorMessage;
  Process? _linuxProcess;

  // Callbacks for state changes
  void Function(TtsState state, String? phrase)? onStateChanged;

  TtsState get state => _state;
  String? get currentlyPlayingPhrase => _currentlyPlayingPhrase;
  String? get errorMessage => _errorMessage;
  bool get isPlaying => _state == TtsState.playing;

  bool _isAvailable = false;
  bool _isLinux = false;

  bool get isAvailable => _isAvailable;

  Future<void> init() async {
    _isLinux = Platform.isLinux;

    if (_isLinux) {
      await _initLinux();
    } else {
      await _initFlutterTts();
    }
  }

  Future<void> _initLinux() async {
    try {
      // Check if spd-say is available
      final result = await Process.run('which', ['spd-say']);
      if (result.exitCode == 0) {
        _isAvailable = true;
      } else {
        _isAvailable = false;
        _errorMessage = 'speech-dispatcher not installed. Run: sudo apt install speech-dispatcher';
      }
    } catch (e) {
      _isAvailable = false;
      _errorMessage = 'Failed to check for speech-dispatcher: $e';
    }
  }

  Future<void> _initFlutterTts() async {
    try {
      // Set Danish language
      await _flutterTts.setLanguage('da-DK');
      // Slower speech rate for learning
      await _flutterTts.setSpeechRate(0.3);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);

      // Set up handlers
      _flutterTts.setStartHandler(() {
        _state = TtsState.playing;
        _notifyStateChanged();
      });

      _flutterTts.setCompletionHandler(() {
        _state = TtsState.idle;
        _currentlyPlayingPhrase = null;
        _notifyStateChanged();
      });

      _flutterTts.setCancelHandler(() {
        _state = TtsState.idle;
        _currentlyPlayingPhrase = null;
        _notifyStateChanged();
      });

      _flutterTts.setErrorHandler((msg) {
        _state = TtsState.error;
        _errorMessage = msg.toString();
        _currentlyPlayingPhrase = null;
        _notifyStateChanged();
      });

      // Check if Danish is available
      final languages = await _flutterTts.getLanguages;
      final hasDanish = languages.any(
        (lang) => lang.toString().toLowerCase().contains('da'),
      );
      if (!hasDanish) {
        _errorMessage = 'Danish TTS not available on this device';
      }

      _isAvailable = true;
    } catch (e) {
      _isAvailable = false;
      _errorMessage = 'TTS not available on this platform';
      _state = TtsState.error;
    }
  }

  void _notifyStateChanged() {
    onStateChanged?.call(_state, _currentlyPlayingPhrase);
  }

  /// Toggle speak/stop for a phrase
  Future<void> toggleSpeak(String phrase) async {
    if (_state == TtsState.playing && _currentlyPlayingPhrase == phrase) {
      // Stop if same phrase is playing
      await stop();
    } else {
      // Stop any current playback and start new
      await stop();
      await speak(phrase);
    }
  }

  /// Speak a phrase
  Future<void> speak(String phrase) async {
    if (phrase.trim().isEmpty) return;
    if (!_isAvailable) {
      _state = TtsState.error;
      _errorMessage = 'TTS not available on this platform';
      _notifyStateChanged();
      return;
    }

    _state = TtsState.loading;
    _currentlyPlayingPhrase = phrase;
    _errorMessage = null;
    _notifyStateChanged();

    if (_isLinux) {
      await _speakLinux(phrase);
    } else {
      await _speakFlutterTts(phrase);
    }
  }

  Future<void> _speakLinux(String phrase) async {
    try {
      _state = TtsState.playing;
      _notifyStateChanged();

      // Use spd-say with Danish language and wait for completion
      _linuxProcess = await Process.start(
        'spd-say',
        ['-l', 'da', '-r', '-30', '-w', phrase],
      );

      // Wait for the process to complete
      final exitCode = await _linuxProcess!.exitCode;
      _linuxProcess = null;

      if (exitCode == 0) {
        _state = TtsState.idle;
        _currentlyPlayingPhrase = null;
      } else {
        _state = TtsState.error;
        _errorMessage = 'spd-say failed with exit code $exitCode';
        _currentlyPlayingPhrase = null;
      }
      _notifyStateChanged();
    } catch (e) {
      _linuxProcess = null;
      _state = TtsState.error;
      _errorMessage = e.toString();
      _currentlyPlayingPhrase = null;
      _notifyStateChanged();
    }
  }

  Future<void> _speakFlutterTts(String phrase) async {
    try {
      final result = await _flutterTts.speak(phrase);
      if (result != 1) {
        _state = TtsState.error;
        _errorMessage = 'Failed to start TTS';
        _currentlyPlayingPhrase = null;
        _notifyStateChanged();
      }
    } catch (e) {
      _state = TtsState.error;
      _errorMessage = e.toString();
      _currentlyPlayingPhrase = null;
      _notifyStateChanged();
    }
  }

  /// Stop current playback
  Future<void> stop() async {
    if (_isLinux) {
      // Kill the spd-say process if running
      _linuxProcess?.kill();
      _linuxProcess = null;
      // Also send stop command to speech-dispatcher
      try {
        await Process.run('spd-say', ['-S']);
      } catch (_) {}
    } else {
      await _flutterTts.stop();
    }
    _state = TtsState.idle;
    _currentlyPlayingPhrase = null;
    _notifyStateChanged();
  }

  /// Check if a specific phrase is currently playing
  bool isPhraseCurrentlyPlaying(String phrase) {
    return _state == TtsState.playing && _currentlyPlayingPhrase == phrase;
  }

  /// Get state for a specific phrase
  TtsState getStateForPhrase(String phrase) {
    if (_currentlyPlayingPhrase != phrase) {
      return TtsState.idle;
    }
    return _state;
  }

  void dispose() {
    if (_isLinux) {
      _linuxProcess?.kill();
      _linuxProcess = null;
    } else {
      _flutterTts.stop();
    }
  }
}
