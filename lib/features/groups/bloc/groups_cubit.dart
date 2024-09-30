import 'package:cryptid/models/file_data_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'groups_states.dart';

class GroupsCubit extends Cubit<GroupsStates> {
  int _selectedIndex = -1;

  int get selectedIndex => _selectedIndex;

  GroupsCubit() : super(const GroupEmptyState());

  void showCreateDialog() {
    emit(GroupShowCreateDialogState());
  }

  void showEditDialog(GroupModel group) {
    emit(GroupShowEditDialogState(group));
  }

  void showConfirmDeleteDialog(GroupModel group) {
    emit(GroupShowConfirmDeleteDialogState(group));
  }

  void refreshGroups({int? selectedIndex}) {
    if (selectedIndex != null && selectedIndex >= 0) {
      _selectedIndex = selectedIndex;
    }
    emit(GroupRefreshState(_selectedIndex));
  }
}
