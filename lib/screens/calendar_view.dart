
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';


class CalenderScreen extends StatelessWidget {

  const CalenderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: const Text('Calendar',
            style: TextStyle(
                color: Colors.white
            ),
          )
      ),
      body: SfCalendar(
        view: CalendarView.month,
      ),
    );
  }
}

/*
class CalendarView extends StatefulWidget {
  const CalendarView({Key? key}) : super(key: key);

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: const Text('Settings',
            style: TextStyle(
                color: Colors.white
            ),
          )
      ),
      body: SfCalendar(
        monthViewSettings: const MonthViewSettings(showAgenda: true),
        view: CalendarView.month,
      ),
    );
  }
}
*/
