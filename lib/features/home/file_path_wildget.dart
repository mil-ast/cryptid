import 'dart:io';

import 'package:cryptid/features/home/bloc/storage_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilePathWidget extends StatelessWidget {
  final String? filePath;
  const FilePathWidget(this.filePath, {super.key});

  @override
  Widget build(BuildContext context) {
    if (filePath == null) {
      return const SizedBox.shrink();
    }

    final fileName = filePath!.split(Platform.pathSeparator).last;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            TextButton.icon(
              onPressed: context.read<StorageCubit>().changeFile,
              label: const Text('Открыть другой'),
              icon: const Icon(Icons.file_open_outlined),
            ),
            const SizedBox(width: 10),
            TextButton.icon(
              onPressed: context.read<StorageCubit>().showChangePasswordDialog,
              label: const Text('Изменить пароль'),
              icon: const Icon(Icons.password_outlined),
            ),
            const SizedBox(width: 10),
            Text(fileName),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
