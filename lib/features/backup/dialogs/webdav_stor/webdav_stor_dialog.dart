import 'package:cryptid/features/backup/dialogs/webdav_stor/bloc/webdav_stor_bloc.dart';
import 'package:cryptid/features/backup/dialogs/webdav_stor/children/webdav_fileexplorer_widget.dart';
import 'package:cryptid/features/backup/dialogs/webdav_stor/children/webdav_stor_form_widget.dart';
import 'package:cryptid/core/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as path;

class WebdavStorDialog extends StatefulWidget {
  const WebdavStorDialog({required this.curretnFilePath, super.key});

  final String curretnFilePath;

  @override
  State<WebdavStorDialog> createState() => _WebdavStorDialogState();
}

class _WebdavStorDialogState extends State<WebdavStorDialog> {
  late final ({double height, double width}) _dialogSize;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dialogSize = context.getDialogSize(minWidth: 300, maxWidth: 600, minHeight: 160, maxHeight: 440);
  }

  @override
  Widget build(BuildContext context) {
    final fileName = path.basename(widget.curretnFilePath);
    return BlocProvider(
      create: (context) => WebdavStorCubit(curretnFileName: fileName),
      child: AlertDialog(
        title: const Text('Webdav копия'),
        content: SingleChildScrollView(
          child: SizedBox(
            width: _dialogSize.width,
            height: _dialogSize.height,
            child: BlocConsumer<WebdavStorCubit, WebdavStorState>(
              listenWhen: (previous, current) => !current.needBuild,
              listener: (context, state) {
                if (state is WebdavStorFailureState) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(state.error),
                  ));
                } else if (state is WebdavStorOnCompleteState) {
                  Navigator.of(context).pop(state.model);
                }
              },
              buildWhen: (previous, current) => current.needBuild,
              builder: (context, state) {
                if (state is WebdavStorStepState) {
                  return switch (state) {
                    WebdavStorStepFormState() => const WebDavFormWidget(),
                    WebdavStorStepSelectPathState() => WebdavFileExplorerWidget(
                        currentFileName: state.fileName,
                        files: state.files,
                        onSelectWebDavPath: (path) {
                          context.read<WebdavStorCubit>().onSelectWebDavPath(path);
                        },
                      ),
                  };
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text('Отмена'),
          ),
          BlocBuilder<WebdavStorCubit, WebdavStorState>(
            buildWhen: (previous, current) => current is WebdavStorOnSelectWebDavPathState,
            builder: (context, state) {
              if (state is WebdavStorOnSelectWebDavPathState) {
                return FilledButton(
                  onPressed: context.read<WebdavStorCubit>().create,
                  child: const Text('Применить'),
                );
              }
              return const FilledButton(
                onPressed: null,
                child: Text('Применить'),
              );
            },
          ),
        ],
      ),
    );
  }
}

// https://webdav.yandex.ru
// gzgscvpwvyycjkzq
