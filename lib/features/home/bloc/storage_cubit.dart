import 'dart:convert';
import 'dart:io';

import 'package:cryptid/domain/crypt_service.dart';
import 'package:cryptid/models/data_changes_models.dart';
import 'package:cryptid/models/file_data_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'storage_states.dart';

class StorageCubit extends Cubit<StorageState> {
  static const _spKeyFilePath = 'filePath';
  static const _defaultFileName = 'cryptid.aes';
  final SharedPreferences _sp;
  final IEncrypterService _encrypter;
  File? _file;
  String? _filePassword;
  FileContent? _fileContent;

  StorageCubit({
    required SharedPreferences sp,
    required IEncrypterService encrypter,
  })  : _sp = sp,
        _encrypter = encrypter,
        super(const StorageLoadingState()) {
    _initialize().ignore();
  }

  Future<void> _initialize() async {
    final filePath = _sp.getString(_spKeyFilePath);
    if (filePath != null) {
      _file = File(filePath);
      final isNewFile = !await _file!.exists() || await _file!.length() < EncrypterService.ivLength;
      emit(StorageAskPasswordState(
        filePath: filePath,
        isNewFile: isNewFile,
      ));
      return;
    }

    emit(const StorageAskFilePathState());
  }

  Future<void> createInDocumentPath() async {
    try {
      final path = await getApplicationDocumentsDirectory();
      final filePath = '${path.path}/$_defaultFileName';
      _file = File(filePath);
      await _file!.create(exclusive: true);

      await _sp.setString(_spKeyFilePath, filePath);
      emit(StorageAskPasswordState(
        filePath: filePath,
        isNewFile: true,
      ));
    } catch (e, st) {
      emit(StorageState.failure(e, st: st));
    }
  }

  Future<void> onSelectFile(String filePath) async {
    try {
      await _sp.setString(_spKeyFilePath, filePath);

      _file = File(filePath);
      final fileLength = await _file!.length();

      emit(StorageAskPasswordState(
        filePath: filePath,
        isNewFile: fileLength < EncrypterService.ivLength,
      ));
    } catch (e, st) {
      emit(StorageState.failure(e, st: st));
    }
  }

  void changeFile() {
    _file = null;
    _fileContent = null;
    _filePassword = null;
    _sp.remove(_spKeyFilePath);
    emit(const StorageAskFilePathState());
  }

  Future<void> onPasswordEnter({
    required String filePath,
    required String password,
  }) async {
    try {
      _file = File(filePath);
      final fileExists = await _file!.exists();
      if (!fileExists || await _file!.length() < EncrypterService.ivLength) {
        final fileContent = FileContent.defaultGroup();
        final sourceJson = fileContent.toJson();
        final strData = jsonEncode(sourceJson);
        if (!fileExists) {
          await _file!.create();
        }
        final encryptedData = _encrypter.encrypt(utf8.encode(strData), password);
        await _file!.writeAsBytes(encryptedData);

        _filePassword = password;

        _fileContent = fileContent;

        emit(StorageSuccessState(
          filePath: filePath,
          fileContent: fileContent,
        ));
        return;
      }

      // open and decrypt file
      final encryptedData = await _file!.readAsBytes();
      final decrypt = _encrypter.decrypt(encryptedData, password);
      final message = utf8.decode(decrypt);

      final sourceJson = jsonDecode(message);
      _fileContent = FileContent.fromJson(sourceJson);

      _filePassword = password;

      emit(StorageSuccessState(
        filePath: filePath,
        fileContent: _fileContent!,
      ));
    } on ArgumentError catch (_) {
      emit(StorageState.failure('Неправильный пароль'));
    } catch (e, st) {
      emit(StorageState.failure(e, st: st));
    }
  }

  Future<void> saveNewGroup(GroupModel group) async {
    _fileContent!.groups.add(group);
    await saveFileContent();
    emit(StorageUpdateState(StorageUpdateAction.addGroup, fileContent: _fileContent!, model: group));
  }

  Future<void> updateGroup(GroupModel group, GroupChangesModel model) async {
    group.name = model.name;
    await saveFileContent();
    emit(StorageUpdateState(StorageUpdateAction.editGroup, fileContent: _fileContent!, model: group));
  }

  Future<void> deleteGroup(GroupModel group) async {
    _fileContent?.groups.remove(group);
    await saveFileContent();
    emit(StorageUpdateState(StorageUpdateAction.deleteGroup, fileContent: _fileContent!, model: group));
  }

  Future<void> saveNewDocument({
    required GroupModel selectedroup,
    required DocumentModel document,
  }) async {
    selectedroup.documents.add(document);
    await saveFileContent();
    emit(StorageUpdateState(StorageUpdateAction.addDocument, fileContent: _fileContent!, model: document));
  }

  Future<void> updateDocument({
    required DocumentModel document,
  }) async {
    await saveFileContent();
    emit(StorageUpdateState(StorageUpdateAction.editDocument, fileContent: _fileContent!, model: document));
  }

  Future<void> deleteDocument({
    required GroupModel selectedroup,
    required DocumentModel document,
  }) async {
    selectedroup.documents.remove(document);
    await saveFileContent();
    emit(StorageUpdateState(StorageUpdateAction.addDocument, fileContent: _fileContent!, model: document));
  }

  Future<void> saveFileContent() async {
    try {
      final sourceJson = _fileContent?.toJson();
      final strData = jsonEncode(sourceJson);
      final filePath = _sp.getString(_spKeyFilePath);

      if (filePath == null) {
        emit(const StorageAskFilePathState());
        return;
      }
      if (_filePassword == null) {
        emit(StorageAskPasswordState(
          filePath: filePath,
        ));
        return;
      }

      final file = File(filePath);
      if (!await file.exists()) {
        await file.create();
      }
      final encryptedData = _encrypter.encrypt(utf8.encode(strData), _filePassword!);
      await file.writeAsBytes(encryptedData);
    } catch (e, st) {
      emit(StorageState.failure(e, st: st));
    }
  }

  void showChangePasswordDialog() {
    emit(StorageShowChangePasswordDialogState());
  }

  Future<String?> changePassword(String currentPwd, String newPwd) async {
    try {
      final encryptedData = await _file!.readAsBytes();
      _encrypter.decrypt(encryptedData, currentPwd);

      _filePassword = newPwd;
      await saveFileContent();

      final filePath = _file!.path;

      _file = null;
      _fileContent = null;
      _filePassword = null;
      _sp.remove(_spKeyFilePath);

      emit(StorageAskPasswordState(
        filePath: filePath,
        isNewFile: false,
      ));
    } on ArgumentError catch (_) {
      return 'Неверный текущий пароль';
    } catch (e) {
      return e.toString();
    }
    return null;
  }
}
