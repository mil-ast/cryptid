part of 'groups_cubit.dart';

sealed class GroupsStates {
  final bool isBuild;
  const GroupsStates(this.isBuild);
}

class GroupEmptyState extends GroupsStates {
  const GroupEmptyState() : super(true);
}

class GroupRefreshState extends GroupsStates {
  final int selectedIndex;
  GroupRefreshState(this.selectedIndex) : super(true);
}

class GroupShowCreateDialogState extends GroupsStates {
  GroupShowCreateDialogState() : super(false);
}

class GroupShowEditDialogState extends GroupsStates {
  final GroupModel group;
  GroupShowEditDialogState(this.group) : super(false);
}

class GroupShowConfirmDeleteDialogState extends GroupsStates {
  final GroupModel group;
  GroupShowConfirmDeleteDialogState(this.group) : super(false);
}
