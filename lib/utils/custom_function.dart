import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Format {
  static String formatToRupiah(int? data) {
    NumberFormat formatToRupiah = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp',
    );

    return formatToRupiah.format(data);
  }

  static String timeFormat(Timestamp? time) {
    DateFormat timestampFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    if (time != null) {
      String formatted = timestampFormat.format(time.toDate());
      return formatted;
    }
    return '';
  }
}
