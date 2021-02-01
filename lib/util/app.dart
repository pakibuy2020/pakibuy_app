import 'dart:math';

class AppUtil {
  static String urlBackend = 'https://pakibuy.herokuapp.com';

  static String status(int status) {
    if (status == 1) {
      return 'Shopping';
    } else if (status == 2) {
      return 'Payment Processing';
    } else if (status == 3) {
      return 'Shipping';
    } else if (status == 4) {
      return 'Recieved';
    } else if (status == 5) {
      return 'Cancel';
    } else if (status == 6) {
      return 'Verification';
    } else {
      return 'Status Unknown';
    }
  }

  static double roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }
}
