import 'dart:io';
import 'dart:typed_data';

import 'package:cryptid/domain/storage/storage_provider.dart';

class FileDataProvider implements IStorageProvider {
  final File _file;

  FileDataProvider(this._file);

  @override
  Future<Uint8List> read() async {
    final isExists = await _file.exists();
    if (!isExists) {
      throw Exception('Файл ${_file.path} не найден');
    }
    return Uint8List.fromList([]);
  }

  @override
  Future<void> write(Uint8List data) async {
    final isExists = await _file.exists();
    if (!isExists) {
      await _file.create();
    }
    await _file.writeAsBytes(data);
  }
}
