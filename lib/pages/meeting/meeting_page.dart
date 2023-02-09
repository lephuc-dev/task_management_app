import 'package:flutter/material.dart';
import 'package:task_management_app/base/base.dart';
import 'package:task_management_app/blocs/blocs.dart';

class MeetingPage extends StatefulWidget {
  final MeetingBloc bloc;
  const MeetingPage({Key? key, required this.bloc}) : super(key: key);

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends BaseState<MeetingPage, MeetingBloc> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  @override
  MeetingBloc get bloc => widget.bloc;
}
