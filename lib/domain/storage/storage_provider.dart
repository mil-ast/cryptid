import 'dart:typed_data';

abstract interface class IStorageProvider {
  Future<Uint8List> read();
  Future<void> write(Uint8List data);
}
