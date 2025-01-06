String convertDateTimeToString(DateTime datetime) {
  // get the year
  String year = datetime.year.toString();
//get the month
  String month = datetime.month.toString();
  if (month.length == 1) {
    month = "0" + month;
  }
//get the day
  String day = datetime.day.toString();
  if (day.length == 1) {
    day = "0" + day;
  }
// final format
  String yyyymmdd = year + month + day;
  return yyyymmdd;
}


// DateTime.now()-> 2023/2/11

// this is the format in which we will get the dat a in return but here we have already ignored the hour and seconds format .