part of 'webdav_stor_bloc.dart';

sealed class WebdavStorState {
  final bool needBuild;
  const WebdavStorState(this.needBuild);
}

sealed class WebdavStorStepState extends WebdavStorState {
  const WebdavStorStepState() : super(true);
}

final class WebdavStorStepFormState extends WebdavStorStepState {
  const WebdavStorStepFormState();
}

final class WebdavStorStepSelectPathState extends WebdavStorStepState {
  final String fileName;
  final List<File> files;

  WebdavStorStepSelectPathState({
    required this.fileName,
    required this.files,
  });

  WebdavStorStepSelectPathState copyWith({
    required List<File> files,
  }) =>
      WebdavStorStepSelectPathState(
        fileName: fileName,
        files: files,
      );
}

final class WebdavStorFailureState extends WebdavStorState {
  final String error;
  const WebdavStorFailureState(this.error) : super(false);
}

final class WebdavStorOnSelectWebDavPathState extends WebdavStorState {
  const WebdavStorOnSelectWebDavPathState() : super(false);
}

final class WebdavStorOnCompleteState extends WebdavStorState {
  final BackupWebDav model;
  const WebdavStorOnCompleteState(this.model) : super(false);
}
