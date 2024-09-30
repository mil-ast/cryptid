import 'package:cryptid/models/file_data_models.dart';
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
    emit(DocumentsShowCreateDialogState(
      documentType: documentType,
      selectedroup: _selectedGroup!,
    ));
  }

  void showEditDialog(DocumentModel document) {
    emit(DocumentsShowEditState(
      document: document,
      selectedroup: _selectedGroup!,
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
