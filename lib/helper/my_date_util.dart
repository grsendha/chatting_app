import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDateUtil {
  static String getFormattedTime(
      {required BuildContext context, required String time}) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }

  static String getLastMEssageTime(
      {required BuildContext context,
      required String time,
      bool showYear = false}) {
    final DateTime sentTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();

    if (now.day == sentTime.day &&
        now.month == sentTime.month &&
        now.year == sentTime.year) {
      return TimeOfDay.fromDateTime(sentTime).format(context);
    }

    return showYear
        ? '${sentTime.day} ${getMonth(sentTime)} ${sentTime.year}'
        : '${sentTime.day} ${getMonth(sentTime)}';
  }

  static String getMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sept';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
    }
    return 'NA';
  }

/* ----------------------- //get formatted last active ---------------------- */
  static String getLastActiveTime(
      {required BuildContext context, required String lastActive}) {
    final int i = int.parse(lastActive) ?? -1;
    /* ---------- if time is not available then return below statement ---------- */

    if (i == -1) return 'Last Seen Not Available';

    DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
    DateTime now = DateTime.now();

    String formattedTime = TimeOfDay.fromDateTime(time).format(context);
    if (time.day == now.day &&
        time.month == now.month &&
        time.year == now.year) {
      return 'Last Seen today at $formattedTime';
    }

    if ((now.difference(time).inHours / 24).round() == 1) {
      return 'Last Seen yesterday at $formattedTime';
    }
    String month = getMonth(time);
    return 'Last Seen on ${time.day} $month on$formattedTime';
  }
}
