import 'package:cryptid/models/properties_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'backup_states.dart';

class BackupCubit extends Cubit<BackupState> {
  final List<BackupValue> _backup;

  BackupCubit({
    required List<BackupValue> backup,
  })  : _backup = backup,
        super(BackupSuccessState(backup));

  void confirmDelete(BackupValue backupValue) {
    emit(BackupConfirmDeleteState(backupValue));
  }

  void refresh() {
    emit(BackupSuccessState(_backup));
  }
}
