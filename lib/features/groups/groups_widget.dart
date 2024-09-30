import 'package:cryptid/core/widgets/dialogs/cinfirmation_dialog.dart';
import 'package:cryptid/features/groups/bloc/groups_cubit.dart';
import 'package:cryptid/features/groups/children/dialog_create/dialog_group_create_widget.dart';
import 'package:cryptid/features/documents/bloc/documents_bloc.dart';
import 'package:cryptid/features/groups/children/dialog_edit/dialog_group_edit_widget.dart';
import 'package:cryptid/features/home/bloc/storage_cubit.dart';
import 'package:cryptid/features/home/column_header_widget.dart';
import 'package:cryptid/models/data_changes_models.dart';
import 'package:cryptid/models/file_data_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupsWidget extends StatelessWidget {
  final List<GroupModel> groups;
  const GroupsWidget({
    required this.groups,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupsCubit, GroupsStates>(
      listenWhen: (previous, current) => !current.isBuild,
      listener: (context, state) async {
        if (state is GroupShowCreateDialogState) {
          final groupName = await showDialog(
            context: context,
            builder: (context) => const DialogGroupCreateWidget(),
          );
          if (groupName != null && context.mounted) {
            final group = GroupModel(name: groupName, documents: []);
            await context.read<StorageCubit>().saveNewGroup(group);
          }
        } else if (state is GroupShowEditDialogState) {
          final model = await showDialog<GroupChangesModel>(
            context: context,
            builder: (context) => DialogGroupEditWidget(group: state.group),
          );
          if (model != null && context.mounted) {
            await context.read<StorageCubit>().updateGroup(state.group, model);
          }
        } else if (state is GroupShowConfirmDeleteDialogState) {
          final isOk = await showDialog(
            context: context,
            builder: (context) => const ConfirmationDialog(
              message: 'Вы действительно хотите удалить группу и всё её содержимое?',
              title: 'Удаление группы',
            ),
          );

          if (isOk) {
            if (context.mounted) {
              await context.read<StorageCubit>().deleteGroup(state.group);
            }
          }
        }
      },
      buildWhen: (previous, current) => current.isBuild,
      builder: (context, state) {
        return ColumnWidget(
          header: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Группы',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: context.read<GroupsCubit>().showCreateDialog,
                label: const Text('Добавить'),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          child: BlocBuilder<GroupsCubit, GroupsStates>(
            buildWhen: (previous, current) => current is GroupRefreshState,
            builder: (context, state) {
              int selectedIndex = -1;
              if (state is GroupRefreshState) {
                selectedIndex = state.selectedIndex;
              }
              return ListView.builder(
                itemCount: groups.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    selected: index == selectedIndex,
                    title: Text(groups[index].name),
                    leading: const Icon(Icons.folder_outlined),
                    onTap: () {
                      context.read<GroupsCubit>().refreshGroups(selectedIndex: index);
                      context.read<DocumentsCubit>().onSelectGroup(groups[index]);
                    },
                    trailing: index == selectedIndex
                        ? PopupMenuButton(
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: const ListTile(
                                  leading: Icon(Icons.edit),
                                  title: Text('Изменить'),
                                  mouseCursor: MouseCursor.defer,
                                ),
                                onTap: () {
                                  context.read<GroupsCubit>().showEditDialog(groups[index]);
                                },
                              ),
                              PopupMenuItem(
                                child: const ListTile(
                                  leading: Icon(Icons.delete_outline),
                                  title: Text('Удалить'),
                                  mouseCursor: MouseCursor.defer,
                                ),
                                onTap: () {
                                  context.read<GroupsCubit>().showConfirmDeleteDialog(groups[index]);
                                },
                              ),
                            ],
                            child: const Icon(Icons.more_vert_outlined),
                          )
                        : const Icon(Icons.chevron_right),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
