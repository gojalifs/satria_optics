import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Format {
  String formatToRupiah(int data) {
    NumberFormat formatToRupiah = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp',
    );

    return formatToRupiah.format(data);
  }

  String timeFormat(Timestamp time) {
    DateFormat timestampFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    String formatted = timestampFormat.format(time.toDate());
    return formatted;
  }
}
