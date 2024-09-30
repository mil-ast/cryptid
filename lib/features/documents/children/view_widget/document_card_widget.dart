import 'package:cryptid/core/app_theme.dart';
import 'package:cryptid/core/widgets/document_type_icon_widget.dart';
import 'package:cryptid/models/file_data_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DocumentCardWidget extends StatefulWidget {
  final DocumentModel document;
  const DocumentCardWidget({required this.document, super.key});

  @override
  State<DocumentCardWidget> createState() => _DocumentCardWidgetState();
}

class _DocumentCardWidgetState extends State<DocumentCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            DocumentIconWidget(widget.document.type),
            const SizedBox(width: 10),
            Expanded(
              child: Text(widget.document.title, style: Theme.of(context).textTheme.titleLarge),
            ),
          ],
        ),
        const SizedBox(height: 20),
        for (int i = 0; i < widget.document.customFields.length; i++)
          FieldItemWidget(
            field: widget.document.customFields[i],
          ),
      ],
    );
  }
}

class FieldItemWidget extends StatefulWidget {
  final CustomField field;
  const FieldItemWidget({required this.field, super.key});

  @override
  State<FieldItemWidget> createState() => _FieldItemPasswordState();
}

class _FieldItemPasswordState extends State<FieldItemWidget> {
  ValueNotifier? _showPassword;

  @override
  void initState() {
    super.initState();
    if (widget.field.fieldType == FieldType.password) {
      _showPassword = ValueNotifier(false);
    }
  }

  @override
  void dispose() {
    _showPassword?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPassword = widget.field.fieldType == FieldType.password;
    return Card(
      color: AppColors.secondary,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.field.title,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.textGrey),
                  ),
                  if (isPassword)
                    ValueListenableBuilder(
                      valueListenable: _showPassword!,
                      builder: (context, isShow, _) {
                        return isShow ? SelectableText(widget.field.value) : const Text('*****');
                      },
                    )
                  else
                    SelectableText(widget.field.value),
                ],
              ),
            ),
            Row(
              children: [
                Row(
                  children: [
                    if (isPassword)
                      IconButton(
                        icon: ValueListenableBuilder(
                          valueListenable: _showPassword!,
                          builder: (context, isShow, _) =>
                              Icon(isShow ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                        ),
                        onPressed: () {
                          _showPassword!.value = !_showPassword!.value;
                        },
                      ),
                    IconButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: widget.field.value));
                      },
                      icon: const Icon(Icons.copy_outlined),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
