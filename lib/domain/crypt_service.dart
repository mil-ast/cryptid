import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

abstract interface class IEncrypterService {
  Uint8List decrypt(Uint8List encryptedData, String password);
  Uint8List encrypt(Uint8List sourse, String password);
}

class EncrypterService implements IEncrypterService {
  static const int ivLength = 16;

  @override
  Uint8List decrypt(Uint8List encryptedData, String password) {
    if (encryptedData.length < ivLength) {
      throw Exception('Длина данных слишком короткая');
    }
    final encrypter = _getEncrypter(password);

    final ivBytes = encryptedData.sublist(0, ivLength);
    final rawEncryptedData = encryptedData.sublist(ivLength);

    final iv = IV(ivBytes);
    final encrypted = Encrypted(rawEncryptedData);
    final decrypted = encrypter.decryptBytes(encrypted, iv: iv);
    return Uint8List.fromList(decrypted);
  }

  @override
  Uint8List encrypt(Uint8List sourse, String password) {
    final encrypter = _getEncrypter(password);
    final iv = IV.fromLength(ivLength);
    final encrypted = encrypter.encryptBytes(sourse, iv: iv);
    return Uint8List.fromList([...iv.bytes, ...encrypted.bytes]);
  }

  Encrypter _getEncrypter(String password, {AESMode mode = AESMode.sic, String padding = 'PKCS7'}) {
    final passwirdHash = md5.convert(utf8.encode(password)).toString();
    final key = Key.fromUtf8(passwirdHash);
    return Encrypter(AES(key, mode: mode, padding: padding));
  }
}
