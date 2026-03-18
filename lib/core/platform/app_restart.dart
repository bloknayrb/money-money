import 'dart:io';

import 'package:flutter/services.dart';

/// Restarts the app using a platform channel on Android.
/// Returns true if restart was initiated, false if not supported (Linux).
Future<bool> restartApp() async {
  if (!Platform.isAndroid) return false;

  const channel = MethodChannel('com.moneymoney.app/app_restart');
  try {
    await channel.invokeMethod('restart');
    return true;
  } on PlatformException {
    return false;
  }
}
