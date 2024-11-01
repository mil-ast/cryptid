import 'dart:typed_data';

import 'package:cryptid/models/properties_model.dart';

abstract interface class IBackupService {
  Future<void> createBackup(Uint8List encryptedData, List<BackupValue> backup);
}
