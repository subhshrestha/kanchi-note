# Kanchi Note - Requirements Specification

## Overview

A cross-platform **Danish vocabulary/phrase dictionary** application that helps users learn and remember Danish phrases with their English meanings. The app runs locally with SQLite storage and uses a translation API to auto-generate English meanings.

---

## 1. Functional Requirements

### 1.1 Application Activation

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-003 | App runs in system tray when not active | Should |

### 1.2 Main View (Table)

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-010 | Display phrases in a 3-column table view | Must |
| FR-011 | Column 1: `phrase` - Danish text user wants to learn | Must |
| FR-012 | Column 2: `meaning` - English translation of the phrase | Must |
| FR-013 | Column 3: `my_note` - User's personal notes/mnemonics | Must |
| FR-014 | Table is sorted alphabetically by `phrase` column | Must |
| FR-015 | Users can edit existing entries inline (directly in table) | Must |
| FR-016 | Users can delete entries (with confirmation dialog) | Must |
| FR-017 | When `phrase` is edited, `meaning` is re-calculated via translation API | Must |
| FR-018 | `meaning` and `my_note` columns support multi-line text (up to ~15 words average) | Must |
| FR-019 | Long text in table cells is truncated with "..." and shows full text on hover/tooltip | Should |
| FR-022 | Table uses infinite scroll (no pagination) | Must |
| FR-020 | Each `phrase` cell has a small audio icon (🔊) to play pronunciation | Must |
| FR-021 | Clicking audio icon plays Danish text-to-speech for correct pronunciation | Must |

### 1.3 Audio Pronunciation

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-025 | Use text-to-speech API/service for Danish pronunciation | Must |
| FR-026 | Audio plays immediately when icon is clicked | Must |
| FR-027 | Clicking audio icon again stops playback (toggle behavior) | Must |
| FR-028 | Show loading indicator if audio is buffering | Should |
| FR-029 | Handle TTS errors gracefully (show message if unavailable) | Must |

### 1.4 Search

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-030 | Search input field at top of the table | Must |
| FR-031 | Search filters table by `phrase`, `meaning`, or `my_note` | Must |
| FR-032 | Search is case-insensitive | Should |
| FR-033 | Search updates results as user types (live filter) | Should |

### 1.5 Add New Phrase (Modal Form)

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-040 | "Add" button opens a modal form | Must |
| FR-041 | Modal has 3 input fields: `phrase` (single line), `meaning` (multi-line textarea), `my_note` (multi-line textarea) | Must |
| FR-042 | Modal has 2 buttons: "Submit" and "Cancel" | Must |
| FR-043 | "Cancel" closes the modal without saving | Must |
| FR-044 | "Submit" validates and saves the entry | Must |
| FR-045 | `phrase` field is **required** | Must |
| FR-046 | `meaning` field is **required** | Must |
| FR-047 | `my_note` field is **optional** | Must |
| FR-048 | User can click ✨ button to fetch English `meaning` via translation API | Must |
| FR-049 | User can manually override the auto-translated `meaning` | Should |
| FR-050 | Show loading indicator while fetching translation | Should |
| FR-051 | Show validation errors if required fields are empty | Must |
| FR-052 | Show warning if `phrase` already exists (prevent duplicates) | Must |

### 1.6 Data Persistence

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-060 | All phrases stored locally in SQLite database | Must |
| FR-061 | Data persists between application sessions | Must |
| FR-062 | Export phrases to CSV/JSON | Could |
| FR-063 | Import phrases from CSV/JSON | Could |

### 1.7 Translation Service

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-070 | Call translation API when user clicks the auto-translate button | Must |
| FR-071 | Debounce API calls (wait 500ms after user stops typing) | Should |
| FR-072 | Handle API errors gracefully with user feedback | Must |
| FR-073 | Allow manual entry if API is unavailable | Must |

---

## 2. Non-Functional Requirements

### 2.1 Platform Support

| ID | Requirement | Priority |
|----|-------------|----------|
| NFR-001 | Application runs on Windows 10/11 | Must |
| NFR-002 | Application runs on macOS 11+ | Must |
| NFR-003 | Application runs on Linux (Ubuntu 20.04+) | Must |
| NFR-004 | Consistent UI/UX across all platforms | Should |

