import 'package:cryptid/features/documents/children/custom_fields_editor/custom_field_editor_widget.dart';
import 'package:cryptid/models/data_changes_models.dart';
import 'package:cryptid/models/file_data_models.dart';
import 'package:flutter/material.dart';

class DialogDocumentCreateWidget extends StatefulWidget {
  final GroupModel selectedroup;
  final List<CustomField> customFields;
  final DocumentType documentType;

  const DialogDocumentCreateWidget({
    required this.selectedroup,
    required this.customFields,
    required this.documentType,
    super.key,
  });

  @override
  State<DialogDocumentCreateWidget> createState() => _DialogDocumentCreateWidgetState();
}

class _DialogDocumentCreateWidgetState extends State<DialogDocumentCreateWidget> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final List<TextEditingController> customFieldsControllers = [];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < widget.customFields.length; i++) {
      customFieldsControllers.add(TextEditingController(text: widget.customFields[i].value));
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
              customFields: widget.customFields,
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

            for (int i = 0; i < widget.customFields.length; i++) {
              widget.customFields[i].value = customFieldsControllers[i].text;
            }
            final model = DocumentModel(
              titleController.text,
              type: widget.documentType,
              customFields: widget.customFields,
            );
            Navigator.pop(
              context,
              DialogDocumentResult(
                documentModel: model,
                selectedroup: widget.selectedroup,
              ),
            );
          },
          label: const Text('Добавить'),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
