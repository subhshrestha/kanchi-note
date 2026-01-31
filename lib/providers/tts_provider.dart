import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/tts_service.dart';

class TtsNotifier extends StateNotifier<TtsState> {
  final TtsService _ttsService;
  String? _currentPhrase;

  TtsNotifier(this._ttsService) : super(TtsState.idle) {
    _ttsService.onStateChanged = (newState, phrase) {
      _currentPhrase = phrase;
      state = newState;
    };
  }

  String? get currentPhrase => _currentPhrase;

  Future<void> toggleSpeak(String phrase) async {
    await _ttsService.toggleSpeak(phrase);
  }

  Future<void> stop() async {
    await _ttsService.stop();
  }

  bool isPhraseCurrentlyPlaying(String phrase) {
    return _ttsService.isPhraseCurrentlyPlaying(phrase);
  }

  TtsState getStateForPhrase(String phrase) {
    return _ttsService.getStateForPhrase(phrase);
  }

  String? get errorMessage => _ttsService.errorMessage;
  bool get isAvailable => _ttsService.isAvailable;
}

final ttsServiceProvider = Provider<TtsService>((ref) {
  final service = TtsService();
  ref.onDispose(() => service.dispose());
  return service;
});

final ttsNotifierProvider =
    StateNotifierProvider<TtsNotifier, TtsState>((ref) {
  final service = ref.watch(ttsServiceProvider);
  return TtsNotifier(service);
});

// For checking specific phrase state
final phraseAudioStateProvider =
    Provider.family<TtsState, String>((ref, phrase) {
  final ttsState = ref.watch(ttsNotifierProvider);
  final notifier = ref.read(ttsNotifierProvider.notifier);

  if (notifier.currentPhrase == phrase) {
    return ttsState;
  }
  return TtsState.idle;
});
