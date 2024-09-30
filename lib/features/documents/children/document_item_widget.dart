import 'package:cryptid/features/documents/bloc/documents_bloc.dart';
import 'package:cryptid/models/file_data_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DocumentItemWidget extends StatelessWidget {
  final DocumentModel document;
  const DocumentItemWidget({
    required this.document,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget title;
    Widget icon;
    switch (document.type) {
      case DocumentType.note:
        title = const Text('Заметка');
        icon = const Icon(Icons.note_outlined);
      case DocumentType.document:
        title = const Text('Документ');
        icon = const Icon(Icons.file_present_outlined);
      case DocumentType.site:
        title = const Text('Сайт');
        icon = const Icon(Icons.web);
    }

    return ListTile(
      title: Text(document.title),
      subtitle: title,
      leading: icon,
      onTap: () {
        context.read<DocumentsCubit>().showDetailsWidget(document);
      },
    );
  }
}
