import 'package:cryptid/features/backup/dialogs/webdav_stor/bloc/webdav_stor_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WebDavFormWidget extends StatefulWidget {
  const WebDavFormWidget({super.key});

  @override
  State<WebDavFormWidget> createState() => _WebDavFormWidgetState();
}

class _WebDavFormWidgetState extends State<WebDavFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _hostController = TextEditingController();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            autofocus: true,
            controller: _hostController,
            decoration: const InputDecoration(
              labelText: 'Хост',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Поле обязательно к заполнению';
              }
              final url = Uri.tryParse(value);
              if (url == null) {
                return 'Некорректный адрес';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _loginController,
            decoration: const InputDecoration(
              labelText: 'Логин',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Поле обязательно к заполнению';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            obscureText: true,
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Пароль',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Поле обязательно к заполнению';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              context.read<WebdavStorCubit>().checkConnect(
                    host: _hostController.text,
                    login: _loginController.text,
                    password: _passwordController.text,
                  );
            },
            label: const Text('Открыть'),
            icon: const Icon(Icons.check_sharp),
          ),
        ],
      ),
    );
  }
}
