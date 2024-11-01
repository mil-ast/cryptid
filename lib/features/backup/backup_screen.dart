import 'package:cryptid/core/widgets/app_card_widget.dart';
import 'package:cryptid/core/widgets/backup_type_icon_widget.dart';
import 'package:cryptid/core/widgets/dialogs/cinfirmation_dialog.dart';
import 'package:cryptid/features/backup/bloc/backup_bloc.dart';
import 'package:cryptid/features/backup/children/storage_button_widget.dart';
import 'package:cryptid/features/backup/dialogs/file_stor/file_stor_dialog.dart';
import 'package:cryptid/features/backup/dialogs/webdav_stor/webdav_stor_dialog.dart';
import 'package:cryptid/features/home/bloc/storage_cubit.dart';
import 'package:cryptid/models/properties_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class BackupScreenWidget extends StatelessWidget {
  final List<BackupValue> backup;
  final String filePath;

  const BackupScreenWidget({required this.backup, required this.filePath, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Резервная копия'),
      ),
      body: BlocProvider(
        create: (context) => BackupCubit(backup: backup),
        child: BlocConsumer<BackupCubit, BackupState>(
          listenWhen: (previous, current) => !current.needBuild,
          listener: (context, state) async {
            if (state is BackupConfirmDeleteState) {
              final isOk = await showDialog(
                context: context,
                builder: (context) => const ConfirmationDialog(
                  message: 'Вы действительно хотите удалить резервную копию?',
                  title: 'Удаление резервной копии',
                ),
              );
              if (isOk && context.mounted) {
                await context.read<StorageCubit>().deleteBackup(state.backupValue);
                if (context.mounted) {
                  backup.remove(state.backupValue);
                  context.read<BackupCubit>().refresh();
                }
              }
              return;
            }
          },
          buildWhen: (previous, current) => current.needBuild,
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: AppCard(
                    title: 'Добавьте новую резервную копию',
                    body: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        StorageButtonWidget(
                          icon: const Icon(Icons.file_open_outlined, color: Colors.white),
                          label: const Text('Файл'),
                          onTap: () {
                            _showDialogSelectFilePath(context, curretnFilePath: filePath);
                          },
                        ),
                        const SizedBox(width: 20),
                        StorageButtonWidget(
                          icon: const Icon(Icons.language, color: Colors.white),
                          label: const Text('WebDAV'),
                          onTap: () {
                            _showDialogSettingsWebdav(context, curretnFilePath: filePath);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 28),
                    child: ListView.separated(
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: backup.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: BackupIconWidget(backup[index].backupType),
                          title: Text(backup[index].title()),
                          mouseCursor: MouseCursor.defer,
                          trailing: IconButton(
                            onPressed: () {
                              context.read<BackupCubit>().confirmDelete(backup[index]);
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showDialogSelectFilePath(BuildContext context, {required String curretnFilePath}) async {
    final result = await showDialog<String?>(
      context: context,
      builder: (context) => FileStorDialog(
        currentFilePath: curretnFilePath,
        backupFiles: backup
            .where(
              (b) => b.backupType == BackupType.file,
            )
            .map((b) => (b as BackupFile).path)
            .toList(),
      ),
    );
    if (result == null || !context.mounted) {
      return;
    }
    final backupFile = BackupFile(path: result);
    await _addNewBackupAndRefresh(context, backupFile);
  }

  void _showDialogSettingsWebdav(BuildContext context, {required String curretnFilePath}) async {
    final backupWebDav = await showDialog<BackupWebDav?>(
      context: context,
      builder: (context) => WebdavStorDialog(curretnFilePath: curretnFilePath),
    );
    if (backupWebDav == null || !context.mounted) {
      return;
    }
    await _addNewBackupAndRefresh(context, backupWebDav);
  }

  Future<void> _addNewBackupAndRefresh(BuildContext context, BackupValue backupWebDav) async {
    await context.read<StorageCubit>().addBackup(backupWebDav);
    backup.add(backupWebDav);

    if (context.mounted) {
      context.read<BackupCubit>().refresh();
    }
  }
}
