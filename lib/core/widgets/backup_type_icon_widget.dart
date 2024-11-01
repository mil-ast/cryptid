import 'package:cryptid/models/properties_model.dart';
import 'package:flutter/material.dart';

class BackupIconWidget extends StatelessWidget {
  final BackupType type;
  const BackupIconWidget(this.type, {super.key});

  @override
  Widget build(BuildContext context) => switch (type) {
        BackupType.webdav => const Icon(Icons.language_outlined),
        BackupType.file => const Icon(Icons.file_copy_outlined),
        BackupType.disabled => const Icon(Icons.cloud_off_outlined),
      };
}
