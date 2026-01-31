import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:system_tray/system_tray.dart';
import 'package:window_manager/window_manager.dart';

import 'app.dart';
import 'providers/tts_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize window manager
  await windowManager.ensureInitialized();

  const windowOptions = WindowOptions(
    size: Size(900, 600),
    minimumSize: Size(600, 400),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
    title: 'Kanchi Note',
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(
    const ProviderScope(
      child: AppInitializer(),
    ),
  );
}

class AppInitializer extends ConsumerStatefulWidget {
  const AppInitializer({super.key});

  @override
  ConsumerState<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends ConsumerState<AppInitializer>
    with WindowListener {
  final SystemTray _systemTray = SystemTray();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _initializeApp();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    hotKeyManager.unregisterAll();
    super.dispose();
  }

  Future<void> _initializeApp() async {
    // Initialize TTS
    await ref.read(ttsServiceProvider).init();

    // Initialize system tray
    await _initSystemTray();

    // Initialize global hotkeys
    await _initHotkeys();

    setState(() {
      _isInitialized = true;
    });
  }

  Future<void> _initSystemTray() async {
    // Use platform-specific icon path
    String iconPath;
    if (Platform.isWindows) {
      iconPath = 'assets/app_icon.ico';
    } else if (Platform.isMacOS) {
      iconPath = 'assets/app_icon.png';
    } else {
      iconPath = 'assets/app_icon.png';
    }

    await _systemTray.initSystemTray(
      title: 'Kanchi Note',
      iconPath: iconPath,
      toolTip: 'Kanchi Note - Danish Vocabulary',
    );

    final menu = Menu();
    await menu.buildFrom([
      MenuItemLabel(
        label: 'Open',
        onClicked: (menuItem) => _showWindow(),
      ),
      MenuSeparator(),
      MenuItemLabel(
        label: 'Quit',
        onClicked: (menuItem) => _quit(),
      ),
    ]);

    await _systemTray.setContextMenu(menu);

    _systemTray.registerSystemTrayEventHandler((eventName) {
      if (eventName == kSystemTrayEventClick) {
        _toggleWindow();
      } else if (eventName == kSystemTrayEventRightClick) {
        _systemTray.popUpContextMenu();
      }
    });
  }

  Future<void> _initHotkeys() async {
    try {
      // Register CTRL+SHIFT+N
      final hotkeyCtrlShiftN = HotKey(
        key: LogicalKeyboardKey.keyN,
        modifiers: [HotKeyModifier.control, HotKeyModifier.shift],
        scope: HotKeyScope.system,
      );

      await hotKeyManager.register(hotkeyCtrlShiftN, keyDownHandler: (hotKey) {
        _toggleWindow();
      });

      // Register SUPER+N (Meta key)
      final hotkeySuperN = HotKey(
        key: LogicalKeyboardKey.keyN,
        modifiers: [HotKeyModifier.meta],
        scope: HotKeyScope.system,
      );

      await hotKeyManager.register(hotkeySuperN, keyDownHandler: (hotKey) {
        _toggleWindow();
      });
    } catch (e) {
      debugPrint('Failed to register hotkeys: $e');
    }
  }

  Future<void> _toggleWindow() async {
    final isVisible = await windowManager.isVisible();
    if (isVisible) {
      await windowManager.hide();
    } else {
      await _showWindow();
    }
  }

  Future<void> _showWindow() async {
    await windowManager.show();
    await windowManager.focus();
  }

  Future<void> _quit() async {
    await windowManager.destroy();
    exit(0);
  }

  // Minimize to tray instead of closing
  @override
  void onWindowClose() async {
    await windowManager.hide();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  'Initializing Kanchi Note...',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return const KanchiNoteApp();
  }
}
