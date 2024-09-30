import 'package:cryptid/models/file_data_models.dart';

final class GroupChangesModel {
  final String name;

  const GroupChangesModel({
    required this.name,
  });
}

final class DialogDocumentResult {
  final GroupModel selectedroup;
  final DocumentModel documentModel;

  const DialogDocumentResult({
    required this.selectedroup,
    required this.documentModel,
  });
}
