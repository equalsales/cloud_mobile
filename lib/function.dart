DateTime retconvdate(String dDate) {
  String startdate = dDate;

  String dd = startdate.substring(0, 2);
  String mm = startdate.toString().substring(3, 5);
  String yy = startdate.toString().substring(6);

  DateTime selectedDate = DateTime.parse(yy + '-' + mm + '-' + dd);
  return selectedDate;
}

DateTime getsystemdate() {
  DateTime now = new DateTime.now();
  DateTime newDate = DateTime.parse(now.toString().substring(0, 10));
  return newDate;
}
