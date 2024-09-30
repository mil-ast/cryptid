import 'package:cryptid/core/app_theme.dart';
import 'package:cryptid/features/documents/children/custom_fields_editor/text_field_widget.dart';
import 'package:cryptid/models/file_data_models.dart';
import 'package:flutter/material.dart';

class CustomFieldsEditorWidget extends StatefulWidget {
  final List<CustomField> customFields;
  final List<TextEditingController> customFieldsControllers;
  const CustomFieldsEditorWidget({
    required this.customFields,
    required this.customFieldsControllers,
    super.key,
  });

  @override
  State<CustomFieldsEditorWidget> createState() => _CustomFieldsEditorWidgetState();
}

class _CustomFieldsEditorWidgetState extends State<CustomFieldsEditorWidget> {
  final TextEditingController newFieldTitleController = TextEditingController();
  bool visibleFormNewField = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < widget.customFields.length; i++) ...[
          TextFieldWidget(
            controller: widget.customFieldsControllers[i],
            field: widget.customFields[i],
            onRemove: widget.customFields.isNotEmpty ? _deleteField : null,
          ),
          const SizedBox(height: 20),
        ],
        if (visibleFormNewField)
          Container(
            color: AppColors.secondary,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Новое поле: '),
                      IconButton(
                        icon: const Icon(Icons.cancel),
                        onPressed: () {
                          setState(() {
                            visibleFormNewField = false;
                          });
                        },
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: newFieldTitleController,
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
                  const SizedBox(height: 10),
                  const Text('Тип поля:'),
                  const SizedBox(height: 10),
                  Wrap(
                    children: FieldType.values
                        .map(
                          (e) => TextButton(
                            child: Text(e.label),
                            onPressed: () {
                              if (newFieldTitleController.text.isNotEmpty) {
                                _addNewField(newFieldTitleController.text, e);
                              }
                            },
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          )
        else
          TextButton.icon(
            onPressed: () {
              setState(() {
                visibleFormNewField = true;
              });
            },
            label: const Text('Добавить новое поле'),
            icon: const Icon(Icons.add),
          ),
        const SizedBox(height: 20),
      ],
    );
  }

  void _deleteField(CustomField field) {
    setState(() {
      final index = widget.customFields.indexOf(field);
      widget.customFields.removeAt(index);
      widget.customFieldsControllers[index].dispose();
      widget.customFieldsControllers.removeAt(index);
    });
  }

  void _addNewField(String title, FieldType fieldType) {
    setState(() {
      newFieldTitleController.text = '';
      visibleFormNewField = false;
      widget.customFieldsControllers.add(TextEditingController());
      widget.customFields.add(CustomField(title: title, value: '', fieldType: fieldType));
    });
  }
}
