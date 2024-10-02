import 'package:cryptid/models/file_data_models.dart';
import 'package:flutter/material.dart';

final class CreateDocumentData {
  final GroupModel selectedroup;
  final DocumentType documentType;
  TextEditingController titleController;
  List<EditableFieldData> fields;

  CreateDocumentData({
    required this.selectedroup,
    required this.documentType,
    required this.titleController,
    required this.fields,
  });
}

final class EditableDocumentData {
  final GroupModel selectedroup;
  final DocumentModel document;
  TextEditingController titleController;
  List<EditableFieldData> fields;

  EditableDocumentData({
    required this.selectedroup,
    required this.document,
    required this.titleController,
    required this.fields,
  });
}

final class EditableFieldData {
  String title;
  TextEditingController controller;
  FieldType fieldType;

  EditableFieldData({
    required this.title,
    required this.controller,
    required this.fieldType,
  });
}
