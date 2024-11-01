import 'package:cryptid/features/documents/bloc/documents_bloc.dart';
import 'package:cryptid/features/groups/bloc/groups_cubit.dart';
import 'package:cryptid/features/home/bloc/storage_cubit.dart';
import 'package:cryptid/scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppScopeWidget extends StatelessWidget {
  final Widget child;
  const AppScopeWidget({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final dependencies = DependenciesScope.of(context);
            return StorageCubit(
              sp: dependencies.sharedPreferences,
              encrypter: dependencies.encryptService,
              backup: dependencies.backupService,
            );
          },
        ),
        BlocProvider(
          create: (context) => GroupsCubit(),
        ),
        BlocProvider(
          create: (context) => DocumentsCubit(),
        ),
      ],
      child: child,
    );
  }
}
