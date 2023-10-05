import 'package:easy_localization/easy_localization.dart';

String getTime(String rawTime) {
  DateTime now = DateTime.now();

  DateTime date = DateTime.parse(rawTime).toLocal();
  var difference = now.difference(date);
  String time = "미정";
  if (difference.inMinutes < 1) {
    time = "${difference.inSeconds}초 전";
  } else if (difference.inHours < 1) {
    time = '${difference.inMinutes}분 전';
  } else if (date.day == now.day) {
    time = '${DateFormat('HH').format(date)}:${DateFormat('mm').format(date)}';
  } else if (date.year == now.year) {
    time = '${DateFormat('MM').format(date)}/${DateFormat('dd').format(date)}';
  } else {
    time =
        '${DateFormat('yyyy').format(date)}/${DateFormat('MM').format(date)}/${DateFormat('dd').format(date)}';
  }

  return time;
}
