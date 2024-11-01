import 'package:cryptid/core/app_theme.dart';
import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final String? title;
  final Widget body;

  const AppCard({
    this.title,
    required this.body,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(color: AppColors.dark2, borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                title!,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          body,
        ],
      ),
    );
  }
}
