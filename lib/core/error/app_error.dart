/// Base class for all application errors.
sealed class AppError implements Exception {
  final String message;
  final String? technicalDetails;
  final Object? originalError;

  const AppError({
    required this.message,
    this.technicalDetails,
    this.originalError,
  });

  /// User-friendly error message.
  String get userMessage => message;
}

/// Network-related errors (API calls, connectivity).
class NetworkError extends AppError {
  final int? statusCode;

  const NetworkError({
    required super.message,
    this.statusCode,
    super.technicalDetails,
    super.originalError,
  });

  factory NetworkError.timeout() => const NetworkError(
        message: 'Request timed out. Please check your connection and try again.',
      );

  factory NetworkError.noConnection() => const NetworkError(
        message: 'No internet connection. Your data is saved locally and will sync when you reconnect.',
      );

  factory NetworkError.serverError([int? code]) => NetworkError(
        message: 'Something went wrong on the server. Please try again later.',
        statusCode: code,
      );
}

/// Database-related errors.
class DatabaseError extends AppError {
  const DatabaseError({
    required super.message,
    super.technicalDetails,
    super.originalError,
  });

  factory DatabaseError.corruption() => const DatabaseError(
        message: 'There was an issue with your data. Attempting to restore from backup.',
      );

  factory DatabaseError.migrationFailed() => const DatabaseError(
        message: 'Failed to update the database. Please restart the app.',
      );
}

/// Authentication and security errors.
class AuthError extends AppError {
  const AuthError({
    required super.message,
    super.technicalDetails,
    super.originalError,
  });

  factory AuthError.invalidPin() => const AuthError(
        message: 'Incorrect PIN. Please try again.',
      );

  factory AuthError.biometricFailed() => const AuthError(
        message: 'Biometric authentication failed. Please use your PIN.',
      );

  factory AuthError.locked(int seconds) => AuthError(
        message: 'Too many attempts. Try again in ${seconds ~/ 60} minutes.',
      );

  factory AuthError.sessionExpired() => const AuthError(
        message: 'Your session has expired. Please sign in again.',
      );
}

/// Bank sync errors.
class BankSyncError extends AppError {
  const BankSyncError({
    required super.message,
    super.technicalDetails,
    super.originalError,
  });

  factory BankSyncError.connectionFailed(String institution) => BankSyncError(
        message: 'Unable to connect to $institution. Please try again later.',
      );

  factory BankSyncError.reAuthRequired(String institution) => BankSyncError(
        message: '$institution requires you to re-authenticate. Please reconnect your account.',
      );

  factory BankSyncError.rateLimited() => const BankSyncError(
        message: 'Too many sync attempts. Please wait a few minutes.',
      );

  factory BankSyncError.circuitOpen() => const BankSyncError(
        message: 'Bank sync is temporarily paused due to repeated failures. Will retry automatically.',
      );

  factory BankSyncError.paymentRequired() => const BankSyncError(
        message: 'SimpleFIN subscription payment required. Please check your account at simplefin.org.',
      );

  factory BankSyncError.tokenCompromised() => const BankSyncError(
        message: 'Setup token already claimed or compromised. Please generate a new token from simplefin.org.',
      );
}

/// LLM/AI-related errors.
class LLMError extends AppError {
  const LLMError({
    required super.message,
    super.technicalDetails,
    super.originalError,
  });

  factory LLMError.apiError(String provider) => LLMError(
        message: 'The AI assistant is having trouble right now. Try again in a moment.',
        technicalDetails: '$provider API returned an error.',
      );

  factory LLMError.timeout() => const LLMError(
        message: 'The AI is taking longer than usual. Try again or switch to a different provider.',
      );

  factory LLMError.rateLimited() => const LLMError(
        message: 'You\'ve reached the AI usage limit. Try again in a few minutes.',
      );

  factory LLMError.invalidApiKey(String provider) => LLMError(
        message: 'Your $provider API key is invalid. Please update it in Settings.',
      );

  factory LLMError.ollamaNotRunning() => const LLMError(
        message: 'Ollama is not running. Please start Ollama and try again.',
      );
}

/// Unexpected errors that don't fit a specific category.
class UnexpectedError extends AppError {
  const UnexpectedError({
    required super.message,
    super.technicalDetails,
    super.originalError,
  });
}

/// Import/export errors.
class ImportError extends AppError {
  final int? failedRow;

  const ImportError({
    required super.message,
    this.failedRow,
    super.technicalDetails,
    super.originalError,
  });

  factory ImportError.invalidFormat(String expected) => ImportError(
        message: 'The file format is not recognized. Expected $expected format.',
      );

  factory ImportError.parseFailed(int row, String detail) => ImportError(
        message: 'Failed to parse row $row: $detail',
        failedRow: row,
      );
}

/// Converts raw exceptions to user-friendly AppErrors.
class ErrorHandler {
  const ErrorHandler._();

  /// Convert any exception to an AppError.
  static AppError handle(Object error, [StackTrace? stackTrace]) {
    if (error is AppError) return error;

    // Unwrap DioException if it contains an AppError
    if (error.runtimeType.toString() == 'DioException') {
      dynamic dioError = error;
      if (dioError.error is AppError) {
        return dioError.error as AppError;
      }
    }

    final message = error.toString();

    // Network errors
    if (message.contains('SocketException') || message.contains('Connection refused')) {
      return NetworkError.noConnection();
    }
    if (message.contains('TimeoutException')) {
      return NetworkError.timeout();
    }

    // Database errors
    if (message.contains('SqliteException') || message.contains('database is locked')) {
      return DatabaseError(
        message: 'A database error occurred. Please restart the app.',
        technicalDetails: message,
        originalError: error,
      );
    }

    // Fallback
    return UnexpectedError(
      message: 'An unexpected error occurred. Please try again.',
      technicalDetails: message,
      originalError: error,
    );
  }
}
