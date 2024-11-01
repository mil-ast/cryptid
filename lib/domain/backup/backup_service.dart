import 'dart:io';

import 'package:cryptid/domain/backup/ibackup.dart';
import 'package:cryptid/models/properties_model.dart';
import 'package:flutter/foundation.dart';
import 'package:webdav_client/webdav_client.dart' as webdav;

class BackupService implements IBackupService {
  @override
  Future<void> createBackup(Uint8List encryptedData, List<BackupValue> backup) async {
    final List<Object> errors = [];
    for (final b in backup) {
      try {
        switch (b) {
          case BackupWebDav():
            _webDavBackup(encryptedData, b);
            break;
          case BackupFile():
            _fileBackup(encryptedData, b);
            break;
          case BackupDisabled():
        }
      } catch (e) {
        errors.add(e);
      }
    }

    if (errors.isNotEmpty) {
      throw errors;
    }
  }

  Future<void> _fileBackup(Uint8List encryptedData, BackupFile b) async {
    final File file = File(b.path);
    await file.writeAsBytes(encryptedData);
  }

  Future<void> _webDavBackup(Uint8List encryptedData, BackupWebDav b) async {
    final client = webdav.newClient(
      b.host,
      user: b.login,
      password: b.password,
      debug: kDebugMode,
    );
    client.setHeaders({'content-type': 'application/octet-stream'});
    await client.write(b.filePath, encryptedData);
  }
}
