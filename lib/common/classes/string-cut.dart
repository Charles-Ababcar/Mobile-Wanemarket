class StringWrapper {

  static String cut(String title, int limit) {

    if(title.length <= limit) {
      return title;
    } else
      return title.substring(0, limit) + "...";
  }

  static formatDate(DateTime dateTime, bool needTime) {
    if(needTime) {
      return "${dateTime.day}/${dateTime.month}/${dateTime.year} à ${dateTime.hour}h${dateTime.minute}";
    } else {
      return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    }
  }

  static String valueOfEmpty(String? value) {
    if (value == null) {
      return "";
    } else {
      return value;
    }
  }
}