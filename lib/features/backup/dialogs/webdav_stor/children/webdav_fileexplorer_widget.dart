import 'package:cryptid/core/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:webdav_client/webdav_client.dart';

class WebdavFileExplorerWidget extends StatefulWidget {
  final List<File> files;
  final String currentFileName;

  final void Function(String path) onSelectWebDavPath;
  const WebdavFileExplorerWidget({
    required this.currentFileName,
    required this.files,
    required this.onSelectWebDavPath,
    super.key,
  });

  @override
  State<WebdavFileExplorerWidget> createState() => _WebdavFileExplorerWidgetState();
}

class _WebdavFileExplorerWidgetState extends State<WebdavFileExplorerWidget> {
  static const _rootPathName = 'root';

  List<String> crumbs = [];
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.onSelectWebDavPath('/');
    _updateCrumbs();
  }

  @override
  void didUpdateWidget(WebdavFileExplorerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateCrumbs();
  }

  void _updateCrumbs() {
    if (widget.files.isNotEmpty) {
      final dirName = dirname(widget.files.first.path ?? '/');
      final split = dirName.split('/').where((v) => v.isNotEmpty);
      crumbs = [_rootPathName, ...split, widget.currentFileName];
    } else {
      crumbs = [_rootPathName, widget.currentFileName];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 50,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context, i) {
              final isLink = i < crumbs.length - 2;
              return InkWell(
                onTap: isLink
                    ? () {
                        final newPath =
                            '/${crumbs.sublist(0, i + 1).where((v) => v.isNotEmpty && v != _rootPathName).join('/')}';
                        widget.onSelectWebDavPath(newPath);
                      }
                    : null,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    crumbs[i],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: isLink ? AppColors.actions : null),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const Padding(
              padding: EdgeInsets.only(left: 2, top: 14, right: 2),
              child: Text('>'),
            ),
            itemCount: crumbs.length,
          ),
        ),
        Expanded(
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: widget.files.length,
                  itemBuilder: (context, i) {
                    final file = widget.files[i];
                    if (file.isDir ?? false) {
                      return ListTile(
                        leading: const Icon(Icons.folder_outlined),
                        title: Text('${file.name ?? file.path}'),
                        onTap: () {
                          widget.onSelectWebDavPath(file.path ?? '/');
                        },
                        iconColor: const Color.fromARGB(255, 255, 236, 127),
                      );
                    }
                    return ListTile(
                      leading: const Icon(Icons.insert_drive_file_outlined),
                      title: Text('${file.name ?? file.path}'),
                    );
                  },
                ),
        ),
      ],
    );
  }

  /* void _fetchData(String path) async {
    try {
      setState(() {
        final split = path.split('/').where((v) => v.isNotEmpty);
        crumbs = [_rootPathName, ...split];
        isLoading = true;
      });

      final files = await widget.fetch(path);

      setState(() {
        items = files;
        isLoading = false;
      });

      final fileName = basename(widget.curretnFilePath);

      widget.onSelectWebDavPath(BackupWebDav(
        host: widget.host,
        filePath: '$path$fileName',
        login: widget.login,
        password: widget.password,
      ));
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  } */
}
