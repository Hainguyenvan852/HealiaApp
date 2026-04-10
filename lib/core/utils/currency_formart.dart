import 'package:intl/intl.dart';

class CurrencyFormart {

  static String formatVND(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫', // Ký hiệu tiền tệ
      decimalDigits: 0, // Số chữ số thập phân
    );
    return formatter.format(amount);
  }

  static String formatUSD(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_US',
      customPattern: '#,###',
      symbol: '\$',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }
}
