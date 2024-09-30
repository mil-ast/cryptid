import 'package:cryptid/features/documents/children/custom_fields_editor/custom_field_editor_widget.dart';
import 'package:cryptid/models/data_changes_models.dart';
import 'package:cryptid/models/file_data_models.dart';
import 'package:flutter/material.dart';

class DialogDocumentEditWidget extends StatefulWidget {
  final GroupModel selectedroup;
  final DocumentModel document;

  const DialogDocumentEditWidget({
    required this.selectedroup,
    required this.document,
    super.key,
  });

  @override
  State<DialogDocumentEditWidget> createState() => _DialogDocumentEditWidgetState();
}

class _DialogDocumentEditWidgetState extends State<DialogDocumentEditWidget> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final List<TextEditingController> customFieldsControllers = [];

  @override
  void initState() {
    super.initState();
    titleController.text = widget.document.title;
    for (int i = 0; i < widget.document.customFields.length; i++) {
      customFieldsControllers.add(TextEditingController(text: widget.document.customFields[i].value));
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    for (int i = 0; i < customFieldsControllers.length; i++) {
      customFieldsControllers[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Добавить новый секрет'),
      content: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: titleController,
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
              customFields: widget.document.customFields,
              customFieldsControllers: customFieldsControllers,
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

            widget.document.title = titleController.text;
            for (int i = 0; i < widget.document.customFields.length; i++) {
              widget.document.customFields[i].value = customFieldsControllers[i].text;
            }
            Navigator.pop(
              context,
              DialogDocumentResult(
                documentModel: widget.document,
                selectedroup: widget.selectedroup,
              ),
            );
          },
          label: const Text('Сохранить'),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
