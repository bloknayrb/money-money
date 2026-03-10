import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dynamic_color/dynamic_color.dart';

import 'core/constants/app_constants.dart';
import 'core/di/providers.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

/// Root application widget.
class PatrimoniumApp extends ConsumerWidget {
  const PatrimoniumApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Eagerly load persisted theme preference.
    ref.watch(themeModeInitProvider);
    final appThemeMode = ref.watch(appThemeModeProvider);
    final router = ref.watch(appRouterProvider);

    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        final ThemeMode themeMode;
        final ThemeData theme;
        final ThemeData darkTheme;

        switch (appThemeMode) {
          case AppThemeMode.system:
            themeMode = ThemeMode.system;
            theme = AppTheme.light(lightDynamic);
            darkTheme = AppTheme.dark(darkDynamic);
          case AppThemeMode.light:
            themeMode = ThemeMode.light;
            theme = AppTheme.light(lightDynamic);
            darkTheme = AppTheme.dark(darkDynamic);
          case AppThemeMode.dark:
            themeMode = ThemeMode.dark;
            theme = AppTheme.dark(darkDynamic);
            darkTheme = AppTheme.dark(darkDynamic);
          case AppThemeMode.amoledBlack:
            themeMode = ThemeMode.dark;
            theme = AppTheme.light();
            darkTheme = AppTheme.amoledBlack();
        }

        return MaterialApp.router(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          themeMode: themeMode,
          theme: theme,
          darkTheme: darkTheme,
          routerConfig: router,
          builder: (context, child) {
            return _BackgroundSyncInitializer(
              child: _AutoLockObserver(child: child ?? const SizedBox.shrink()),
            );
          },
        );
      },
    );
  }
}

/// Observes app lifecycle to auto-lock after the configured timeout.
class _AutoLockObserver extends ConsumerStatefulWidget {
  final Widget child;

  const _AutoLockObserver({required this.child});

  @override
  ConsumerState<_AutoLockObserver> createState() => _AutoLockObserverState();
}

class _AutoLockObserverState extends ConsumerState<_AutoLockObserver>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    final isUnlocked = ref.read(isUnlockedProvider);
    if (!isUnlocked) return; // Only track if app is unlocked

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      // App went to background — record the time
      ref.read(lastPausedAtProvider.notifier).state = DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      // App came back — check if timeout has elapsed
      _checkAutoLock();
    }
  }

  Future<void> _checkAutoLock() async {
    final lastPaused = ref.read(lastPausedAtProvider);
    if (lastPaused == null) return;

    final timeoutSeconds =
        await ref.read(secureStorageProvider).getAutoLockTimeoutSeconds();
    final elapsed = DateTime.now().difference(lastPaused);

    if (elapsed.inSeconds >= timeoutSeconds) {
      // Lock the app
      ref.read(isUnlockedProvider.notifier).state = false;
      ref.read(lastPausedAtProvider.notifier).state = null;

      // Navigate to lock screen
      final router = ref.read(appRouterProvider);
      router.go(AppRoutes.lock);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// Registers background sync on startup if auto-sync is enabled and
/// bank connections exist. Android-only for v1 (WorkManager).
class _BackgroundSyncInitializer extends ConsumerStatefulWidget {
  final Widget child;

  const _BackgroundSyncInitializer({required this.child});

  @override
  ConsumerState<_BackgroundSyncInitializer> createState() =>
      _BackgroundSyncInitializerState();
}

class _BackgroundSyncInitializerState
    extends ConsumerState<_BackgroundSyncInitializer> {
  @override
  void initState() {
    super.initState();
    _maybeRegisterSync();
  }

  Future<void> _maybeRegisterSync() async {
    try {
      final storage = ref.read(secureStorageProvider);
      final enabled = await storage.getAutoSyncEnabled();
      if (!enabled) return;

      final connectionRepo = ref.read(bankConnectionRepositoryProvider);
      final connections = await connectionRepo.getAllConnections();
      if (connections.isEmpty) return;

      final syncManager = ref.read(backgroundSyncManagerProvider);
      final syncService = ref.read(simplefinSyncServiceProvider);
      final connRepo = ref.read(bankConnectionRepositoryProvider);

      await syncManager.register(syncCallback: () async {
        final conns = await connRepo.getAllConnections();
        for (final conn in conns) {
          if (conn.status != 'connected') continue;
          await syncService.syncConnection(conn.id);
        }
      });
    } catch (e) {
      if (kDebugMode) debugPrint('Background sync registration failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
