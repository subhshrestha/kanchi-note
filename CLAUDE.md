# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Kanchi Note is a Flutter desktop application (Linux/macOS) for managing Danish vocabulary and phrases. It features phrase storage, auto-translation (Danish to English via MyMemory API), AI-powered definitions (via Google Gemini API), and text-to-speech.

## Development Commands

```bash
# Install dependencies
flutter pub get

# Generate Drift database code (required after modifying database.dart)
flutter pub run build_runner build --delete-conflicting-outputs

# Run the app
flutter run

# Run with Gemini API enabled
GEMINI_API_KEY=your_key flutter run

# Run tests
flutter test

# Build for release
flutter build linux --release
flutter build macos --release
```

## Architecture

### State Management
Uses **flutter_riverpod** for state management. Providers are in `lib/providers/`:
- `database_provider.dart` - Exposes the AppDatabase singleton
- `phrase_provider.dart` - Phrase CRUD operations and search filtering
- `gemini_provider.dart` - Gemini AI service provider
- `translation_provider.dart` - Translation service provider
- `tts_provider.dart` - Text-to-speech provider

### Database
Uses **Drift** (SQLite) with code generation. Schema is in `lib/database/database.dart`:
- `Phrases` - Main vocabulary table (phrase, meaning, myNote)
- `TranslationCache` - Cached translations from MyMemory API
- `DefinitionCache` - Cached AI definitions from Gemini

After modifying the database schema, regenerate code with `flutter pub run build_runner build --delete-conflicting-outputs`.

### Services (`lib/services/`)
- `gemini_service.dart` - Facade that tries gemini3 first, falls back to gemini2 on rate limit
- `gemini3_service.dart` / `gemini2_service.dart` - Direct Gemini API clients
- `translation_service.dart` - MyMemory translation API with caching
- `tts_service.dart` - Text-to-speech wrapper

### Application Entry
`lib/main.dart` handles window management (via window_manager), system tray integration, and initializes services before rendering the app.

## Linux Dependencies

For local development on Linux:
```bash
sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev libkeybinder-3.0-dev libayatana-appindicator3-dev libspeechd-dev
```
