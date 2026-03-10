import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';

import '../../../core/constants/app_constants.dart';

/// Task name for WorkManager registration.
const backgroundSyncTaskName = 'simplefin_sync';

/// Manages registration and cancellation of background sync tasks.
///
/// Uses WorkManager on Android and Timer.periodic on Linux desktop.
class BackgroundSyncManager {
  BackgroundSyncManager();

  Timer? _linuxTimer;
  bool _registered = false;

  /// Register periodic background sync.
  Future<void> register({
    required Future<void> Function() syncCallback,
  }) async {
    if (_registered) return;

    const interval = Duration(
      hours: AppConstants.backgroundSyncIntervalHours,
    );

    if (Platform.isAndroid) {
      await Workmanager().registerPeriodicTask(
        backgroundSyncTaskName,
        backgroundSyncTaskName,
        frequency: interval,
        constraints: Constraints(
          networkType: NetworkType.connected,
        ),
        existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
      );
    } else if (Platform.isLinux) {
      // Linux: in-process timer (runs only while app is open)
      _linuxTimer = Timer.periodic(interval, (_) async {
        try {
          await syncCallback();
        } catch (e) {
          if (kDebugMode) {
            debugPrint('Background sync error: $e');
          }
        }
      });
    }

    _registered = true;
  }

  /// Cancel all background sync tasks.
  Future<void> cancel() async {
    if (Platform.isAndroid) {
      await Workmanager().cancelByUniqueName(backgroundSyncTaskName);
    }
    _linuxTimer?.cancel();
    _linuxTimer = null;
    _registered = false;
  }

  /// Whether background sync is currently registered.
  bool get isRegistered => _registered;
}
