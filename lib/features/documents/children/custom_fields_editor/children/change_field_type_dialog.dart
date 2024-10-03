import 'package:cryptid/core/app_theme.dart';
import 'package:cryptid/core/extensions/build_context_extension.dart';
import 'package:cryptid/models/file_data_models.dart';
import 'package:flutter/material.dart';

class ChangeFieldTypeDialog extends StatelessWidget {
  final FieldType currentType;
  const ChangeFieldTypeDialog(this.currentType, {super.key});

  @override
  Widget build(BuildContext context) {
    final dialogSize = context.getDialogSize(minWidth: 300, minHeight: 200, maxWidth: 340, maxHeight: 200);
    return AlertDialog(
      title: const Text('Выберите тип поля'),
      backgroundColor: AppColors.secondary,
      content: SingleChildScrollView(
        child: SizedBox(
          width: dialogSize.width,
          height: dialogSize.height,
          child: ListView.builder(
            itemCount: FieldType.values.length,
            itemBuilder: (context, i) => ListTile(
              title: Text(FieldType.values[i].label),
              leading: const Icon(
                Icons.circle,
                size: 12,
              ),
              onTap: () {
                Navigator.of(context).pop(FieldType.values[i]);
              },
            ),
          ),
        ),
      ),
      actions: [
        TextButton.icon(
          onPressed: Navigator.of(context).pop,
          label: const Text('Отмена'),
          icon: const Icon(Icons.cancel),
        ),
      ],
    );
  }
}
