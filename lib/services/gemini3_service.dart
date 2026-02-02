import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../database/database.dart';

class GeminiException implements Exception {
  final String message;
  final bool isNetworkError;

  GeminiException(this.message, {this.isNetworkError = false});

  @override
  String toString() => message;
}

class GeminiService {
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:generateContent';

  final AppDatabase _database;
  String? _apiKey;

  GeminiService(this._database);

  bool get hasApiKey => _apiKey != null && _apiKey!.isNotEmpty;

  void setApiKey(String apiKey) {
    _apiKey = apiKey;
  }

  /// Get a simple English definition/explanation of a Danish phrase
  Future<String> getDefinition(String danishPhrase) async {
    if (!hasApiKey) {
      throw GeminiException('Gemini API key not configured');
    }

    if (danishPhrase.trim().isEmpty) {
      return '';
    }

    // Check cache first
    final cached = await _database.getCachedDefinition(danishPhrase);
    if (cached != null) {
      print('Definition cache hit for: $danishPhrase');
      return cached;
    }

    final uri = Uri.parse(_baseUrl);

    final prompt = '''
Explain the Danish phrase "$danishPhrase" in simple English (2-3 sentences max). Include when/how it's commonly used.
''';

    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': prompt}
          ]
        }
      ],
      'generationConfig': {
        "thinkingConfig": {
          "thinkingLevel": "low"
        }
      }
    });

    try {
      final response = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'x-goog-api-key': _apiKey!,
            },
            body: body,
          )
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              throw GeminiException(
                'Request timed out. Please check your internet connection.',
                isNetworkError: true,
              );
            },
          );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final candidates = data['candidates'] as List?;
        if (candidates != null && candidates.isNotEmpty) {
          final content = candidates[0]['content'];
          final parts = content['parts'] as List?;
          if (parts != null && parts.isNotEmpty) {
            // Debug: log each part
            for (int i = 0; i < parts.length; i++) {
              print('Part $i: ${parts[i]}');
            }
            final definition = parts
                .map((p) => p['text'] as String?)
                .where((t) => t != null && !t.startsWith('thought)'))
                .join('\n');

            // Cache the result
            await _database.cacheDefinition(danishPhrase, definition);
            print('Definition cached for: $danishPhrase');

            return definition;
          }
        }
        throw GeminiException('No response from Gemini');
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        final error = data['error']?['message'] ?? 'Bad request';
        throw GeminiException('API error: $error');
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw GeminiException('Invalid API key. Please check your Gemini API key.');
      } else if (response.statusCode == 429) {
        throw GeminiException('Rate limit exceeded. Please wait a moment.');
      } else if (response.statusCode >= 500) {
        throw GeminiException('Gemini service unavailable. Please try again later.');
      } else {
        throw GeminiException('Request failed (Error ${response.statusCode})');
      }
    } on GeminiException {
      rethrow;
    } on SocketException {
      throw GeminiException(
        'No internet connection',
        isNetworkError: true,
      );
    } on HttpException {
      throw GeminiException(
        'Network error. Please check your connection.',
        isNetworkError: true,
      );
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('Connection refused') ||
          e.toString().contains('Network is unreachable')) {
        throw GeminiException(
          'No internet connection',
          isNetworkError: true,
        );
      }
      throw GeminiException('Failed to get definition: ${e.toString()}');
    }
  }
}
