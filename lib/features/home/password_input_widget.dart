import 'package:cryptid/features/home/bloc/storage_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class PasswordInputWidget extends StatelessWidget {
  final String filePath;
  final bool isNewPassword;
  const PasswordInputWidget({required this.filePath, this.isNewPassword = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Spacer(),
            if (isNewPassword)
              PasswordInputNewWidget(
                filePath,
              )
            else
              PasswordInputUnclockWidget(
                filePath,
              ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class PasswordInputUnclockWidget extends StatefulWidget {
  final String filePath;
  const PasswordInputUnclockWidget(this.filePath, {super.key});

  @override
  State<PasswordInputUnclockWidget> createState() => _PasswordInputUnclockWidgetState();
}

class _PasswordInputUnclockWidgetState extends State<PasswordInputUnclockWidget> {
  final passwordController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Введите пароль от файла'),
        const SizedBox(height: 20),
        SizedBox(
          width: 200,
          child: Column(
            children: [
              TextFormField(
                autofocus: true,
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Пароль',
                ),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                label: const Text('Открыть файл'),
                icon: const Icon(Icons.lock_open_outlined),
                onPressed: () {
                  context.read<StorageCubit>().onPasswordEnter(
                        filePath: widget.filePath,
                        password: passwordController.text,
                      );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PasswordInputNewWidget extends StatefulWidget {
  final String filePath;
  const PasswordInputNewWidget(this.filePath, {super.key});

  @override
  State<PasswordInputNewWidget> createState() => _PasswordInputNewState();
}

class _PasswordInputNewState extends State<PasswordInputNewWidget> {
  static const _passwordMinLength = 4;
  final _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Придумайте новый пароль для файла'),
        const SizedBox(height: 20),
        Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SizedBox(
            width: 200,
            child: Column(
              children: [
                TextFormField(
                  autofocus: true,
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Пароль',
                  ),
                  validator: (value) {
                    if (value == null || value.length < _passwordMinLength) {
                      return 'Пароль слишком короткий';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  autofocus: false,
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Подтвердите пароль',
                  ),
                  validator: (value) {
                    final password = passwordController.text;
                    if (password.length >= _passwordMinLength && password != value) {
                      return 'Пароли не совпадают';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  label: const Text('Открыть файл'),
                  icon: const Icon(Icons.lock_open_outlined),
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    context.read<StorageCubit>().onPasswordEnter(
                          filePath: widget.filePath,
                          password: passwordController.text,
                        );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
