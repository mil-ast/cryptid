import 'package:cryptid/core/app_theme.dart';
import 'package:cryptid/features/documents/children/custom_fields_editor/children/create_field_dialog.dart';
import 'package:cryptid/features/documents/children/custom_fields_editor/text_field_widget.dart';
import 'package:cryptid/models/document_edit_data.dart';
import 'package:cryptid/models/file_data_models.dart';
import 'package:flutter/material.dart';

class CustomFieldsEditorWidget extends StatefulWidget {
  final List<EditableFieldData> fields;
  const CustomFieldsEditorWidget({
    required this.fields,
    super.key,
  });

  @override
  State<CustomFieldsEditorWidget> createState() => _CustomFieldsEditorWidgetState();
}

class _CustomFieldsEditorWidgetState extends State<CustomFieldsEditorWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < widget.fields.length; i++) ...[
          TextFieldWidget(
            field: widget.fields[i],
            onRemove: _deleteField,
          ),
          const SizedBox(height: 20),
        ],
        TextButton.icon(
          onPressed: _openDialogCreateField,
          label: const Text('Добавить новое поле'),
          icon: const Icon(Icons.add),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  void _openDialogCreateField() async {
    final result = await showDialog<EditableFieldData>(
      context: context,
      builder: (context) => const CreateFieldDialog(),
    );
    if (result != null) {
      setState(() {
        widget.fields.add(result);
      });
    }
  }

  void _deleteField(EditableFieldData field) {
    setState(() {
      field.controller.dispose();
      final index = widget.fields.indexOf(field);
      widget.fields.removeAt(index);
    });
  }
}
