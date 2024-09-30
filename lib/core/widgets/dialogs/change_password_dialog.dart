import 'package:cryptid/features/home/bloc/storage_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  static const _passwordMinLength = 4;

  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Изменить пароль'),
      content: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              autofocus: true,
              controller: _currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Текущий пароль',
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.length < _passwordMinLength) {
                  return 'Пароль слишком короткий';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              autofocus: true,
              controller: _newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Новый пароль',
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (_currentPasswordController.text.length < _passwordMinLength) {
                  return null;
                }
                if (value == null || value.length < _passwordMinLength) {
                  return 'Пароль слишком короткий';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              autofocus: true,
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Повторите новый пароль',
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (_currentPasswordController.text.length < _passwordMinLength ||
                    _newPasswordController.text.length < _passwordMinLength) {
                  return null;
                }

                if (_newPasswordController.text != value) {
                  return 'Пароли не совпадают';
                }

                return null;
              },
            ),
            const SizedBox(height: 20),
            if (_errorMessage != null)
              Card(
                child: Text(_errorMessage!),
              ),
          ],
        ),
      ),
      scrollable: true,
      insetPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 26, vertical: 10),
      actionsPadding: const EdgeInsets.all(8),
      actionsAlignment: MainAxisAlignment.end,
      actions: <Widget>[
        TextButton(
          child: const Text(
            'Отмена',
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FilledButton(
          onPressed: () async {
            _errorMessage = null;

            if (!_formKey.currentState!.validate()) {
              return;
            }
            final err = await context
                .read<StorageCubit>()
                .changePassword(_currentPasswordController.text, _newPasswordController.text);

            if (err != null) {
              setState(() {
                _errorMessage = err;
              });
              return;
            }

            if (context.mounted) {
              Navigator.pop(context, true);
            }
          },
          child: const Text('Сохранить'),
        ),
      ],
    );
  }
}
