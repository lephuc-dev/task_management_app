import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../models/models.dart';
import '../../base/base.dart';
import '../../blocs/blocs.dart';
import '../../resources/resources.dart';

class TaskPage extends StatefulWidget {
  final TaskBloc bloc;
  const TaskPage({Key? key, required this.bloc}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends BaseState<TaskPage, TaskBloc> {
  bool isInit = false;
  late TaskModel taskModel;

  void init() {
    if (isInit == false) {
      final taskModelTemp = ModalRoute.of(context)!.settings.arguments as TaskModel;
      setState(() {
        taskModel = taskModelTemp;
        isInit = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    init();
    return StreamBuilder<TaskModel>(
      stream: bloc.getTaskStream(taskModel.id ?? ""),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColors.mediumPersianBlue,
            title: Text(
              "About task",
              style: Theme.of(context).textTheme.headline4?.copyWith(color: AppColors.primaryWhite),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            actions: [
              IconButton(
                onPressed: () {
                },
                icon: SvgPicture.asset(
                  VectorImageAssets.ic_more,
                  height: 24,
                  width: 24,
                  fit: BoxFit.cover,
                  color: AppColors.primaryWhite,
                ),
              )
            ],
          ),
        );
      }
    );
  }

  @override
  TaskBloc get bloc => widget.bloc;
}
