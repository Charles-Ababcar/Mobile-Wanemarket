import 'package:intl/intl.dart';

class PriceFormat {

  static String formatePrice(double price) {
    // final currencyFormatter = NumberFormat('#,##0.00', 'ID');
    final currencyFormatter = NumberFormat('#,##0', 'ID');
    String formattedPrice = currencyFormatter.format(price);
    formattedPrice = formattedPrice.replaceAll(".", " ");
    formattedPrice += " CFA";

    return formattedPrice;
  }

}