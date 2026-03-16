import 'dart:typed_data';

import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;

import 'backup_metadata.dart';

/// Client for Google Drive appdata folder backup operations.
class GoogleDriveBackupClient {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [drive.DriveApi.driveAppdataScope],
  );

  drive.DriveApi? _driveApi;

  /// Sign in to Google and initialize Drive API.
  Future<void> signIn() async {
    final account = await _googleSignIn.signIn();
    if (account == null) {
      throw Exception('Google sign-in was cancelled');
    }
    await _initDriveApi();
  }

  /// Sign out from Google.
  Future<void> signOut() async {
    _driveApi = null;
    await _googleSignIn.signOut();
  }

  /// Whether the user is currently signed in.
  Future<bool> isSignedIn() async {
    return _googleSignIn.isSignedIn();
  }

  /// Upload a file to the appdata folder with metadata in the description.
  Future<String> uploadFile({
    required Uint8List bytes,
    required String fileName,
    required Map<String, dynamic> metadata,
  }) async {
    final api = await _ensureDriveApi();
    final driveFile = drive.File()
      ..name = fileName
      ..parents = ['appDataFolder']
      ..description = _encodeMetadata(metadata);

    final media = drive.Media(
      Stream.value(bytes),
      bytes.length,
    );

    final result = await api.files.create(
      driveFile,
      uploadMedia: media,
    );

    if (result.id == null) {
      throw Exception('Upload succeeded but no file ID returned');
    }
    return result.id!;
  }

  /// List files in the appdata folder, returning parsed metadata.
  Future<List<BackupMetadata>> listFiles() async {
    final api = await _ensureDriveApi();
    final fileList = await api.files.list(
      spaces: 'appDataFolder',
      $fields: 'files(id, name, description, size, createdTime)',
      orderBy: 'createdTime desc',
    );

    final results = <BackupMetadata>[];
    for (final file in fileList.files ?? []) {
      if (file.id == null || file.description == null) continue;
      try {
        results.add(BackupMetadata.fromDriveFile(
          fileId: file.id!,
          description: file.description!,
          fileSizeBytes: int.tryParse(file.size ?? '0') ?? 0,
        ));
      } catch (_) {
        // Skip files with invalid metadata
      }
    }
    return results;
  }

  /// Download a file by ID, returning its bytes.
  Future<Uint8List> downloadFile(String fileId) async {
    final api = await _ensureDriveApi();
    final media = await api.files.get(
      fileId,
      downloadOptions: drive.DownloadOptions.fullMedia,
    ) as drive.Media;

    final chunks = <List<int>>[];
    await for (final chunk in media.stream) {
      chunks.add(chunk);
    }
    return Uint8List.fromList(chunks.expand((c) => c).toList());
  }

  /// Delete a file by ID.
  Future<void> deleteFile(String fileId) async {
    final api = await _ensureDriveApi();
    await api.files.delete(fileId);
  }

  Future<drive.DriveApi> _ensureDriveApi() async {
    if (_driveApi != null) return _driveApi!;
    await _initDriveApi();
    return _driveApi!;
  }

  Future<void> _initDriveApi() async {
    final httpClient = await _googleSignIn.authenticatedClient();
    if (httpClient == null) {
      throw Exception('Failed to get authenticated HTTP client');
    }
    _driveApi = drive.DriveApi(httpClient);
  }

  String _encodeMetadata(Map<String, dynamic> metadata) {
    // Simple key=value encoding for Drive file description.
    // Avoids pulling in dart:convert for JSON in a small map.
    final buffer = StringBuffer();
    metadata.forEach((key, value) {
      if (buffer.isNotEmpty) buffer.write('|');
      buffer.write('$key=$value');
    });
    return buffer.toString();
  }
}
