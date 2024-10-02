import 'package:cryptid/models/document_edit_data.dart';
import 'package:cryptid/models/file_data_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'documents_states.dart';

class DocumentsCubit extends Cubit<DocumentsState> {
  GroupModel? _selectedGroup;

  DocumentsCubit() : super(const DocumentsEmptyState());

  void onSelectGroup(GroupModel? group) {
    _selectedGroup = group;
    if (group == null) {
      emit(const DocumentsEmptyState());
      return;
    }
    emit(DocumentsRefreshState(group.documents));
  }

  void showCreateDialog(DocumentType documentType) {
    final List<EditableFieldData> customFields = [];
    switch (documentType) {
      case DocumentType.note:
        customFields.add(
          EditableFieldData(title: 'Заметка', controller: TextEditingController(), fieldType: FieldType.string),
        );
      case DocumentType.document:
        customFields.addAll([
          EditableFieldData(title: 'Логин', controller: TextEditingController(), fieldType: FieldType.string),
          EditableFieldData(title: 'Пароль', controller: TextEditingController(), fieldType: FieldType.password),
        ]);
      case DocumentType.site:
        customFields.addAll([
          EditableFieldData(title: 'Сайт', controller: TextEditingController(), fieldType: FieldType.site),
          EditableFieldData(title: 'Логин', controller: TextEditingController(), fieldType: FieldType.string),
          EditableFieldData(title: 'Пароль', controller: TextEditingController(), fieldType: FieldType.password),
        ]);
    }

    emit(DocumentsShowCreateDialogState(
      documentData: CreateDocumentData(
        selectedroup: _selectedGroup!,
        documentType: documentType,
        titleController: TextEditingController(),
        fields: customFields,
      ),
    ));
  }

  void showEditDialog(DocumentModel document) {
    EditableDocumentData documentData = EditableDocumentData(
      selectedroup: _selectedGroup!,
      document: document,
      titleController: TextEditingController(text: document.title),
      fields: document.customFields
          .map((f) => EditableFieldData(
                title: f.title,
                controller: TextEditingController(text: f.value),
                fieldType: f.fieldType,
              ))
          .toList(),
    );
    emit(DocumentsShowEditState(
      documentData: documentData,
    ));
  }

  void showConfirmDeleteDocumentWidget(DocumentModel document) {
    emit(DocumentsConfirmDeleteState(document: document, selectedGroup: _selectedGroup!));
  }

  void showDetailsWidget(DocumentModel document) {
    emit(DocumentsShowDetailsState(document: document));
  }

  void refreshDocuments() {
    emit(DocumentsRefreshState(_selectedGroup?.documents ?? []));
  }
}
