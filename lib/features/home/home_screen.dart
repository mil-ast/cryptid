import 'package:cryptid/core/widgets/dialogs/change_password_dialog.dart';
import 'package:cryptid/core/widgets/dialogs/password_generator_dialog.dart';
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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: PopupMenuButton<void>(
                        tooltip: 'Меню',
                        icon: const Icon(Icons.menu_outlined),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            onTap: context.read<StorageCubit>().changeFile,
                            child: const ListTile(
                              leading: Icon(Icons.file_open_outlined),
                              title: Text('Открыть другой файл'),
                              mouseCursor: MouseCursor.defer,
                            ),
                          ),
                          PopupMenuItem(
                            onTap: context.read<StorageCubit>().showChangePasswordDialog,
                            child: const ListTile(
                              leading: Icon(Icons.lock_outline),
                              title: Text('Изменить пароль'),
                              mouseCursor: MouseCursor.defer,
                            ),
                          ),
                          const PopupMenuDivider(),
                          PopupMenuItem(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) => const PasswordGeneratorDialog(),
                              ).ignore();
                            },
                            child: const ListTile(
                              leading: Icon(Icons.password_outlined),
                              title: Text('Генератор паролей'),
                              mouseCursor: MouseCursor.defer,
                            ),
                          ),
                          PopupMenuItem(
                            onTap: () {
                              showAboutDialog(
                                context: context,
                                applicationIcon: SvgPicture.asset(
                                  'assets/logo.svg',
                                  width: 52,
                                  height: 52,
                                ),
                                applicationName: 'Cryptid',
                                useRootNavigator: false,
                                applicationVersion: DependenciesScope.of(context).packageInfo.version,
                                children: [
                                  TextButton.icon(
                                    onPressed: () {
                                      launchUrlString('https://github.com/mil-ast/cryptid').ignore();
                                    },
                                    label: const Text('cryptid'),
                                    icon: SvgPicture.asset(
                                      'assets/github.svg',
                                      width: 24,
                                      height: 24,
                                    ),
                                  ),
                                ],
                              );
                            },
                            child: const ListTile(
                              leading: Icon(Icons.info_outline),
                              title: Text('О приложении'),
                              mouseCursor: MouseCursor.defer,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    FilePathWidget(state.filePath),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
