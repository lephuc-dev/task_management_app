import 'package:flutter/material.dart';
import '../../base/base.dart';
import '../../blocs/blocs.dart';
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
    );
  }

  @override
  ScheduleTabBloc get bloc => widget.bloc;
}
