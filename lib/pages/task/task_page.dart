import 'package:flutter/material.dart';
import 'package:task_management_app/base/base.dart';
import 'package:task_management_app/blocs/blocs.dart';

class TaskPage extends StatefulWidget {
  final TaskBloc bloc;
  const TaskPage({Key? key, required this.bloc}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends BaseState<TaskPage, TaskBloc> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  @override
  TaskBloc get bloc => widget.bloc;
}
