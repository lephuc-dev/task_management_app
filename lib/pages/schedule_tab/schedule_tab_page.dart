import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:task_management_app/models/models.dart';
import 'package:task_management_app/widgets/inkwell_wrapper.dart';
import '../../base/base.dart';
import '../../blocs/blocs.dart';
import '../../resources/resources.dart';
import '../../router/router.dart';
import '../../widgets/calendar_timeline/src/calendar_timeline.dart';

class ScheduleTabPage extends StatefulWidget {
  final ScheduleTabBloc bloc;
  const ScheduleTabPage({Key? key, required this.bloc}) : super(key: key);

  @override
  State<ScheduleTabPage> createState() => _ScheduleTabPageState();
}

class _ScheduleTabPageState extends BaseState<ScheduleTabPage, ScheduleTabBloc> {
  late DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
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
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            CalendarTimeline(
              showYears: false,
              initialDate: _selectedDate,
              firstDate: DateTime(DateTime.now().year - 4),
              lastDate: DateTime.now().add(const Duration(days: 365 * 4)),
              onDateSelected: (date) => setState(() => _selectedDate = date),
              leftMargin: 16,
              monthColor: AppColors.primaryBlack,
              dayColor: AppColors.primaryBlack,
              dayNameColor: AppColors.primaryBlack,
              activeDayColor: Colors.white,
              activeBackgroundDayColor: AppColors.mediumPersianBlue,
              dotsColor: AppColors.primaryWhite,
              locale: 'en',
              shrink: false,
            ),
            const SizedBox(height: 32),
            Expanded(
              child: SingleChildScrollView(
                child: StreamBuilder<List<TaskParticipant>>(
                    stream: bloc.getListTaskParticipantByMyIdStream(),
                    builder: (context, taskParticipantSnapshot) {
                      if (taskParticipantSnapshot.hasData) {
                        if (taskParticipantSnapshot.data!.isNotEmpty) {
                          return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            taskParticipantSnapshot.data!.length,
                            (index) => StreamBuilder<TaskModel>(
                                stream: bloc.getTaskStream(taskParticipantSnapshot.data![index].taskId ?? ""),
                                builder: (context, taskSnapshot) {
                                  if (taskSnapshot.hasData) {
                                    return Visibility(
                                      visible: taskSnapshot.data!.from != null &&
                                          taskSnapshot.data!.to != null &&
                                          (compareDate(taskSnapshot.data!.from!, _selectedDate) < 0 ||
                                              compareDate(taskSnapshot.data!.from!, _selectedDate) == 0) &&
                                          (compareDate(taskSnapshot.data!.to!, _selectedDate) > 0 ||
                                              compareDate(taskSnapshot.data!.to!, _selectedDate) == 0),
                                      child: InkWellWrapper(
                                        onTap: () {
                                          Navigator.pushNamed(context, Routes.task, arguments: taskSnapshot.data!);
                                        },
                                        // paddingChild: const EdgeInsets.symmetric(horizontal: 16),
                                        margin: const EdgeInsets.only(bottom: 32, left: 16, right: 16),
                                        width: MediaQuery.of(context).size.width,
                                        color: AppColors.neutral99,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 8,
                                              height: 90,
                                              color: (){
                                                if (taskSnapshot.data!.completed == true) {
                                                  return AppColors.green60;
                                                } else {
                                                  if (taskSnapshot.data!.to != null && taskSnapshot.data!.to!.compareTo(DateTime.now()) < 0) {
                                                    return AppColors.red60;
                                                  } else {
                                                    return AppColors.mediumPersianBlue;
                                                  }
                                                }
                                              }(),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    taskSnapshot.data!.name ?? "",
                                                    style: Theme.of(context).textTheme.headline4,
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    "From: ${taskSnapshot.data!.from?.day.toString().padLeft(2, '0')}/${taskSnapshot.data!.from?.month.toString().padLeft(2, '0')}/${taskSnapshot.data!.from?.year} - ${taskSnapshot.data!.from?.hour.toString().padLeft(2, '0')}:${taskSnapshot.data!.from?.minute.toString().padLeft(2, '0')}",
                                                    style: Theme.of(context).textTheme.headline5?.copyWith(fontSize: 14),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    "To: ${taskSnapshot.data!.to?.day.toString().padLeft(2, '0')}/${taskSnapshot.data!.to?.month.toString().padLeft(2, '0')}/${taskSnapshot.data!.to?.year} - ${taskSnapshot.data!.to?.hour.toString().padLeft(2, '0')}:${taskSnapshot.data!.to?.minute.toString().padLeft(2, '0')}",
                                                    style: Theme.of(context).textTheme.headline5?.copyWith(fontSize: 14),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                }),
                          ),
                        );
                        } else {
                          return Center(
                            child: Column(
                              children: [
                                SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                                Text(
                                  "No task",
                                  style: Theme.of(context).textTheme.headline1?.copyWith(
                                    color: AppColors.neutral60,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  "Let join task and complete",
                                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.neutral60,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      } else {
                        return Container();
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: compareDate(_selectedDate, DateTime.now()) != 0 ? FloatingActionButton(
        backgroundColor: AppColors.green60,
        child: const Icon(Icons.replay),
        onPressed: () {
          setState(() {
            _selectedDate = DateTime.now();
          });
        },
      ) : null,
    );
  }

  int compareDate(DateTime dateTime1, DateTime dateTime2) {
    if (dateTime1.year < dateTime2.year) {
      return -1;
    } else if (dateTime1.year > dateTime2.year) {
      return 1;
    } else {
      if (dateTime1.month < dateTime2.month) {
        return -1;
      } else if (dateTime1.month > dateTime2.month) {
        return 1;
      } else {
        if (dateTime1.day < dateTime2.day) {
          return -1;
        } else if (dateTime1.day > dateTime2.day) {
          return 1;
        } else {
          return 0;
        }
      }
    }
  }

  @override
  ScheduleTabBloc get bloc => widget.bloc;
}
