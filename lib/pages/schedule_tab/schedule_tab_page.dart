import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../base/base.dart';
import '../../blocs/blocs.dart';
import '../../models/task_model.dart';
import '../../resources/resources.dart';

class ScheduleTabPage extends StatefulWidget {
  final ScheduleTabBloc bloc;
  const ScheduleTabPage({Key? key, required this.bloc}) : super(key: key);

  @override
  State<ScheduleTabPage> createState() => _ScheduleTabPageState();
}

class _ScheduleTabPageState extends BaseState<ScheduleTabPage, ScheduleTabBloc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Schedule",
          style: Theme.of(context).textTheme.headline5?.copyWith(fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryWhite,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: AppColors.primaryBlack),
      ),
      body: SfCalendar(
        view: CalendarView.month,
        todayHighlightColor: AppColors.mediumPersianBlue,
        monthViewSettings: const MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
          showAgenda: true,
        ), 
      ),
    );
  }

  @override
  ScheduleTabBloc get bloc => widget.bloc;
}
