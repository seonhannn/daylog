import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:table_calendar/table_calendar.dart';
import 'main.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key, required this.getFocusedDay, required this.uid});

  final getFocusedDay, uid;

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime today = DateTime.now();
  DateTime day = DateTime.now();
  var event;

  void _onDaySelected(DateTime day, DateTime focusedDay) async {
    today = day;
    widget.getFocusedDay(focusedDay);
    setState(() {});
  }

  getData() async {
    event = await firestore
        .collection("data")
        .doc(widget.uid)
        .collection('userData')
        .get();
  }

  @override
  void initState() {
    super.initState();
    getData();
    _onDaySelected(day, day);
    // checkData();
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      focusedDay: today,
      onDaySelected: _onDaySelected,
      selectedDayPredicate: ((day) {
        return isSameDay(day, today);
      }),
      firstDay: DateTime(2023, 1, 1),
      lastDay: DateTime(2023, 12, 31),
      daysOfWeekHeight: 50,
      locale: 'Ko-KR',
      headerStyle: HeaderStyle(
          titleTextStyle: TextStyle(
              fontFamily: 'NotoSerif', color: Colors.grey[600], fontSize: 14.0),
          formatButtonVisible: false,
          titleCentered: false,
          leftChevronVisible: false,
          rightChevronVisible: false),
      calendarStyle: CalendarStyle(
          selectedDecoration: BoxDecoration(
              color: Color.fromARGB(255, 138, 138, 138),
              shape: BoxShape.circle),
          todayTextStyle:
              TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          todayDecoration: BoxDecoration(
              color: Color.fromARGB(255, 179, 179, 179),
              shape: BoxShape.circle),
          outsideDaysVisible: false,
          defaultTextStyle:
              TextStyle(color: Colors.grey[600], fontFamily: 'Lora'),
          weekendTextStyle:
              TextStyle(color: Colors.grey[600], fontFamily: 'Lora')),
      calendarBuilders: CalendarBuilders(
        dowBuilder: (context, day) {
          switch (day.weekday) {
            case 1:
              return Center(
                child: Text(
                  "월",
                  style: TextStyle(
                      fontFamily: 'NotoSerif', color: Colors.grey[500]),
                ),
              );
            case 2:
              return Center(
                child: Text(
                  "화",
                  style: TextStyle(
                      fontFamily: 'NotoSerif', color: Colors.grey[500]),
                ),
              );
            case 3:
              return Center(
                child: Text(
                  "수",
                  style: TextStyle(
                      fontFamily: 'NotoSerif', color: Colors.grey[500]),
                ),
              );
            case 4:
              return Center(
                child: Text(
                  "목",
                  style: TextStyle(
                      fontFamily: 'NotoSerif', color: Colors.grey[500]),
                ),
              );
            case 5:
              return Center(
                child: Text(
                  "금",
                  style: TextStyle(
                      fontFamily: 'NotoSerif', color: Colors.grey[500]),
                ),
              );
            case 6:
              return Center(
                child: Text(
                  "토",
                  style: TextStyle(
                      color: Color.fromARGB(255, 124, 138, 148),
                      fontFamily: 'NotoSerif'),
                ),
              );
            case 7:
              return Center(
                child: Text(
                  "일",
                  style: TextStyle(
                      color: Color.fromARGB(255, 189, 146, 146),
                      fontFamily: 'NotoSerif'),
                ),
              );
          }
        },
      ),
    );
  }
}
