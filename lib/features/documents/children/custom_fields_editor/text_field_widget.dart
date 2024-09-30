import 'package:cryptid/features/documents/children/custom_fields_editor/password_generator_widget.dart';
import 'package:cryptid/models/file_data_models.dart';
import 'package:flutter/material.dart';

class TextFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final CustomField field;
  final void Function(CustomField field)? onRemove;
  const TextFieldWidget({required this.controller, required this.field, this.onRemove, super.key});

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
            controller: widget.controller,
            obscureText: false,
            maxLines: widget.field.fieldType == FieldType.text ? 6 : null,
            minLines: widget.field.fieldType == FieldType.text ? 2 : null,
            decoration: InputDecoration(
              labelText: widget.field.title,
            ),
          ),
        ),
        if (widget.field.fieldType == FieldType.password)
          IconButton(
            icon: const Icon(Icons.password),
            onPressed: () async {
              final password = await showDialog<String>(
                context: context,
                barrierColor: Colors.transparent,
                builder: (context) => const PasswordGeneratorWidget(),
              );
              if (password != null) {
                widget.controller.text = password;
              }
            },
          ),
        if (widget.onRemove != null)
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              widget.onRemove!(widget.field);
            },
          ),
      ],
    );
  }
}
