import 'package:flutter/material.dart';
import 'package:task_management_app/models/invitation_model.dart';
import 'package:task_management_app/models/models.dart';
import '../../base/base.dart';
import '../../blocs/blocs.dart';
import '../../resources/resources.dart';
import '../../widgets/widgets.dart';

class NotificationTabPage extends StatefulWidget {
  final NotificationTabBloc bloc;
  const NotificationTabPage({Key? key, required this.bloc}) : super(key: key);

  @override
  State<NotificationTabPage> createState() => _NotificationTabPageState();
}

class _NotificationTabPageState extends BaseState<NotificationTabPage, NotificationTabBloc> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.primaryWhite,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(
            "Notification",
            style: Theme.of(context).textTheme.headline5?.copyWith(fontSize: 20),
          ),
          centerTitle: true,
          backgroundColor: AppColors.primaryWhite,
          elevation: 0.5,
          iconTheme: const IconThemeData(color: AppColors.primaryBlack),
          bottom: TabBar(
            labelStyle: Theme.of(context).textTheme.headline5,
            unselectedLabelStyle: Theme.of(context).textTheme.headline5,
            unselectedLabelColor: AppColors.primaryBlack,
            labelColor: AppColors.mediumPersianBlue,
            indicatorColor: AppColors.mediumPersianBlue,
            tabs: const [
              Tab(
                text: "About project",
              ),
              Tab(
                text: "Invitation",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            aboutProjectWidget(),
            invitationWidget(),
          ],
        ),
      ),
    );
  }

  Widget aboutProjectWidget() {
    return StreamBuilder<List<NotificationModel>>(
      stream: bloc.getListNotificationByMyId(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isNotEmpty) {
            return Container();
          } else {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "No notification",
                    style: Theme.of(context).textTheme.headline1?.copyWith(
                      color: AppColors.neutral60,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    "You don't have any notification!",
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
      }
    );
  }

  Widget invitationWidget() {
    return StreamBuilder<List<InvitationModel>>(
        stream: bloc.getListInvitationByMyId(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "No invitation",
                      style: Theme.of(context).textTheme.headline1?.copyWith(
                            color: AppColors.neutral60,
                            fontSize: 18,
                          ),
                    ),
                    Text(
                      "You don't have any invitation!",
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            fontWeight: FontWeight.w400,
                            color: AppColors.neutral60,
                          ),
                    ),
                  ],
                ),
              );
            } else {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    snapshot.data!.length,
                    (index) => Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.neutral99, width: 8))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StreamBuilder<Project>(
                              stream: bloc.getProjectStream(snapshot.data![index].projectId ?? ""),
                              builder: (context, projectSnapshot) {
                                return Row(
                                  children: [
                                    if (projectSnapshot.data != null && projectSnapshot.data!.image != "")
                                      Image.network(
                                        projectSnapshot.data!.image!,
                                        height: 40,
                                        width: 40,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, event) {
                                          if (event == null) return child;
                                          return const LoadingContainer(height: 40, width: 40);
                                        },
                                      )
                                    else
                                      AvatarWithName(
                                        name: projectSnapshot.data?.name ?? "",
                                        shapeSize: 40,
                                        fontSize: 16,
                                        boxShape: BoxShape.rectangle,
                                        count: 1,
                                      ),
                                    const SizedBox(width: 16),
                                    Text(
                                      projectSnapshot.data?.name ?? "",
                                      style: Theme.of(context).textTheme.headline5,
                                    ),
                                  ],
                                );
                              }),
                          const SizedBox(height: 12),
                          StreamBuilder<User>(
                              stream: bloc.getInformationUserByIdStream(snapshot.data![index].userId ?? ""),
                              builder: (context, userSnapshot) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Inviter: ",
                                      style: Theme.of(context).textTheme.headline6,
                                    ),
                                    Text(
                                      userSnapshot.data?.name ?? "Unknown",
                                      style: Theme.of(context).textTheme.headline5?.copyWith(color: AppColors.neutral60),
                                    ),
                                  ],
                                );
                              }),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Time: ",
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              Text(
                                "${snapshot.data![index].time?.day.toString().padLeft(2, '0')}/${snapshot.data![index].time?.month.toString().padLeft(2, '0')}/${snapshot.data![index].time?.year}  ${snapshot.data![index].time?.hour.toString().padLeft(2, '0')}:${snapshot.data![index].time?.minute.toString().padLeft(2, '0')}",
                                style: Theme.of(context).textTheme.headline5?.copyWith(color: AppColors.neutral60),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Role: ",
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              Text(
                                snapshot.data![index].role ?? "Unknown",
                                style: Theme.of(context).textTheme.headline5?.copyWith(color: AppColors.neutral60),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: InkWellWrapper(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(
                                              "Reject",
                                              style: Theme.of(context).textTheme.headline3,
                                            ),
                                            content: SizedBox(
                                              width: MediaQuery.of(context).size.width,
                                              child: Text(
                                                "Are you sure to reject to join this project?",
                                                style: Theme.of(context).textTheme.bodyText2?.copyWith(color: AppColors.neutral10),
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                child: Text(
                                                  'Cancel',
                                                  style: Theme.of(context).textTheme.button?.copyWith(color: AppColors.primaryBlack),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: Text(
                                                  'Reject',
                                                  style: Theme.of(context).textTheme.button?.copyWith(color: AppColors.mediumPersianBlue),
                                                ),
                                                onPressed: () {
                                                  bloc.rejectInvitation(invitationId: snapshot.data![index].id ?? "");
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  color: AppColors.neutral95,
                                  paddingChild: const EdgeInsets.all(12),
                                  borderRadius: BorderRadius.circular(4),
                                  child: Center(
                                    child: Text(
                                      "Reject",
                                      style: Theme.of(context).textTheme.button?.copyWith(color: AppColors.primaryBlack),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: InkWellWrapper(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(
                                              "Accept",
                                              style: Theme.of(context).textTheme.headline3,
                                            ),
                                            content: SizedBox(
                                              width: MediaQuery.of(context).size.width,
                                              child: Text(
                                                "Are you sure to accept to join this project?",
                                                style: Theme.of(context).textTheme.bodyText2?.copyWith(color: AppColors.neutral10),
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                child: Text(
                                                  'Cancel',
                                                  style: Theme.of(context).textTheme.button?.copyWith(color: AppColors.primaryBlack),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: Text(
                                                  'Accept',
                                                  style: Theme.of(context).textTheme.button?.copyWith(color: AppColors.mediumPersianBlue),
                                                ),
                                                onPressed: () {
                                                  bloc.acceptInvitation(invitationModel: snapshot.data![index]);
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  color: AppColors.mediumPersianBlue,
                                  paddingChild: const EdgeInsets.all(12),
                                  borderRadius: BorderRadius.circular(4),
                                  child: Center(
                                    child: Text(
                                      "Accept",
                                      style: Theme.of(context).textTheme.button,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          } else {
            return Container();
          }
        });
  }

  @override
  NotificationTabBloc get bloc => widget.bloc;
}