### 2.2 Performance

| ID | Requirement | Priority |
|----|-------------|----------|
| NFR-010 | App launches in under 2 seconds | Should |
| NFR-011 | Table renders 1000+ phrases smoothly | Should |
| NFR-012 | Search filtering responds in under 100ms | Should |
| NFR-013 | Translation API response within 2 seconds | Should |

### 2.3 Security & Privacy

| ID | Requirement | Priority |
|----|-------------|----------|
| NFR-020 | All phrase data stored locally only | Must |
| NFR-021 | Only `phrase` text sent to translation API | Must |
| NFR-022 | No analytics or telemetry | Should |

### 2.4 Usability

| ID | Requirement | Priority |
|----|-------------|----------|
| NFR-030 | Minimal, clean UI focused on the table | Should |
| NFR-031 | Keyboard navigation (Tab, Enter, Esc) | Should |
| NFR-032 | Dark/Light theme support | Could |
| NFR-033 | `Esc` key closes modal and/or minimizes app | Should |

---

## 3. Technical Architecture

### 3.1 Technology Stack

| Component | Technology |
|-----------|------------|
| Framework | Flutter 3.38.0 (Desktop) |
| Language | Dart 3.8+ |
| Local Database | SQLite via `drift` |
| Translation API | MyMemory API (`https://api.mymemory.translated.net`) |
| Text-to-Speech | `flutter_tts` package (uses device's built-in TTS engine) |
| State Management | Riverpod |
| System Tray | `system_tray` package |
| Window Size | 900x600 (default) |

### 3.2 Architecture Pattern

```
┌─────────────────────────────────────────────────────────────┐
│                      Presentation Layer                      │
│   ┌─────────────┐  ┌─────────────┐  ┌─────────────────┐     │
│   │ Main Table  │  │ Search Bar  │  │ Add Phrase Modal│     │
│   │   View      │  │             │  │                 │     │
│   └─────────────┘  └─────────────┘  └─────────────────┘     │
├─────────────────────────────────────────────────────────────┤
│                      Application Layer                       │
│   ┌─────────────────────┐  ┌─────────────────────────┐      │
│   │ PhraseController    │  │ TranslationService      │      │
│   │ - getAll()          │  │ - translate(phrase)     │      │
│   │ - add(phrase)       │  │ - debounce logic        │      │
│   │ - update(phrase)    │  └─────────────────────────┘      │
│   │ - delete(id)        │                                   │
│   │ - search(query)     │                                   │
│   └─────────────────────┘                                   │
├─────────────────────────────────────────────────────────────┤
│                       Data Layer                             │
│   ┌─────────────────────┐  ┌─────────────────────────┐      │
│   │ PhraseRepository    │  │ SQLite Database         │      │
│   │ (CRUD operations)   │──│ phrases.db              │      │
│   └─────────────────────┘  └─────────────────────────┘      │
└─────────────────────────────────────────────────────────────┘
```

### 3.3 Database Schema

```sql
-- Single table for phrases
CREATE TABLE phrases (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    phrase TEXT NOT NULL,              -- Danish text
    meaning TEXT NOT NULL,             -- English translation
    my_note TEXT,                      -- User's personal note (optional)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index for alphabetical sorting and search
CREATE INDEX idx_phrase ON phrases(phrase COLLATE NOCASE);

-- Full-text search (optional, for better search performance)
CREATE VIRTUAL TABLE phrases_fts USING fts5(phrase, meaning, my_note, content='phrases');
```

### 3.4 Translation Service Design

```dart
abstract class TranslationService {
  Future<String> translate(String danishPhrase);
}

class ApiTranslationService implements TranslationService {
  final String apiKey;
  final String apiUrl;

  @override
  Future<String> translate(String danishPhrase) async {
    // Call external translation API
    // POST to API with source=da, target=en
    // Return English translation
  }
}
```

**Translation API: MyMemory API**

| Setting | Value |
|---------|-------|
| Base URL | `https://api.mymemory.translated.net` |
| Endpoint | `/get` |
| Method | GET |
| Rate Limit | 5000 chars/day (free, no API key) |
| Optional | Email for 10x more quota |

**API Usage:**
```
GET https://api.mymemory.translated.net/get?q=god+morgen&langpair=da|en

// Response:
{
  "responseStatus": 200,
  "responseData": {
    "translatedText": "good morning",
    "match": 1.0
  }
}
```

**Dart Implementation:**
```dart
class MyMemoryTranslateService implements TranslationService {
  static const String baseUrl = 'https://api.mymemory.translated.net';

  @override
  Future<String> translate(String danishPhrase) async {
    final uri = Uri.parse('$baseUrl/get').replace(
      queryParameters: {
        'q': danishPhrase,
        'langpair': 'da|en',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['responseStatus'] == 200) {
        return data['responseData']['translatedText'];
      }
    }
    throw TranslationException('Failed to translate');
  }
}
```

### 3.5 Text-to-Speech Service Design

**TTS Package: flutter_tts**

| Setting | Value |
|---------|-------|
| Package | `flutter_tts: ^4.0.2` |
| Language | Danish (`da-DK`) |
| Offline | Yes (uses device's built-in TTS) |
| Cost | Free |

**Why flutter_tts:**
- No API keys required
- Works offline using OS-native TTS engines
- Cross-platform support (Windows, macOS, Linux)
- Modern OS versions include Danish voice support
- Simple toggle (play/stop) implementation

**Dart Implementation:**
```dart
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isPlaying = false;

  Future<void> init() async {
    await _flutterTts.setLanguage('da-DK');
    await _flutterTts.setSpeechRate(0.5); // Slower for learning
    await _flutterTts.setVolume(1.0);

    _flutterTts.setCompletionHandler(() {
      _isPlaying = false;
    });
  }

  bool get isPlaying => _isPlaying;

  Future<void> speak(String text) async {
    if (_isPlaying) {
      await stop();
    } else {
      _isPlaying = true;
      await _flutterTts.speak(text);
    }
  }

  Future<void> stop() async {
    _isPlaying = false;
    await _flutterTts.stop();
  }
}
```

---

## 4. UI Wireframes

### 4.1 Main Window (Table View)

```
┌─────────────────────────────────────────────────────────────────┐
│  Kanchi Note                                        [_] [□] [X] │
├─────────────────────────────────────────────────────────────────┤
│  🔍 [Search phrases...                                ] [+ Add] │
├─────────────────────────────────────────────────────────────────┤
│  PHRASE              │ MEANING              │ MY NOTE           │
├──────────────────────┼──────────────────────┼───────────────────┤
│  af og til           │ occasionally         │ sounds like "off" │
│  god morgen          │ good morning         │                   │
│  hvordan har du det  │ how are you          │ greeting phrase   │
│  jeg forstår ikke    │ I don't understand   │ useful when lost! │
│  mange tak           │ thank you very much  │                   │
│  undskyld            │ excuse me / sorry    │ un-SKOOL          │
│  ...                 │ ...                  │ ...               │
├─────────────────────────────────────────────────────────────────┤
│  Showing 42 phrases                                             │
└─────────────────────────────────────────────────────────────────┘
```

### 4.2 Add Phrase Modal

```
┌───────────────────────────────────────────┐
│  Add New Phrase                       [X] │
├───────────────────────────────────────────┤
│                                           │
│  Phrase (Danish) *                        │
│  ┌─────────────────────────────────────┐  │
│  │ tak for mad                         │  │
│  └─────────────────────────────────────┘  │
│                                           │
│  Meaning (English) *                  ✨  │
│  ┌─────────────────────────────────────┐  │
│  │ thanks for the food                 │  │
│  └─────────────────────────────────────┘  │
│  ✨ = Click to auto-translate             │
│                                           │
│  My Note (optional)                   ✨  │
│  ┌─────────────────────────────────────┐  │
│  │ said after meals to the cook        │  │
│  └─────────────────────────────────────┘  │
│  ✨ = Click to auto-generate via AI       │
│                                           │
│         [Cancel]            [Submit]      │
│                                           │
└───────────────────────────────────────────┘
```

---

## 5. User Stories

### Epic: Quick Access
- **US-002**: As a user, I want the app to run in the background so it's always ready when I need it.

### Epic: Phrase Management
- **US-010**: As a Danish learner, I want to add new Danish phrases with their English meanings so I can build my vocabulary.
- **US-011**: As a user, I want to click a button to auto-fill the English meaning so I can get translations on demand.
- **US-012**: As a user, I want to add personal notes to phrases so I can remember them better with my own mnemonics.
- **US-013**: As a user, I want to edit phrases inline (click to edit in table) so I can quickly correct mistakes.
- **US-014**: As a user, when I edit a phrase, the meaning should auto-update so it stays in sync.
- **US-015**: As a user, I want to delete phrases I no longer need.

### Epic: Finding Phrases
- **US-020**: As a user, I want to see all phrases sorted alphabetically so I can browse them easily.
- **US-021**: As a user, I want to search across all columns so I can quickly find a phrase by Danish, English, or my notes.

---

## 6. User Flow

```
┌─────────────────┐
│ App in System   │
│ Tray (idle)     │
└────────┬────────┘
         │ User clicks tray icon or launches app
         ▼
┌─────────────────┐
│ Main Window     │◄──────────────────────────────┐
│ Opens           │                               │
└────────┬────────┘                               │
         │                                        │
    ┌────┴────┐                                   │
    ▼         ▼                                   │
┌───────┐ ┌───────────┐                           │
│Search │ │Click +Add │                           │
└───┬───┘ └─────┬─────┘                           │
    │           ▼                                 │
    │    ┌─────────────┐                          │
    │    │ Modal Opens │                          │
    │    └──────┬──────┘                          │
    │           │                                 │
    │      ┌────┴────┐                            │
    │      ▼         ▼                            │
    │ ┌────────┐ ┌────────┐                       │
    │ │Type    │ │Cancel  │───────────────────────┤
    │ │Phrase  │ └────────┘                       │
    │ └───┬────┘                                  │
    │     ▼                                       │
    │ ┌────────────────┐                          │
    │ │Click ✨ button │                          │
    │ │to translate    │                          │
    │ └───────┬────────┘                          │
    │         ▼                                   │
    │ ┌────────────────┐                          │
    │ │API translates  │                          │
    │ │→ fills meaning │                          │
    │ └───────┬────────┘                          │
    │         ▼                                   │
    │ ┌────────────────┐                          │
    │ │Optionally click│                          │
    │ │✨ for AI note  │                          │
    │ └───────┬────────┘                          │
    │         ▼                                   │
    │ ┌────────────────┐                          │
    │ │Click Submit    │                          │
    │ └───────┬────────┘                          │
    │         │                                   │
    │    ┌────┴────┐                              │
    │    ▼         ▼                              │
    │ ┌─────┐  ┌──────────┐                       │
    │ │Valid│  │Invalid   │                       │
    │ └──┬──┘  │show error│                       │
    │    │     └──────────┘                       │
    │    ▼                                        │
    │ ┌────────────────┐                          │
    │ │Save to SQLite  │                          │
    │ │Close modal     │──────────────────────────┘
    │ │Refresh table   │
    │ └────────────────┘
    │
    ▼
┌─────────────────┐
│ Filter table    │
│ in real-time    │
└─────────────────┘
```

---

## 7. Constraints & Assumptions

### Constraints
- Data stored locally only (SQLite)
- Requires internet connection for translation API calls

### Assumptions
- User has internet access for translation (manual entry fallback available)
- Desktop platforms only (Windows, macOS, Linux)
- Single user per installation (no multi-user support)

---

## 8. Future Considerations (Out of Scope for v1.0)

- Offline translation via embedded ML model
- Cloud sync across devices
- Spaced repetition / quiz mode for learning
- Import/export to Anki or other flashcard apps
- Additional language pairs
- Mobile companion app

---

## 9. Acceptance Criteria for MVP

1. ✅ Table displays phrases with 3 columns: phrase, meaning, my_note
2. ✅ Table is sorted alphabetically by phrase
3. ✅ Search filters the table across all columns
4. ✅ Add button opens modal form
5. ✅ Modal validates required fields (phrase, meaning)
6. ✅ Clicking ✨ button fetches English translation for the phrase
7. ✅ Data persists in local SQLite database
8. ✅ App runs on Windows, macOS, and Linux
9. ✅ Audio icon plays Danish pronunciation via TTS
10. ✅ Duplicate phrases are prevented with warning message
11. ✅ Delete shows confirmation dialog
