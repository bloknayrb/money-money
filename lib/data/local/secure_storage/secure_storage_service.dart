import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure storage service for credentials and sensitive data.
///
/// Wraps [FlutterSecureStorage] with typed methods for app-specific keys.
/// Uses Android EncryptedSharedPreferences and libsecret on Linux.
class SecureStorageService {
  SecureStorageService() : _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    lOptions: LinuxOptions(),
  );

  final FlutterSecureStorage _storage;

  // ─── Key constants ───────────────────────────────────────────────

  static const _pinHash = 'pin_hash';
  static const _pinSalt = 'pin_salt';
  static const _biometricEnabled = 'biometric_enabled';
  static const _autoLockTimeout = 'auto_lock_timeout';
  static const _autoSyncEnabled = 'auto_sync_enabled';

  static const _simplefinToken = 'simplefin_token';
  static const _simplefinSetupUrl = 'simplefin_setup_url';

  static const _claudeApiKey = 'llm_claude_api_key';
  static const _openaiApiKey = 'llm_openai_api_key';
  static const _geminiApiKey = 'llm_gemini_api_key';
  static const _ollamaUrl = 'llm_ollama_url';
  static const _activeLlmProvider = 'llm_active_provider';
  static const _activeLlmModel = 'llm_active_model';
  static const _llmConsentGiven = 'llm_cloud_consent';

  static const _themeMode = 'theme_mode';

  static const _supabaseUrl = 'supabase_url';
  static const _supabaseAnonKey = 'supabase_anon_key';
  static const _supabaseSessionToken = 'supabase_session_token';

  // ─── PIN ──────────────────────────────────────────────────────────

  Future<bool> hasPin() async {
    final hash = await _storage.read(key: _pinHash);
    return hash != null && hash.isNotEmpty;
  }

  Future<void> setPinHash(String hash, String salt) async {
    await _storage.write(key: _pinHash, value: hash);
    await _storage.write(key: _pinSalt, value: salt);
  }

  Future<String?> getPinHash() => _storage.read(key: _pinHash);
  Future<String?> getPinSalt() => _storage.read(key: _pinSalt);

  Future<void> clearPin() async {
    await _storage.delete(key: _pinHash);
    await _storage.delete(key: _pinSalt);
  }

  // ─── Biometric ────────────────────────────────────────────────────

  Future<bool> isBiometricEnabled() async {
    final value = await _storage.read(key: _biometricEnabled);
    return value == 'true';
  }

  Future<void> setBiometricEnabled(bool enabled) =>
      _storage.write(key: _biometricEnabled, value: enabled.toString());

  // ─── Auto-lock ────────────────────────────────────────────────────

  Future<int> getAutoLockTimeoutSeconds() async {
    final value = await _storage.read(key: _autoLockTimeout);
    return value != null ? int.tryParse(value) ?? 300 : 300;
  }

  Future<void> setAutoLockTimeoutSeconds(int seconds) =>
      _storage.write(key: _autoLockTimeout, value: seconds.toString());

  // ─── Theme ──────────────────────────────────────────────────────

  Future<String?> getThemeMode() => _storage.read(key: _themeMode);

  Future<void> setThemeMode(String mode) =>
      _storage.write(key: _themeMode, value: mode);

  // ─── Auto-sync ───────────────────────────────────────────────────

  Future<bool> getAutoSyncEnabled() async {
    final value = await _storage.read(key: _autoSyncEnabled);
    return value == 'true';
  }

  Future<void> setAutoSyncEnabled(bool enabled) =>
      _storage.write(key: _autoSyncEnabled, value: enabled.toString());

  // ─── SimpleFIN ────────────────────────────────────────────────────

  Future<String?> getSimplefinToken() => _storage.read(key: _simplefinToken);
  Future<void> setSimplefinToken(String token) =>
      _storage.write(key: _simplefinToken, value: token);
  Future<void> clearSimplefinToken() => _storage.delete(key: _simplefinToken);

  Future<String?> getSimplefinSetupUrl() =>
      _storage.read(key: _simplefinSetupUrl);
  Future<void> setSimplefinSetupUrl(String url) =>
      _storage.write(key: _simplefinSetupUrl, value: url);

  // ─── LLM API Keys ────────────────────────────────────────────────

  Future<String?> getLlmApiKey(String provider) async {
    switch (provider) {
      case 'claude':
        return _storage.read(key: _claudeApiKey);
      case 'openai':
        return _storage.read(key: _openaiApiKey);
      case 'gemini':
        return _storage.read(key: _geminiApiKey);
      case 'ollama':
        return _storage.read(key: _ollamaUrl);
      default:
        return null;
    }
  }

  Future<void> setLlmApiKey(String provider, String key) async {
    switch (provider) {
      case 'claude':
        await _storage.write(key: _claudeApiKey, value: key);
      case 'openai':
        await _storage.write(key: _openaiApiKey, value: key);
      case 'gemini':
        await _storage.write(key: _geminiApiKey, value: key);
      case 'ollama':
        await _storage.write(key: _ollamaUrl, value: key);
    }
  }

  Future<void> clearLlmApiKey(String provider) async {
    switch (provider) {
      case 'claude':
        await _storage.delete(key: _claudeApiKey);
      case 'openai':
        await _storage.delete(key: _openaiApiKey);
      case 'gemini':
        await _storage.delete(key: _geminiApiKey);
      case 'ollama':
        await _storage.delete(key: _ollamaUrl);
    }
  }

  Future<String?> getActiveLlmProvider() =>
      _storage.read(key: _activeLlmProvider);
  Future<void> setActiveLlmProvider(String provider) =>
      _storage.write(key: _activeLlmProvider, value: provider);

  Future<String?> getActiveLlmModel() =>
      _storage.read(key: _activeLlmModel);
  Future<void> setActiveLlmModel(String model) =>
      _storage.write(key: _activeLlmModel, value: model);

  Future<bool> getLlmCloudConsentGiven() async {
    final value = await _storage.read(key: _llmConsentGiven);
    return value == 'true';
  }

  Future<void> setLlmCloudConsentGiven() =>
      _storage.write(key: _llmConsentGiven, value: 'true');

  // ─── Supabase ─────────────────────────────────────────────────────

  Future<String?> getSupabaseUrl() => _storage.read(key: _supabaseUrl);
  Future<void> setSupabaseUrl(String url) =>
      _storage.write(key: _supabaseUrl, value: url);

  Future<String?> getSupabaseAnonKey() =>
      _storage.read(key: _supabaseAnonKey);
  Future<void> setSupabaseAnonKey(String key) =>
      _storage.write(key: _supabaseAnonKey, value: key);

  Future<String?> getSupabaseSessionToken() =>
      _storage.read(key: _supabaseSessionToken);
  Future<void> setSupabaseSessionToken(String token) =>
      _storage.write(key: _supabaseSessionToken, value: token);
  Future<void> clearSupabaseSession() =>
      _storage.delete(key: _supabaseSessionToken);

  // ─── Reset ────────────────────────────────────────────────────────

  /// Deletes all stored credentials. Used for logout or data reset.
  Future<void> clearAll() => _storage.deleteAll();
}
