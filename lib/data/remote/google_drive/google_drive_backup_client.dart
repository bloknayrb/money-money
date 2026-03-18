import 'dart:typed_data';

import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;

import '../backup/backup_destination.dart';
import '../backup/backup_metadata.dart';

/// Google Drive appdata folder backup destination.
class GoogleDriveBackupClient implements BackupDestination {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [drive.DriveApi.driveAppdataScope],
  );

  drive.DriveApi? _driveApi;

  @override
  String get displayName => 'Google Drive';

  @override
  bool get requiresAuth => true;

  @override
  Future<void> signIn() async {
    final account = await _googleSignIn.signIn();
    if (account == null) {
      throw Exception('Google sign-in was cancelled');
    }
    await _initDriveApi();
  }

  @override
  Future<void> signOut() async {
    _driveApi = null;
    await _googleSignIn.signOut();
  }

  @override
  Future<bool> isAuthenticated() async {
    return _googleSignIn.isSignedIn();
  }

  @override
  Future<String> uploadFile({
    required Uint8List bytes,
    required String fileName,
    required Map<String, dynamic> metadata,
  }) async {
    final api = await _ensureDriveApi();
    final driveFile = drive.File()
      ..name = fileName
      ..parents = ['appDataFolder']
      ..description = BackupMetadata.encodeDescription(metadata);

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

  @override
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
        results.add(BackupMetadata.fromDescription(
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

  @override
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

  @override
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
    // Try existing credentials first, then attempt silent sign-in
    // (handles app reinstall / package rename where session is stale).
    var httpClient = await _googleSignIn.authenticatedClient();
    if (httpClient == null) {
      await _googleSignIn.signInSilently();
      httpClient = await _googleSignIn.authenticatedClient();
    }
    if (httpClient == null) {
      throw Exception('Failed to get authenticated HTTP client');
    }
    _driveApi = drive.DriveApi(httpClient);
  }
}
