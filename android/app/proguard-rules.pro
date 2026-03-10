# Flutter engine and plugin registry
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class com.patrimonium.** { *; }

# Play Core warnings (not used, referenced by Flutter engine)
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**

# flutter_secure_storage — cipher classes use enum.valueOf() by name;
# obfuscating enum members breaks decryption on upgrade
-keep class com.it_nomads.fluttersecurestorage.** { *; }
-keep class androidx.security.crypto.** { *; }

# workmanager — BackgroundWorker extends ListenableWorker (NOT Worker);
# WorkManager instantiates by class name from job input data
-keep class dev.fluttercommunity.workmanager.BackgroundWorker { *; }
-keep class * extends androidx.work.ListenableWorker { <init>(...); }

# local_auth — belt-and-suspenders (AAR ships own rules)
-keep class androidx.biometric.** { *; }

# sqlite3_flutter_libs — plugin prefix is com.github.simolus3, not io.flutter
-keep class com.github.simolus3.sqlite3.** { *; }

# Sentry — safety net for new integration
-keep class io.sentry.** { *; }
