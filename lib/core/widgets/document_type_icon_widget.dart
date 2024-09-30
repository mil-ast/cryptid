import 'package:cryptid/models/file_data_models.dart';
import 'package:flutter/material.dart';

class DocumentIconWidget extends StatelessWidget {
  final DocumentType type;
  const DocumentIconWidget(this.type, {super.key});

  @override
  Widget build(BuildContext context) => switch (type) {
        DocumentType.note => const Icon(Icons.note_outlined),
        DocumentType.document => const Icon(Icons.file_present_outlined),
        DocumentType.site => const Icon(Icons.web_outlined),
      };
}
