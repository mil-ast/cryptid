part of 'storage_cubit.dart';

sealed class StorageState {
  const StorageState();

  factory StorageState.failure(Object err, {StackTrace? st}) => StorageFailureState(
        message: err.toString(),
        st: st,
      );
}

class StorageParamsState extends StorageState {
  final String? filePath;
  const StorageParamsState({
    this.filePath,
  });
}

class StorageLoadingState extends StorageParamsState {
  const StorageLoadingState();
}

class StorageAskFilePathState extends StorageParamsState {
  const StorageAskFilePathState();
}

class StorageAskPasswordState extends StorageParamsState {
  final bool isNewFile;
  const StorageAskPasswordState({
    this.isNewFile = false,
    required super.filePath,
  });
}

class StorageSuccessState extends StorageParamsState {
  final FileContent fileContent;
  const StorageSuccessState({
    required super.filePath,
    required this.fileContent,
  });
}

// StorageFailureState
class StorageFailureState extends StorageState {
  final String message;
  final StackTrace? st;
  const StorageFailureState({
    required this.message,
    this.st,
  });
}

//StorageUpdateState
enum StorageUpdateAction {
  addGroup,
  editGroup,
  deleteGroup,
  addDocument,
  editDocument,
}

class StorageUpdateState<T> extends StorageState {
  final StorageUpdateAction action;
  final FileContent fileContent;
  final T model;
  const StorageUpdateState(
    this.action, {
    required this.fileContent,
    required this.model,
  });
}

// Actions
class StorageActionsState extends StorageState {
  const StorageActionsState();
}

class StorageShowChangePasswordDialogState extends StorageActionsState {
  StorageShowChangePasswordDialogState();
}
