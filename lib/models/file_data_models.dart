class FileContent {
  List<GroupModel> groups;
  FileContent({
    required this.groups,
  });

  factory FileContent.empty() => FileContent(groups: []);
  factory FileContent.defaultGroup() => FileContent(groups: [
        GroupModel(name: 'General', documents: []),
      ]);

  Map<String, Object?> toJson() => {
        'groups': groups
            .map(
              (e) => e.toJson(),
            )
            .toList(),
      };

  factory FileContent.fromJson(Map<String, dynamic> json) => FileContent(
      groups: (json['groups'] as List<dynamic>)
          .cast<Map<String, Object?>>()
          .map(
            (e) => GroupModel.fromJson(e),
          )
          .toList());
}

class GroupModel {
  String name;
  List<DocumentModel> documents;

  GroupModel({
    required this.name,
    required this.documents,
  });

  Map<String, Object?> toJson() => {
        'name': name,
        'documents': documents
            .map(
              (e) => e.toJson(),
            )
            .toList(),
      };

  factory GroupModel.fromJson(Map<String, dynamic> json) => GroupModel(
      name: json['name'] as String,
      documents: ((json['documents'] ?? []) as List<dynamic>)
          .cast<Map<String, Object?>>()
          .map(
            (e) => DocumentModel.fromJson(e),
          )
          .toList());
}

enum DocumentType {
  note('Заметка'),
  document('Документ'),
  site('Сайт');

  final String label;
  const DocumentType(this.label);
  factory DocumentType.fromString(String value) => DocumentType.values.singleWhere((e) => e.name == value);
}

final class DocumentModel {
  String title;
  DocumentType type;
  List<CustomField> customFields;
  DocumentModel(this.title, {required this.customFields, this.type = DocumentType.note});

  Map<String, Object?> toJson() {
    final data = <String, Object?>{
      'title': title,
      'type': type.name,
      'cf': customFields.map((e) => e.toJson()).toList(),
    };
    return data;
  }

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      (json['title'] ?? '') as String,
      type: DocumentType.fromString(json['type'] as String),
      customFields: ((json['cf'] ?? []) as List<dynamic>).map((e) => CustomField.fromJson(e)).toList(),
    );
  }
}

enum FieldType {
  string('Строка'),
  text('Текст'),
  site('Сайт'),
  password('Пароль');

  final String label;
  const FieldType(this.label);
  factory FieldType.fromString(String value) => FieldType.values.singleWhere((e) => e.name == value);
}

final class CustomField {
  String title;
  String value;
  FieldType fieldType;

  CustomField({
    required this.title,
    required this.value,
    this.fieldType = FieldType.string,
  });

  Map<String, String> toJson() => {
        't': title,
        'v': value,
        'ft': fieldType.name,
      };

  factory CustomField.fromJson(Map<String, dynamic> json) => CustomField(
        title: json['t'] as String,
        value: json['v'] as String,
        fieldType: FieldType.fromString((json['ft'] ?? FieldType.string.name) as String),
      );
}
