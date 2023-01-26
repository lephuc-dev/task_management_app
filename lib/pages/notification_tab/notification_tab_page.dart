import 'package:flutter/material.dart';
import '../../base/base.dart';
import '../../blocs/blocs.dart';
import '../../resources/resources.dart';

class NotificationTabPage extends StatefulWidget {
  final NotificationTabBloc bloc;
  const NotificationTabPage({Key? key, required this.bloc}) : super(key: key);

  @override
  State<NotificationTabPage> createState() => _NotificationTabPageState();
}

class _NotificationTabPageState extends BaseState<NotificationTabPage, NotificationTabBloc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Notification",
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
  NotificationTabBloc get bloc => widget.bloc;
}
