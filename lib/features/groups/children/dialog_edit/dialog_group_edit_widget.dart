import 'package:cryptid/models/data_changes_models.dart';
import 'package:cryptid/models/file_data_models.dart';
import 'package:flutter/material.dart';

class DialogGroupEditWidget extends StatefulWidget {
  final GroupModel group;
  const DialogGroupEditWidget({required this.group, super.key});

  @override
  State<DialogGroupEditWidget> createState() => _DialogGroupEditWidgetState();
}

class _DialogGroupEditWidgetState extends State<DialogGroupEditWidget> {
  final _formKey = GlobalKey<FormState>();
  final groupNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    groupNameController.text = widget.group.name;
  }

  @override
  void dispose() {
    groupNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Изменить группу'),
      content: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: TextFormField(
          autofocus: false,
          controller: groupNameController,
          decoration: const InputDecoration(
            labelText: 'Название группы',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Обязательно к заполнению';
            }
            return null;
          },
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
            final newModel = GroupChangesModel(
              name: groupNameController.text,
            );
            Navigator.pop(context, newModel);
          },
          label: const Text('Сохранить'),
          icon: const Icon(Icons.done),
        ),
      ],
    );
  }
}
