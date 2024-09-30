import 'package:flutter/material.dart';

class DialogGroupCreateWidget extends StatefulWidget {
  const DialogGroupCreateWidget({super.key});

  @override
  State<DialogGroupCreateWidget> createState() => _DialogGroupCreateWidgetState();
}

class _DialogGroupCreateWidgetState extends State<DialogGroupCreateWidget> {
  final _formKey = GlobalKey<FormState>();
  final groupNameController = TextEditingController();

  @override
  void dispose() {
    groupNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Добавить новую группу'),
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
            Navigator.pop(context, groupNameController.text);
          },
          label: const Text('Добавить'),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
