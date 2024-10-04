import 'dart:io';
import 'package:flutter/material.dart';

class FilePathWidget extends StatelessWidget {
  final String? filePath;
  const FilePathWidget(this.filePath, {super.key});

  @override
  Widget build(BuildContext context) {
    if (filePath == null) {
      return const SizedBox.shrink();
    }

    final fileName = filePath!.split(Platform.pathSeparator).last;

    return Tooltip(
      waitDuration: const Duration(milliseconds: 500),
      message: filePath,
      child: Text(fileName),
    );
  }
}
