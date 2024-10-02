import 'package:cryptid/core/app_theme.dart';
import 'package:cryptid/models/file_data_models.dart';
import 'package:flutter/material.dart';

class ChangeFieldTypeDialog extends StatelessWidget {
  final FieldType currentType;
  const ChangeFieldTypeDialog(this.currentType, {super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    if (width > 400) {
      width = 400;
    }
    if (height > 300) {
      height = 300;
    }
    return AlertDialog(
      title: const Text('Выберите тип поля'),
      backgroundColor: AppColors.secondary,
      content: SingleChildScrollView(
        child: SizedBox(
          width: width - 100,
          height: height - 100,
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
    );
  }
}
