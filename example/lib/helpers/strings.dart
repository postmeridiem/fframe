// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:fframe/fframe.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class DateTimeText extends StatelessWidget {
  const DateTimeText({
    Key? key,
    required this.datetime,
    this.style = const TextStyle(),
  }) : super(key: key);

  final DateTime datetime;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Text(
      dateTimeTextDT(datetime),
      style: style,
    );
  }
}

class DateText extends StatelessWidget {
  const DateText({
    Key? key,
    required this.datetime,
    this.style = const TextStyle(),
  }) : super(key: key);

  final DateTime datetime;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Text(
      dateTextDT(datetime),
      style: style,
    );
  }
}

class TimeText extends StatelessWidget {
  const TimeText({
    Key? key,
    required this.datetime,
    this.style = const TextStyle(),
  }) : super(key: key);

  final DateTime datetime;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Text(
      timeTextDT(datetime),
      style: style,
    );
  }
}

class TimestampDateTimeText extends StatelessWidget {
  const TimestampDateTimeText({
    Key? key,
    required this.timestamp,
    this.style = const TextStyle(),
  }) : super(key: key);

  final Timestamp timestamp;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Text(
      dateTimeTextDT((dateTimeFromTimestamp(timestamp))),
      style: style,
    );
  }
}

class TimestampDateText extends StatelessWidget {
  const TimestampDateText({
    Key? key,
    required this.timestamp,
    this.style = const TextStyle(),
  }) : super(key: key);

  final Timestamp timestamp;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Text(
      dateTextDT((dateTimeFromTimestamp(timestamp))),
      style: style,
    );
  }
}

class TimestampTimeText extends StatelessWidget {
  const TimestampTimeText({
    Key? key,
    required this.timestamp,
    this.style = const TextStyle(),
  }) : super(key: key);

  final Timestamp timestamp;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Text(
      timeTextDT(dateTimeFromTimestamp(timestamp)),
      style: style,
    );
  }
}

DateTime dateTimeFromTimestamp(Timestamp timestamp) {
  return DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
}

String dateTimeTextDT(DateTime datetime) {
  final DateFormat _formatter = DateFormat('yyyy-MM-dd  HH:mm');
  return _formatter.format(datetime);
}

String dateTextDT(DateTime datetime) {
  final DateFormat _formatter = DateFormat('yyyy-MM-dd');
  return _formatter.format(datetime);
}

String timeTextDT(DateTime datetime) {
  final DateFormat _formatter = DateFormat('HH:mm:ss');
  return _formatter.format(datetime);
}

String dateTimeTextTS(Timestamp timestamp) {
  return dateTimeTextDT(dateTimeFromTimestamp(timestamp));
}

String dateTextTS(Timestamp timestamp) {
  return dateTextDT(dateTimeFromTimestamp(timestamp));
}

String timeTextTS(Timestamp timestamp) {
  return timeTextDT(dateTimeFromTimestamp(timestamp));
}
