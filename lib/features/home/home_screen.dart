import 'package:cryptid/core/widgets/dialogs/change_password_dialog.dart';
import 'package:cryptid/domain/crypt_service.dart';
import 'package:cryptid/features/documents/bloc/documents_bloc.dart';
import 'package:cryptid/features/documents/documents_widget.dart';
import 'package:cryptid/features/groups/bloc/groups_cubit.dart';
import 'package:cryptid/features/groups/groups_widget.dart';
import 'package:cryptid/features/home/bloc/storage_cubit.dart';
import 'package:cryptid/features/home/file_path_wildget.dart';
import 'package:cryptid/features/home/filepath_select_widget.dart';
import 'package:cryptid/features/home/password_input_widget.dart';
import 'package:cryptid/scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) {
              final sp = DependenciesScope.of(context).sharedPreferences;
              final encrypter = EncrypterService();
              return StorageCubit(sp: sp, encrypter: encrypter);
            },
          ),
          BlocProvider(
            create: (context) => GroupsCubit(),
          ),
          BlocProvider(
            create: (context) => DocumentsCubit(),
          ),
        ],
        child: BlocConsumer<StorageCubit, StorageState>(
          listenWhen: (previous, current) =>
              current is StorageFailureState || current is StorageUpdateState || current is StorageActionsState,
          listener: (context, state) {
            if (state is StorageFailureState) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red,
                content: Text(state.message),
              ));
            } else if (state is StorageUpdateState) {
              switch (state.action) {
                case StorageUpdateAction.addGroup:
                  context.read<GroupsCubit>().refreshGroups(selectedIndex: state.fileContent.groups.length - 1);
                  context.read<DocumentsCubit>().onSelectGroup(state.model);
                case StorageUpdateAction.editGroup:
                  context.read<GroupsCubit>().refreshGroups();
                case StorageUpdateAction.deleteGroup:
                  context.read<GroupsCubit>().refreshGroups(selectedIndex: -1);
                  context.read<DocumentsCubit>().onSelectGroup(null);
                case StorageUpdateAction.addDocument:
                  context.read<DocumentsCubit>().refreshDocuments();
                case StorageUpdateAction.editDocument:
                  context.read<DocumentsCubit>().refreshDocuments();
              }
            } else if (state is StorageShowChangePasswordDialogState) {
              showDialog(
                context: context,
                builder: (_) => BlocProvider.value(
                  value: context.read<StorageCubit>(),
                  child: const ChangePasswordDialog(),
                ),
              );
            }
          },
          buildWhen: (previous, current) => current is StorageParamsState,
          builder: (context, state) {
            state as StorageParamsState;
            return Column(
              children: [
                Expanded(
                  child: switch (state) {
                    StorageAskFilePathState() => const FilepathSelectWidget(),
                    StorageAskPasswordState() => PasswordInputWidget(
                        isNewPassword: state.isNewFile,
                        filePath: state.filePath!,
                      ),
                    StorageSuccessState() => Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 320,
                            child: GroupsWidget(
                              groups: state.fileContent.groups,
                            ),
                          ),
                          const VerticalDivider(),
                          const Expanded(
                            child: DocumentsWidget(),
                          ),
                        ],
                      ),
                    _ => const Center(
                        child: CircularProgressIndicator(),
                      ),
                  },
                ),
                const Divider(),
                FilePathWidget(state.filePath),
              ],
            );
          },
        ),
      ),
    );
  }
}