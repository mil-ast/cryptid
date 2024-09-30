import 'package:cryptid/core/app_theme.dart';
import 'package:cryptid/domain/storage/password_generator_service.dart';
import 'package:flutter/material.dart';

class PasswordGeneratorWidget extends StatefulWidget {
  const PasswordGeneratorWidget({super.key});

  @override
  State<PasswordGeneratorWidget> createState() => _PasswordGeneratorWidgetState();
}

class _PasswordGeneratorWidgetState extends State<PasswordGeneratorWidget> {
  double _passwordLength = 16;
  String _password = '';
  bool isNumber = true;
  bool isSpecial = true;

  _PasswordGeneratorWidgetState() {
    _updatePassword();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.secondary,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Пароль'),
          IconButton(
            onPressed: Navigator.of(context).pop,
            icon: const Icon(Icons.close),
          )
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Slider(
            value: _passwordLength,
            max: 30,
            min: 10,
            divisions: 20,
            label: _passwordLength.toStringAsFixed(0),
            onChanged: (value) {
              setState(() {
                _passwordLength = value;
                _updatePassword();
              });
            },
          ),
          Container(
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
          const SizedBox(height: 20),
          Row(
            children: [
              Row(
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
              const SizedBox(width: 20),
              Row(
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
            ],
          ),
        ],
      ),
      actions: [
        TextButton.icon(
          label: const Text('Новый'),
          icon: const Icon(Icons.refresh_outlined),
          onPressed: () {
            setState(() {
              _updatePassword();
            });
          },
        ),
        FilledButton.icon(
          label: const Text('Применить'),
          icon: const Icon(Icons.done),
          onPressed: () {
            Navigator.of(context).pop(_password);
          },
        ),
      ],
    );
  }

  void _updatePassword() {
    _password = PasswordGenerator.generate(
      length: _passwordLength.toInt(),
      isNumber: isNumber,
      isSpecial: isSpecial,
      letter: true,
    );
  }
}
