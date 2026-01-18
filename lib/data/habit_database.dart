import 'package:habit_tracker_new/datetime/date_time.dart';
import 'package:hive/hive.dart';

final _myBox = Hive.box('Habit_Database');

class HabitDatabase {
  List todaysHabitList = [];

  Map<DateTime, int> heatMapDataSet = {};

  // create initial default data
  void createDefaultData() {
    todaysHabitList = [
      //["habit name", habitCompleted]
      ["Exercise", false],
      ["Meditation", false],
      ["Read", false],
    ];

    // _myBox.put("START_DATE", todaysDateFormatted());

    DateTime oneYearAgo = DateTime.now().subtract(Duration(days: 365));

    _myBox.put("START_DATE", convertDateTimeToString(oneYearAgo));
  }

  // load data from database
  void loadData() {
    // if it is a new day, get habit list from database
    if (_myBox.get(getTodayDateString()) == null) {
      todaysHabitList = _myBox.get("CURRENT_HABIT_LIST");
      // set all habit completed to false since it is a new day
      for (var i = 0; i < todaysHabitList.length; i++) {
        todaysHabitList[i][1] = false;
      }
    } else {
      todaysHabitList = _myBox.get(getTodayDateString());
    }
  }

  // update database
  void updateDatabase() {
    // update todays entry
    _myBox.put(getTodayDateString(), todaysHabitList);

    // update the database
    _myBox.put("CURRENT_HABIT_LIST", todaysHabitList);

    // calculate habit complete percentage for each day
    calculateHabitPercentages();
    //load the heatmap
    loadHeatMap();
    _myBox.put("HEATMAP_DATA", heatMapDataSet);
  }

  void calculateHabitPercentages() {
    int countComplete = 0;
    for (var i = 0; i < todaysHabitList.length; i++) {
      if (todaysHabitList[i][1] == true) {
        countComplete++;
      }
    }
    String percent = todaysHabitList.isEmpty
        ? '0.0'
        : (countComplete / todaysHabitList.length).toStringAsFixed(1);
    _myBox.put("PERCENTAGE_SUMMARY_${getTodayDateString()}", percent);
  }

  void loadHeatMap() {
    heatMapDataSet = {}; // CLEAR OLD DATA
    DateTime startDate = convertStringToDate(_myBox.get("START_DATE"));

    int daysInBetween = DateTime.now().difference(startDate).inDays;

    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd = convertDateTimeToString(
        startDate.add(Duration(days: i)),
      );

      double strengthAsPercent = double.parse(
        _myBox.get("PERCENTAGE_SUMMARY_$yyyymmdd") ?? "0.0",
      );

      int year = startDate.add(Duration(days: i)).year;

      int month = startDate.add(Duration(days: i)).month;

      int day = startDate.add(Duration(days: i)).day;

      final percentOfEachday = <DateTime, int>{
        DateTime(year, month, day): (10 * strengthAsPercent).toInt(),
      };

      heatMapDataSet.addEntries(percentOfEachday.entries);
    }
  }
}
