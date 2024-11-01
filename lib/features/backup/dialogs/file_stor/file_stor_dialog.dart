import 'package:cryptid/core/extensions/build_context_extension.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class FileStorDialog extends StatefulWidget {
  final String currentFilePath;
  final List<String> backupFiles;
  const FileStorDialog({required this.backupFiles, required this.currentFilePath, super.key});

  @override
  State<FileStorDialog> createState() => _FileStorDialogState();
}

class _FileStorDialogState extends State<FileStorDialog> {
  String? backupFilePath;

  @override
  Widget build(BuildContext context) {
    final dialogSize = context.getDialogSize(minWidth: 260, maxWidth: 440, minHeight: 100, maxHeight: 180);

    return AlertDialog(
      title: const Text('Файловая копия'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: dialogSize.width,
          height: dialogSize.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Текущий файл: ${widget.currentFilePath}'),
              if (backupFilePath != null) ...[const SizedBox(height: 20), Text('Резервный путь: $backupFilePath')],
              const SizedBox(height: 40),
              Center(
                child: TextButton(
                  onPressed: () async {
                    final dirName = dirname(widget.currentFilePath);
                    final result = await FilePicker.platform.getDirectoryPath(
                      initialDirectory: dirName,
                      lockParentWindow: false,
                    );
                    if (result != null) {
                      final fileName = basenameWithoutExtension(widget.currentFilePath);
                      final file = '$result/${fileName}_backup.cryptid';
                      if (widget.backupFiles.contains(file)) {
                        return;
                      }
                      setState(() {
                        final fileName = basenameWithoutExtension(widget.currentFilePath);
                        backupFilePath = '$result/${fileName}_backup.cryptid';
                      });
                    }
                  },
                  child: const Text('Выбрать путь'),
                ),
              )
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('Отмена'),
        ),
        FilledButton(
          onPressed: backupFilePath != null
              ? () {
                  Navigator.of(context).pop(backupFilePath);
                }
              : null,
          child: const Text('Применить'),
        ),
      ],
    );
  }
}
