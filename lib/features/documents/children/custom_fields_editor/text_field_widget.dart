import 'package:cryptid/features/documents/children/custom_fields_editor/children/change_field_type_dialog.dart';
import 'package:cryptid/features/documents/children/custom_fields_editor/password_generator_widget.dart';
import 'package:cryptid/models/document_edit_data.dart';
import 'package:cryptid/models/file_data_models.dart';
import 'package:flutter/material.dart';

class TextFieldWidget extends StatefulWidget {
  final EditableFieldData field;
  final void Function(EditableFieldData field) onRemove;
  const TextFieldWidget({
    required this.field,
    required this.onRemove,
    super.key,
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: TextFormField(
            controller: widget.field.controller,
            obscureText: false,
            maxLines: widget.field.fieldType == FieldType.text ? 6 : null,
            minLines: widget.field.fieldType == FieldType.text ? 2 : null,
            decoration: InputDecoration(
              labelText: widget.field.title,
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (widget.field.fieldType == FieldType.site && value != null && value.isNotEmpty) {
                final uri = Uri.tryParse(value);
                if (uri == null) {
                  return 'Некорректный адрес сайта';
                }
              }
              return null;
            },
          ),
        ),
        if (widget.field.fieldType == FieldType.password)
          IconButton(
            icon: const Icon(Icons.password),
            tooltip: 'Создать новый пароль',
            onPressed: () async {
              final password = await showDialog<String>(
                context: context,
                barrierColor: Colors.transparent,
                builder: (context) => const PasswordGeneratorWidget(),
              );
              if (password != null) {
                widget.field.controller.text = password;
              }
            },
          ),
        IconButton(
          icon: const Icon(Icons.delete_outline),
          tooltip: 'Удалить поле',
          onPressed: () {
            widget.onRemove(widget.field);
          },
        ),
        IconButton(
          icon: const Icon(Icons.edit_square),
          tooltip: 'Изменить тип поля',
          onPressed: () async {
            final newType = await showDialog<FieldType>(
              context: context,
              barrierColor: Colors.transparent,
              builder: (context) => ChangeFieldTypeDialog(widget.field.fieldType),
            );
            if (newType != null && newType != widget.field.fieldType) {
              setState(() {
                widget.field.fieldType = newType;
              });
            }
          },
        ),
      ],
    );
  }
}
