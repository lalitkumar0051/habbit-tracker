import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  final Function() onPressed;
  const FloatingButton({super.key, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: Icon(Icons.add, semanticLabel: 'Add new habit'),
    );
  }
}
