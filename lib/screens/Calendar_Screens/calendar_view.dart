
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../models/reservation.dart';
import '../../models/resident.dart';


class CalenderScreen extends StatelessWidget {

  CalenderScreen({Key? key}) : super(key: key);

  final CalendarController _controller = CalendarController();

  @override
  Widget build(BuildContext context) {

    final reservations = Provider.of<List<Reservation>>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //add drop down menu
        backgroundColor: Colors.blueAccent,
        title: const Text('Calendar',
          style: TextStyle(
              color: Colors.white
          ),
        ),
      ),
      body: SfCalendar(
        view: CalendarView.week,
        allowedViews: [
          CalendarView.day,
          CalendarView.week,
          CalendarView.workWeek,
          CalendarView.month,
          CalendarView.timelineDay,
          CalendarView.timelineWeek,
          CalendarView.timelineWorkWeek
        ],
        dataSource: MeetingDataSource(getAppointments(reservations)),
        controller: _controller,
        onTap: calendarTapped,
        monthViewSettings: MonthViewSettings(
            navigationDirection: MonthNavigationDirection.vertical),
      ),
    );

  }

  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    if (_controller.view == CalendarView.month && calendarTapDetails.targetElement == CalendarElement.calendarCell) {
      _controller.view = CalendarView.day;
    }
    else if ((_controller.view == CalendarView.week || _controller.view == CalendarView.workWeek) && calendarTapDetails.targetElement == CalendarElement.viewHeader) {
      _controller.view = CalendarView.day;
    }
  }
}

Color hexToColor(String code) {
  print(code);
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

List<Appointment> getAppointments(List<Reservation> reservations){
  List<Appointment> meetings = <Appointment>[];

  reservations.forEach((res) {
    meetings.add(
      Appointment(
        startTime: res.start,
        endTime: res.end,
        subject: '${res.resource} by ${res.username}',
        color: hexToColor(res.color)
      )
    );
  });

  return meetings;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source){
    appointments = source;
  }
}
