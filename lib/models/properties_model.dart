enum BackupType {
  file,
  webdav,
  disabled,
}

final class PropertiesModel {
  final List<BackupValue> backup;

  PropertiesModel({
    required this.backup,
  });

  Map<String, Object> toJson() => {
        'backup': backup.map((e) => e.toJson()).toList(),
      };

  factory PropertiesModel.fromJson(Map<String, Object?> json) => PropertiesModel(
        backup: (json['backup'] as List<dynamic>).cast<Map<String, Object?>>().map(BackupValue.fromJson).toList(),
      );
}

sealed class BackupValue {
  final BackupType backupType;
  const BackupValue({required this.backupType});

  String title();
  Map<String, Object> toJson();

  factory BackupValue.fromJson(Map<String, Object?> json) {
    switch (json['type'] as String) {
      case 'webdav':
        return BackupWebDav(
          host: json['host'] as String,
          login: json['login'] as String,
          password: json['password'] as String,
          filePath: json['filePath'] as String,
        );
      case 'file':
        return BackupFile(
          path: json['path'] as String,
        );
    }

    return const BackupDisabled();
  }
}

final class BackupWebDav extends BackupValue {
  final String host;
  final String login;
  final String password;
  final String filePath;
  const BackupWebDav({
    required this.host,
    required this.login,
    required this.password,
    required this.filePath,
  }) : super(backupType: BackupType.webdav);

  @override
  Map<String, Object> toJson() => {
        'type': super.backupType.name,
        'host': host,
        'login': login,
        'password': password,
        'filePath': filePath,
      };

  @override
  String title() => host;
}

final class BackupFile extends BackupValue {
  final String path;
  const BackupFile({
    required this.path,
  }) : super(backupType: BackupType.file);
  @override
  Map<String, Object> toJson() => {
        'type': super.backupType.name,
        'path': path,
      };

  @override
  String title() => path;
}

final class BackupDisabled extends BackupValue {
  const BackupDisabled() : super(backupType: BackupType.disabled);
  @override
  Map<String, Object> toJson() => {
        'type': super.backupType.name,
      };

  @override
  String title() => 'disabled';
}
