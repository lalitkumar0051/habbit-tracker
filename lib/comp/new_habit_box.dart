import 'package:flutter/material.dart';

class NewHabitBox extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onAdd;
  final VoidCallback onCancel;
  const NewHabitBox({
    super.key,
    required this.onAdd,
    required this.onCancel,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 10,
      shadowColor: Colors.white,
      title: Text("Add New Habit"),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.blue, width: 2),
      ),
      content: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: "Enter Habit Name",
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        // cancel button
        TextButton(onPressed: onCancel, child: Text("Cancel")),
        // add button
        TextButton(onPressed: onAdd, child: Text("Add")),
      ],
    );
  }
}
