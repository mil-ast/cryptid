import 'package:cryptid/core/app_theme.dart';
import 'package:flutter/material.dart';

class StorageButtonWidget extends StatelessWidget {
  final VoidCallback onTap;
  final Widget icon;
  final Widget label;
  const StorageButtonWidget({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        //color: AppColors.primary,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Material(
        color: AppColors.primary,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: InkWell(
          overlayColor: WidgetStatePropertyAll(
            Colors.white.withOpacity(0.15),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                icon,
                const SizedBox(width: 10),
                label,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
