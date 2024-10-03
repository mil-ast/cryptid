part of 'documents_bloc.dart';

sealed class DocumentsState {
  final bool isBuild;
  const DocumentsState(this.isBuild);
}

class DocumentsEmptyState extends DocumentsState {
  const DocumentsEmptyState() : super(true);
}

class DocumentsShowCreateDialogState extends DocumentsState {
  final CreateDocumentData documentData;
  const DocumentsShowCreateDialogState({
    required this.documentData,
  }) : super(false);
}

class DocumentsShowEditState extends DocumentsState {
  final EditableDocumentData documentData;
  const DocumentsShowEditState({
    required this.documentData,
  }) : super(false);
}

class DocumentsShowDetailsState extends DocumentsState {
  final DocumentModel document;
  const DocumentsShowDetailsState({
    required this.document,
  }) : super(true);
}

class DocumentsRefreshState extends DocumentsState {
  final List<DocumentModel> documents;
  const DocumentsRefreshState(this.documents) : super(true);
}

class DocumentsConfirmDeleteState extends DocumentsState {
  final DocumentModel document;
  final GroupModel selectedGroup;
  const DocumentsConfirmDeleteState({
    required this.document,
    required this.selectedGroup,
  }) : super(false);
}
