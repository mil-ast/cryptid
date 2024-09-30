import 'package:flutter/material.dart';

class ColumnWidget extends StatelessWidget {
  final Widget header;
  final Widget child;
  const ColumnWidget({
    required this.header,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: header,
        ),
        const Divider(),
        Expanded(
          child: child,
        ),
      ],
    );
  }
}
