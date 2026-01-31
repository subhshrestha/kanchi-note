import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/translation_service.dart';
import 'database_provider.dart';

final translationServiceProvider = Provider<TranslationService>((ref) {
  final database = ref.watch(databaseProvider);
  final service = TranslationService(database);
  ref.onDispose(() => service.dispose());
  return service;
});

class TranslationState {
  final bool isLoading;
  final String? translation;
  final String? error;

  const TranslationState({
    this.isLoading = false,
    this.translation,
    this.error,
  });

  TranslationState copyWith({
    bool? isLoading,
    String? translation,
    String? error,
  }) {
    return TranslationState(
      isLoading: isLoading ?? this.isLoading,
      translation: translation ?? this.translation,
      error: error,
    );
  }
}

class TranslationNotifier extends StateNotifier<TranslationState> {
  final TranslationService _service;
  Timer? _debounceTimer;

  TranslationNotifier(this._service) : super(const TranslationState());

  void translateWithDebounce(String danishPhrase) {
    if (danishPhrase.trim().isEmpty) {
      state = const TranslationState();
      return;
    }

    _debounceTimer?.cancel();
    // Clear old translation when starting new request
    state = const TranslationState(isLoading: true);

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      try {
        final result = await _service.translate(danishPhrase);
        state = TranslationState(translation: result);
      } catch (e) {
        state = TranslationState(error: e.toString());
      }
    });
  }

  Future<String?> translateImmediate(String danishPhrase) async {
    if (danishPhrase.trim().isEmpty) {
      return null;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _service.translate(danishPhrase);
      state = TranslationState(translation: result);
      return result;
    } catch (e) {
      state = TranslationState(error: e.toString());
      return null;
    }
  }

  void clear() {
    _debounceTimer?.cancel();
    state = const TranslationState();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

final translationNotifierProvider =
    StateNotifierProvider.autoDispose<TranslationNotifier, TranslationState>(
        (ref) {
  final service = ref.watch(translationServiceProvider);
  return TranslationNotifier(service);
});
