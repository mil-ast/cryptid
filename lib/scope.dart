import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dependencies {
  final SharedPreferences sharedPreferences;
  final PackageInfo packageInfo;

  Dependencies({
    required this.sharedPreferences,
    required this.packageInfo,
  });

  static Future<Dependencies> initialize() async {
    if (Platform.isLinux) {
      FilePicker.platform = FilePickerLinux();
    } else if (Platform.isWindows) {
      FilePicker.platform = FilePickerWindows();
    }

    final sp = await SharedPreferences.getInstance();
    final packageInfo = await PackageInfo.fromPlatform();

    return Dependencies(
      sharedPreferences: sp,
      packageInfo: packageInfo,
    );
  }
}

class DependenciesScope extends InheritedWidget {
  const DependenciesScope({
    super.key,
    required this.dependencies,
    required super.child,
  });

  final Dependencies dependencies;

  static Dependencies of(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<DependenciesScope>();
    if (scope == null) {
      throw Exception('DependenciesScope not found in context');
    }

    return scope.dependencies;
  }

  @override
  bool updateShouldNotify(covariant DependenciesScope oldWidget) => false;
}
