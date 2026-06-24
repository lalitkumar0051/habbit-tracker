import 'package:flutter/material.dart';

class HabitTile extends StatelessWidget {
  final String habitName;
  final bool habitCompleted;
  final Function(bool?)? onChanged;
  final VoidCallback onDelete;
  const HabitTile({
    super.key,
    required this.habitName,
    required this.habitCompleted,
    this.onChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                //checkbox
                Checkbox(value: habitCompleted, onChanged: onChanged),
                //habit name
                Text(
                  habitName,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
            IconButton(
              onPressed: onDelete,
              icon: Icon(Icons.delete, semanticLabel: 'Delete habit'),
            ),
          ],
        ),
      ),
    );
  }
}
