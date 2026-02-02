import '../database/database.dart';
import 'gemini3_service.dart' as gemini3;
import 'gemini2_service.dart' as gemini2;

class GeminiException implements Exception {
  final String message;
  final bool isNetworkError;

  GeminiException(this.message, {this.isNetworkError = false});

  @override
  String toString() => message;
}

class GeminiService {
  final gemini3.GeminiService _gemini3Service;
  final gemini2.GeminiService _gemini2Service;

  GeminiService(AppDatabase database)
      : _gemini3Service = gemini3.GeminiService(database),
        _gemini2Service = gemini2.GeminiService(database);

  bool get hasApiKey => _gemini3Service.hasApiKey;

  void setApiKey(String apiKey) {
    _gemini3Service.setApiKey(apiKey);
    _gemini2Service.setApiKey(apiKey);
  }

  /// Get a simple English definition/explanation of a Danish phrase
  /// Tries gemini3 first, falls back to gemini2 on quota exceeded
  Future<String> getDefinition(String danishPhrase) async {
    try {
      print('Trying gemini3...');
      return await _gemini3Service.getDefinition(danishPhrase);
    } on gemini3.GeminiException catch (e) {
      if (e.message.contains('Rate limit exceeded') ||
          e.message.contains('quota') ||
          e.message.contains('429')) {
        print('Gemini3 quota exceeded, falling back to gemini2...');
        try {
          return await _gemini2Service.getDefinition(danishPhrase);
        } on gemini2.GeminiException catch (e2) {
          throw GeminiException(e2.message, isNetworkError: e2.isNetworkError);
        }
      }
      throw GeminiException(e.message, isNetworkError: e.isNetworkError);
    }
  }
}
