import 'dart:typed_data';

abstract interface class IEncrypterService {
  Uint8List decrypt(Uint8List encryptedData, String password);
  Uint8List encrypt(Uint8List sourse, String password);
}
