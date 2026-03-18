/// Metadata for a stored backup, regardless of destination.
class BackupMetadata {
  final String fileId;
  final String appVersion;
  final int schemaVersion;
  final int createdAtMs;
  final int accountCount;
  final int transactionCount;
  final int fileSizeBytes;

  const BackupMetadata({
    required this.fileId,
    required this.appVersion,
    required this.schemaVersion,
    required this.createdAtMs,
    required this.accountCount,
    required this.transactionCount,
    required this.fileSizeBytes,
  });

  /// Parse from pipe-delimited key=value description string.
  ///
  /// Used by Google Drive (stored in file description) and local backups
  /// (stored in companion JSON).
  factory BackupMetadata.fromDescription({
    required String fileId,
    required String description,
    required int fileSizeBytes,
  }) {
    final map = _parseDescription(description);
    return BackupMetadata(
      fileId: fileId,
      appVersion: map['appVersion'] ?? 'unknown',
      schemaVersion: int.tryParse(map['schemaVersion'] ?? '') ?? 0,
      createdAtMs: int.tryParse(map['createdAtMs'] ?? '') ?? 0,
      accountCount: int.tryParse(map['accountCount'] ?? '') ?? 0,
      transactionCount: int.tryParse(map['transactionCount'] ?? '') ?? 0,
      fileSizeBytes: fileSizeBytes,
    );
  }

  /// Serialize to a map for storage.
  Map<String, dynamic> toDescriptionMap() {
    return {
      'appVersion': appVersion,
      'schemaVersion': schemaVersion,
      'createdAtMs': createdAtMs,
      'accountCount': accountCount,
      'transactionCount': transactionCount,
    };
  }

  /// Encode metadata map as pipe-delimited key=value string.
  static String encodeDescription(Map<String, dynamic> metadata) {
    final buffer = StringBuffer();
    metadata.forEach((key, value) {
      if (buffer.isNotEmpty) buffer.write('|');
      buffer.write('$key=$value');
    });
    return buffer.toString();
  }

  static Map<String, String> _parseDescription(String description) {
    final map = <String, String>{};
    for (final pair in description.split('|')) {
      final index = pair.indexOf('=');
      if (index > 0) {
        map[pair.substring(0, index)] = pair.substring(index + 1);
      }
    }
    return map;
  }
}
