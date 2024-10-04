import 'package:flutter/material.dart';

import 'package:cryptid/core/app_theme.dart';
import 'package:cryptid/domain/storage/password_generator_service.dart';
import 'package:flutter/services.dart';

class PasswordGeneratorDialog extends StatefulWidget {
  const PasswordGeneratorDialog({super.key});

  @override
  State<PasswordGeneratorDialog> createState() => _PasswordGeneratorDialogState();
}

class _PasswordGeneratorDialogState extends State<PasswordGeneratorDialog> {
  double _passwordLength = 16;
  String _password = '';
  bool isNumber = true;
  bool isSpecial = true;
  bool upper = true;
  bool lower = true;

  _PasswordGeneratorDialogState() {
    _updatePassword();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.secondary,
      title: const Text('Генерация пароля'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Slider(
            value: _passwordLength,
            max: 30,
            min: 6,
            divisions: 20,
            label: _passwordLength.toStringAsFixed(0),
            onChanged: (value) {
              setState(() {
                _passwordLength = value;
                _updatePassword();
              });
            },
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  color: AppColors.dark,
                  width: 340,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: SelectableText(
                        _password,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Сгенерировать новый',
                onPressed: () {
                  setState(() {
                    _updatePassword();
                  });
                },
                icon: const Icon(Icons.refresh_outlined),
              ),
              IconButton(
                tooltip: 'Скопировать',
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _password)).ignore();
                },
                icon: const Icon(Icons.copy_outlined),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Row(
                  children: <Widget>[
                    Checkbox(
                      value: isNumber,
                      onChanged: (bool? value) {
                        setState(() {
                          isNumber = value ?? false;
                          _updatePassword();
                        });
                      },
                    ),
                    const Text('Цифры'),
                  ],
                ),
              ),
              Expanded(
                flex: 6,
                child: Row(
                  children: <Widget>[
                    Checkbox(
                      value: isSpecial,
                      onChanged: (bool? value) {
                        setState(() {
                          isSpecial = value ?? false;
                          _updatePassword();
                        });
                      },
                    ),
                    const Text('Спецзнаки'),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Row(
                  children: <Widget>[
                    Checkbox(
                      value: lower,
                      onChanged: (bool? value) {
                        setState(() {
                          lower = value ?? false;
                          _updatePassword();
                        });
                      },
                    ),
                    const Text('Нижний регистр'),
                  ],
                ),
              ),
              Expanded(
                flex: 6,
                child: Row(
                  children: <Widget>[
                    Checkbox(
                      value: upper,
                      onChanged: (bool? value) {
                        setState(() {
                          upper = value ?? false;
                          _updatePassword();
                        });
                      },
                    ),
                    const Text('Верхний регистр'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton.icon(
          label: const Text('Закрыть'),
          icon: const Icon(Icons.close_outlined),
          onPressed: Navigator.of(context).pop,
        ),
      ],
    );
  }

  void _updatePassword() {
    _password = PasswordGenerator.generate(
      length: _passwordLength.toInt(),
      isNumber: isNumber,
      isSpecial: isSpecial,
      letterLower: lower,
      letterUpper: upper,
    );
  }
}
