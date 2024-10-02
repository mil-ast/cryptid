import 'package:cryptid/core/widgets/dialogs/cinfirmation_dialog.dart';
import 'package:cryptid/core/widgets/document_type_icon_widget.dart';
import 'package:cryptid/features/documents/bloc/documents_bloc.dart';
import 'package:cryptid/features/documents/children/dialog_create/dialog_document_create_widget.dart';
import 'package:cryptid/features/documents/children/dialog_edit/dialog_document_edit_widget.dart';
import 'package:cryptid/features/documents/children/document_item_widget.dart';
import 'package:cryptid/features/documents/children/view_widget/document_card_widget.dart';
import 'package:cryptid/features/home/bloc/storage_cubit.dart';
import 'package:cryptid/features/home/column_header_widget.dart';
import 'package:cryptid/models/document_edit_data.dart';
import 'package:cryptid/models/file_data_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DocumentsWidget extends StatelessWidget {
  const DocumentsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DocumentsCubit, DocumentsState>(
      listenWhen: (previous, current) => !current.isBuild,
      listener: (context, state) async {
        if (state is DocumentsShowCreateDialogState) {
          final result = await showDialog<CreateDocumentData>(
            context: context,
            builder: (context) => DialogDocumentCreateWidget(
              documentData: state.documentData,
            ),
          );
          if (result != null && context.mounted) {
            context.read<StorageCubit>().createDocument(result);
          }
        } else if (state is DocumentsShowEditState) {
          final result = await showDialog<EditableDocumentData>(
            context: context,
            builder: (context) => DialogDocumentEditWidget(
              documentData: state.documentData,
            ),
          );
          if (result != null && context.mounted) {
            context.read<StorageCubit>().updateDocument(result);
          }
        } else if (state is DocumentsConfirmDeleteState) {
          final isOk = await showDialog<bool>(
            context: context,
            builder: (context) => ConfirmationDialog(
              message: '${state.document.title}\r\nВы действительно хотите удалить документ?',
              title: 'Удаление группы',
            ),
          );
          if (isOk == true && context.mounted) {
            context.read<StorageCubit>().deleteDocument(selectedroup: state.selectedGroup, document: state.document);
            context.read<DocumentsCubit>().refreshDocuments();
          }
        }
      },
      buildWhen: (previous, current) => current is DocumentsRefreshState || current is DocumentsEmptyState,
      builder: (context, state) {
        if (state is DocumentsRefreshState) {
          return SelectedGroupWidget(state.documents);
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class SelectedGroupWidget extends StatelessWidget {
  final List<DocumentModel> documents;
  const SelectedGroupWidget(this.documents, {super.key});

  @override
  Widget build(BuildContext context) {
    return ColumnWidget(
      header: Row(
        children: [
          BlocBuilder<DocumentsCubit, DocumentsState>(
            buildWhen: (previous, current) => current.isBuild,
            builder: (context, state) {
              if (state is DocumentsShowDetailsState) {
                return Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.start,
                  spacing: 20,
                  children: [
                    TextButton.icon(
                      onPressed: context.read<DocumentsCubit>().refreshDocuments,
                      label: const Text('Назад'),
                      icon: const Icon(Icons.keyboard_arrow_left_sharp),
                    ),
                    FilledButton.icon(
                      onPressed: () {
                        context.read<DocumentsCubit>().showEditDialog(state.document);
                      },
                      label: const Text('Изменить'),
                      icon: const Icon(Icons.edit_note),
                    ),
                    TextButton.icon(
                      label: const Text('Удалить'),
                      icon: const Icon(Icons.delete_outlined),
                      onPressed: () {
                        context.read<DocumentsCubit>().showConfirmDeleteDocumentWidget(state.document);
                      },
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const Spacer(),
          TextButton.icon(
            icon: const Icon(Icons.new_label_outlined),
            label: const Row(
              children: [
                Text('Добавить'),
                Icon(Icons.more_horiz_outlined),
              ],
            ),
            onPressed: () {
              final box = context.findRenderObject() as RenderBox;
              final offset = box.localToGlobal(Offset.zero);
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(offset.dx, 60, 0, 0),
                items: [
                  PopupMenuItem(
                    child: const ListTile(
                      leading: DocumentIconWidget(DocumentType.note),
                      title: Text('Заметка'),
                      mouseCursor: MouseCursor.defer,
                    ),
                    onTap: () {
                      context.read<DocumentsCubit>().showCreateDialog(DocumentType.note);
                    },
                  ),
                  PopupMenuItem(
                    child: const ListTile(
                      leading: DocumentIconWidget(DocumentType.document),
                      title: Text('Документ'),
                      mouseCursor: MouseCursor.defer,
                    ),
                    onTap: () {
                      context.read<DocumentsCubit>().showCreateDialog(DocumentType.document);
                    },
                  ),
                  PopupMenuItem(
                    child: const ListTile(
                      leading: DocumentIconWidget(DocumentType.site),
                      title: Text('Сайт'),
                      mouseCursor: MouseCursor.defer,
                    ),
                    onTap: () {
                      context.read<DocumentsCubit>().showCreateDialog(DocumentType.site);
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
      child: BlocBuilder<DocumentsCubit, DocumentsState>(
        buildWhen: (previous, current) => current is DocumentsRefreshState || current is DocumentsShowDetailsState,
        builder: (context, state) {
          if (state is DocumentsRefreshState) {
            if (documents.isEmpty) {
              return const Center(
                child: Text('Здесь ещё ничего нет'),
              );
            }

            return ListView.builder(
              itemBuilder: (context, i) => DocumentItemWidget(
                document: documents[i],
              ),
              itemCount: documents.length,
            );
          } else if (state is DocumentsShowDetailsState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: DocumentCardWidget(document: state.document),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
