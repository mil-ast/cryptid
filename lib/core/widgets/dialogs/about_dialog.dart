import 'package:flutter/material.dart';

class AboutDialogState extends StatelessWidget {
  const AboutDialogState({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cryptid'),
      content: const Text('About'),
      scrollable: true,
      insetPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 26, vertical: 10),
      actionsPadding: const EdgeInsets.all(8),
      actionsAlignment: MainAxisAlignment.end,
      actions: <Widget>[
        TextButton(
          child: const Text(
            'Отмена',
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
