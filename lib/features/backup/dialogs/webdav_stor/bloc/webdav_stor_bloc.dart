import 'package:cryptid/models/properties_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webdav_client/webdav_client.dart';

part 'webdav_states.dart';

class WebdavStorCubit extends Cubit<WebdavStorState> {
  final String curretnFileName;

  Client? _client;
  String _host = '';
  String _login = '';
  String _password = '';
  String _selectedFilePath = '/';

  WebdavStorCubit({required this.curretnFileName}) : super(const WebdavStorStepFormState());

  void checkConnect({required String host, required String login, required String password}) async {
    try {
      _client = newClient(
        host,
        user: login,
        password: password,
        debug: kDebugMode,
      );
      await _client!.ping();

      final files = await _client!.readDir('/');

      _host = host;
      _login = login;
      _password = password;

      emit(WebdavStorStepSelectPathState(
        fileName: '',
        files: files,
      ));
    } on DioException catch (e) {
      emit(WebdavStorFailureState('${e.message ?? e.error}'));
    } catch (e) {
      emit(WebdavStorFailureState(e.toString()));
    }
  }

  void onSelectWebDavPath(String path) async {
    emit(const WebdavStorOnSelectWebDavPathState());

    try {
      final files = await _client!.readDir(path);

      _selectedFilePath = path;

      emit(WebdavStorStepSelectPathState(
        fileName: curretnFileName,
        files: files,
      ));
    } on DioException catch (e) {
      emit(WebdavStorFailureState('${e.message ?? e.error}'));
    } catch (e) {
      emit(WebdavStorFailureState(e.toString()));
    }
  }

  void create() {
    final backupModel = BackupWebDav(
      filePath: '$_selectedFilePath$curretnFileName',
      host: _host,
      login: _login,
      password: _password,
    );
    emit(WebdavStorOnCompleteState(backupModel));
  }
}
