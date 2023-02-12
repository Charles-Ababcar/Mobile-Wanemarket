class DateFormatter {

  static formatDate(String date) {
    String year = date.split(' ')[0].split("-")[0];
    String month = date.split(' ')[0].split("-")[1];
    String monthLitteral = getMonthByNumber(int.parse(month));

    String day = date.split(' ')[0].split("-")[2];

    return "${day} ${monthLitteral} ${year}";
  }

  static formatDateTime(String date) {
    String year = date.split(' ')[0].split("-")[0];
    String month = date.split(' ')[0].split("-")[1];
    String monthLitteral = getMonthByNumber(int.parse(month));

    String day = date.split(' ')[0].split("-")[2];

    String time = date.split(' ')[1].split('.')[0];
    return "${day} ${monthLitteral} ${year} à ${time}";
  }

  static String getMonthByNumber(int number) {
    if(number == 1)  return "Janvier";
    if(number == 2)  return "Février";
    if(number == 3)  return "Mars";
    if(number == 4)  return "Avril";
    if(number == 5)  return "Mai";
    if(number == 6)  return "Juin";
    if(number == 7)  return "Juillet";
    if(number == 8)  return "Août";
    if(number == 9)  return "Septembre";
    if(number == 10) return "Octobre";
    if(number == 11) return "Novembre";
    if(number == 12) return "Décembre";
    return "";
  }

}