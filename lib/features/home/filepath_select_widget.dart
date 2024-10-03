import 'package:cryptid/features/home/bloc/storage_cubit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilepathSelectWidget extends StatelessWidget {
  const FilepathSelectWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Spacer(),
            const Text('Для начала работы необходимо указать файл, в котором будут ханиться зашифрованные данные'),
            const SizedBox(height: 20),
            Wrap(
              spacing: 20,
              children: [
                TextButton.icon(
                  onPressed: context.read<StorageCubit>().createInDocumentPath,
                  label: const Text('Создать'),
                  icon: const Icon(Icons.file_present_outlined),
                ),
                FilledButton.icon(
                  label: const Text('Выбрать'),
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles(
                      allowMultiple: false,
                      withData: true,
                      type: FileType.custom,
                      allowedExtensions: ['cryptid'],
                    );
                    if (result != null && result.count > 0) {
                      final file = result.files.first;
                      if (context.mounted) {
                        context.read<StorageCubit>().onSelectFile(file.path!);
                      }
                    }
                  },
                  icon: const Icon(Icons.file_open_outlined),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
