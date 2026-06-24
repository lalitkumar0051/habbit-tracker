String getTodayDateString() {
  // today
  var dateTimeObject = DateTime.now();
  // year in the format YYYY
  String year = dateTimeObject.year.toString();

  // month in the format MM
  String month = dateTimeObject.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }

  // day in the format DD
  String day = dateTimeObject.day.toString();
  if (day.length == 1) {
    day = '0$day';
  }
  String yyyymmdd = year + month + day;
  return yyyymmdd;
}

DateTime convertStringToDate(String? yyyymmdd) {
  // validate input
  if (yyyymmdd == null || yyyymmdd.length != 8) {
    return DateTime.now();
  }

  try {
    // year
    int yyyy = int.parse(yyyymmdd.substring(0, 4));
    // month
    int mm = int.parse(yyyymmdd.substring(4, 6));
    // day
    int dd = int.parse(yyyymmdd.substring(6, 8));

    DateTime dateTimeObject = DateTime(yyyy, mm, dd);
    return dateTimeObject;
  } catch (e) {
    return DateTime.now();
  }
}

String convertDateTimeToString(DateTime dateTime) {
  // year
  String year = dateTime.year.toString();
  // month
  String month = dateTime.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }

  // day
  String day = dateTime.day.toString();
  if (day.length == 1) {
    day = '0$day';
  }

  String yyyymmdd = year + month + day;
  return yyyymmdd;
}
