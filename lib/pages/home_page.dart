import 'package:flutter/material.dart';
import 'package:habit_tracker_new/comp/floating_button.dart';
import 'package:habit_tracker_new/comp/habit_tile.dart';
import 'package:habit_tracker_new/comp/monthly_summary.dart';
import 'package:habit_tracker_new/comp/new_habit_box.dart';
import 'package:habit_tracker_new/data/habit_database.dart';
import 'package:habit_tracker_new/datetime/date_time.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _newHabitNameController = TextEditingController();
  HabitDatabase db = HabitDatabase();
  final _myBox = Hive.box('Habit_Database');

  @override
  void initState() {
    // if first time ever opening the app, then create default data
    if (_myBox.get("CURRENT_HABIT_LIST") == null) {
      db.createDefaultData();
    } else {
      //if there already exists data
      db.loadData();
    }
    // db.updateDatabase();
    db.loadHeatMap();
    super.initState();
  }

  // checkbox tapped
  void onChanged(bool? value, int index) {
    setState(() {
      db.todaysHabitList[index][1] = value ?? false;
    });

    db.updateDatabase();
  }

  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) {
        return NewHabitBox(
          controller: _newHabitNameController,
          onAdd: onAddNewHabit,
          onCancel: onCancelNewHabit,
        );
      },
    );
  }

  void onAddNewHabit() {
    // add new habit to list
    setState(() {
      db.todaysHabitList.add([_newHabitNameController.text, false]);
    });
    // clears the field
    _newHabitNameController.clear();

    // pop the dialog box
    Navigator.pop(context);

    db.updateDatabase();
  }

  // cancel new habit
  void onCancelNewHabit() {
    // clears the field
    _newHabitNameController.clear();

    // pop the dialog box
    Navigator.pop(context);
  }

  void deleteHabit(int index) {
    setState(() {
      db.todaysHabitList.removeAt(index);
    });
    db.updateDatabase();
  }

  @override
  void dispose() {
    _newHabitNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold Color
      backgroundColor: Colors.grey[300],
      // App Bar
      appBar: AppBar(title: const Text('Habit Tracker')),
      // floating action button
      floatingActionButton: FloatingButton(onPressed: createNewHabit),
      // List of habits
      body: ListView(
        children: [
          MonthlySummary(
            datasets: db.heatMapDataSet,
            startDate:
                _myBox.get("START_DATE") ??
                convertDateTimeToString(
                  DateTime.now().subtract(Duration(days: 365)),
                ),
          ),

          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: db.todaysHabitList.length,
            itemBuilder: (context, index) {
              return HabitTile(
                habitName: db.todaysHabitList[index][0],
                habitCompleted: db.todaysHabitList[index][1] ?? false,
                onChanged: (value) {
                  onChanged(value, index);
                },
                onDelete: () {
                  deleteHabit(index);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
