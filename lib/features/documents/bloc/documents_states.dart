part of 'documents_bloc.dart';

sealed class DocumentsState {
  final bool isBuild;
  const DocumentsState(this.isBuild);
}

class DocumentsEmptyState extends DocumentsState {
  const DocumentsEmptyState() : super(true);
}

class DocumentsShowCreateDialogState extends DocumentsState {
  final DocumentType documentType;
  final GroupModel selectedroup;
  const DocumentsShowCreateDialogState({
    required this.documentType,
    required this.selectedroup,
  }) : super(false);
}

class DocumentsShowEditState extends DocumentsState {
  final DocumentModel document;
  final GroupModel selectedroup;
  const DocumentsShowEditState({
    required this.document,
    required this.selectedroup,
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
