import 'package:cryptid/core/extensions/build_context_extension.dart';
import 'package:cryptid/features/documents/children/custom_fields_editor/custom_field_editor_widget.dart';
import 'package:cryptid/models/document_edit_data.dart';
import 'package:flutter/material.dart';

class DialogDocumentCreateWidget extends StatefulWidget {
  final CreateDocumentData documentData;

  const DialogDocumentCreateWidget({
    required this.documentData,
    super.key,
  });

  @override
  State<DialogDocumentCreateWidget> createState() => _DialogDocumentCreateWidgetState();
}

class _DialogDocumentCreateWidgetState extends State<DialogDocumentCreateWidget> {
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
    final dialogSize = context.getDialogSize(minWidth: 300, minHeight: 300);

    return AlertDialog(
      title: const Text('Добавить новый секрет'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: dialogSize.width,
          height: dialogSize.height,
          child: SingleChildScrollView(
            child: Form(
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
          ),
        ),
      ),
      actions: [
        TextButton.icon(
          onPressed: Navigator.of(context).pop,
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
          label: const Text('Добавить'),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
