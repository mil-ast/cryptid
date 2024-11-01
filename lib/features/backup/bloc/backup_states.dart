part of 'backup_bloc.dart';

sealed class BackupState {
  final bool needBuild;
  const BackupState(this.needBuild);
}

final class BackupSuccessState extends BackupState {
  final List<BackupValue> backup;
  BackupSuccessState(this.backup) : super(true);
}

final class BackupConfirmDeleteState extends BackupState {
  final BackupValue backupValue;
  const BackupConfirmDeleteState(this.backupValue) : super(false);
}
