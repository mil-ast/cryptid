import 'package:cryptid/features/documents/children/custom_fields_editor/custom_field_editor_widget.dart';
import 'package:cryptid/models/document_edit_data.dart';
import 'package:flutter/material.dart';

class DialogDocumentEditWidget extends StatefulWidget {
  final EditableDocumentData documentData;

  const DialogDocumentEditWidget({
    required this.documentData,
    super.key,
  });

  @override
  State<DialogDocumentEditWidget> createState() => _DialogDocumentEditWidgetState();
}

class _DialogDocumentEditWidgetState extends State<DialogDocumentEditWidget> {
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    widget.documentData.titleController.dispose();
    for (int i = 0; i < widget.documentData.fields.length; i++) {
      widget.documentData.fields[i].controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Изменить секрет'),
      content: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: widget.documentData.titleController,
              decoration: const InputDecoration(
                labelText: 'Название',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Обязательно к заполнению';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            CustomFieldsEditorWidget(
              fields: widget.documentData.fields,
            ),
          ],
        ),
      ),
      actions: [
        TextButton.icon(
          onPressed: () {
            Navigator.pop(context);
          },
          label: const Text('Отмена'),
          icon: const Icon(Icons.cancel),
        ),
        FilledButton.icon(
          onPressed: () {
            if (!_formKey.currentState!.validate()) {
              return;
            }

            Navigator.pop(
              context,
              widget.documentData,
            );
          },
          label: const Text('Сохранить'),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
