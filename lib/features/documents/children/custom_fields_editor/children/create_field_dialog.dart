import 'package:cryptid/core/app_theme.dart';
import 'package:cryptid/core/extensions/build_context_extension.dart';
import 'package:cryptid/models/document_edit_data.dart';
import 'package:cryptid/models/file_data_models.dart';
import 'package:flutter/material.dart';

class CreateFieldDialog extends StatefulWidget {
  const CreateFieldDialog({super.key});

  @override
  State<StatefulWidget> createState() => _CreateFieldState();
}

class _CreateFieldState extends State<CreateFieldDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _newFieldTitleController = TextEditingController();
  FieldType _fieldType = FieldType.string;

  @override
  void dispose() {
    _newFieldTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dialogSize = context.getDialogSize(minWidth: 300, maxWidth: 340);
    return AlertDialog(
      title: const Text('Добавить новое поле'),
      backgroundColor: AppColors.secondary,
      content: SizedBox(
        width: dialogSize.width,
        height: 140,
        child: SizedBox(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _newFieldTitleController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      labelText: 'Название',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Поле обязательное';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<FieldType>(
                          icon: const Icon(Icons.text_fields_outlined),
                          onChanged: (type) {
                            _fieldType = type!;
                          },
                          value: _fieldType,
                          items: FieldType.values
                              .map(
                                (v) => DropdownMenuItem(
                                  value: v,
                                  child: Text(v.label),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
        FilledButton(
          child: const Text('Добавить'),
          onPressed: () {
            if (!_formKey.currentState!.validate()) {
              return;
            }
            final field = EditableFieldData(
              controller: TextEditingController(),
              fieldType: _fieldType,
              title: _newFieldTitleController.text,
            );
            Navigator.of(context).pop(field);
          },
        ),
      ],
    );
  }
}
