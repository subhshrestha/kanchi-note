import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../database/database.dart';

class TranslationException implements Exception {
  final String message;
  final bool isNetworkError;

  TranslationException(this.message, {this.isNetworkError = false});

  @override
  String toString() => message;
}

class TranslationService {
  static const String _baseUrl = 'https://api.mymemory.translated.net';

  final AppDatabase _database;
  Timer? _debounceTimer;

  TranslationService(this._database);

  /// Translates Danish text to English using MyMemory API with caching
  Future<String> translate(String danishPhrase) async {
    if (danishPhrase.trim().isEmpty) {
      return '';
    }

    // Check cache first
    final cached = await _database.getCachedTranslation(danishPhrase);
    if (cached != null) {
      return cached;
    }

    // Not in cache, call API
    final translation = await _translateFromApi(danishPhrase);

    // Save to cache
    await _database.cacheTranslation(danishPhrase, translation);

    return translation;
  }

  /// Calls the translation API
  Future<String> _translateFromApi(String danishPhrase) async {
    final uri = Uri.parse('$_baseUrl/get').replace(
      queryParameters: {
        'q': danishPhrase,
        'langpair': 'da|en',
      },
    );

    try {
      final response = await http.get(uri).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TranslationException(
            'Request timed out. Please check your internet connection.',
            isNetworkError: true,
          );
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['responseStatus'] == 200) {
          final translatedText =
              data['responseData']['translatedText'] as String;
          return translatedText;
        } else {
          throw TranslationException(
            data['responseDetails'] ?? 'Translation failed',
          );
        }
      } else if (response.statusCode == 429) {
        throw TranslationException(
          'Too many requests. Please wait a moment.',
        );
      } else if (response.statusCode >= 500) {
        throw TranslationException(
          'Translation service unavailable. Please try again later.',
        );
      } else {
        throw TranslationException(
          'Translation failed (Error ${response.statusCode})',
        );
      }
    } on TranslationException {
      rethrow;
    } on SocketException {
      throw TranslationException(
        'No internet connection',
        isNetworkError: true,
      );
    } on HttpException {
      throw TranslationException(
        'Network error. Please check your connection.',
        isNetworkError: true,
      );
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('Connection refused') ||
          e.toString().contains('Network is unreachable')) {
        throw TranslationException(
          'No internet connection',
          isNetworkError: true,
        );
      }
      throw TranslationException('Translation failed: ${e.toString()}');
    }
  }

  void cancelDebounce() {
    _debounceTimer?.cancel();
  }

  void dispose() {
    _debounceTimer?.cancel();
  }
}
