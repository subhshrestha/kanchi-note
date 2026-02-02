import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/gemini_service.dart';
import 'database_provider.dart';

final geminiServiceProvider = Provider<GeminiService>((ref) {
  final database = ref.watch(databaseProvider);
  return GeminiService(database);
});

class GeminiState {
  final bool isLoading;
  final String? definition;
  final String? error;

  const GeminiState({
    this.isLoading = false,
    this.definition,
    this.error,
  });

  GeminiState copyWith({
    bool? isLoading,
    String? definition,
    String? error,
  }) {
    return GeminiState(
      isLoading: isLoading ?? this.isLoading,
      definition: definition ?? this.definition,
      error: error,
    );
  }
}

class GeminiNotifier extends StateNotifier<GeminiState> {
  final GeminiService _service;
  Timer? _debounceTimer;

  GeminiNotifier(this._service) : super(const GeminiState());

  bool get hasApiKey => _service.hasApiKey;

  void setApiKey(String apiKey) {
    _service.setApiKey(apiKey);
  }

  void getDefinitionWithDebounce(String danishPhrase) {
    if (danishPhrase.trim().isEmpty || !_service.hasApiKey) {
      state = const GeminiState();
      return;
    }

    _debounceTimer?.cancel();
    state = const GeminiState(isLoading: true);

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      try {
        final result = await _service.getDefinition(danishPhrase);
        state = GeminiState(definition: result);
      } catch (e) {
        state = GeminiState(error: e.toString());
      }
    });
  }

  Future<String?> getDefinitionImmediate(String danishPhrase) async {
    if (danishPhrase.trim().isEmpty) {
      return null;
    }

    if (!_service.hasApiKey) {
      state = const GeminiState(error: 'Gemini API key not configured');
      return null;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _service.getDefinition(danishPhrase);
      state = GeminiState(definition: result);
      return result;
    } catch (e) {
      state = GeminiState(error: e.toString());
      return null;
    }
  }

  void clear() {
    _debounceTimer?.cancel();
    state = const GeminiState();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

final geminiNotifierProvider =
    StateNotifierProvider.autoDispose<GeminiNotifier, GeminiState>((ref) {
  final service = ref.watch(geminiServiceProvider);
  return GeminiNotifier(service);
});
