import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? confirmButtonText;
  final String? cancelButtonText;
  final TextStyle? confirmButtonStyle;
  final TextStyle? cancelButtonStyle;
  final void Function()? onConfirm;

  const ConfirmationDialog({
    required this.title,
    required this.message,
    this.onConfirm,
    this.confirmButtonText,
    this.cancelButtonText,
    this.confirmButtonStyle,
    this.cancelButtonStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      scrollable: true,
      insetPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 26, vertical: 10),
      actionsPadding: const EdgeInsets.all(8),
      actionsAlignment: MainAxisAlignment.end,
      actions: <Widget>[
        TextButton(
          child: Text(
            cancelButtonText ?? 'Нет',
            style: cancelButtonStyle,
          ),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(context, true);
            if (onConfirm != null) {
              onConfirm!();
            }
          },
          child: Text(
            confirmButtonText ?? 'Да',
            style: confirmButtonStyle,
          ),
        ),
      ],
    );
  }
}
