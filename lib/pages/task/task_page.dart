import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:link_preview_generator/link_preview_generator.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import '../../models/models.dart';
import '../../base/base.dart';
import '../../blocs/blocs.dart';
import '../../resources/resources.dart';
import '../../widgets/widgets.dart';

class TaskPage extends StatefulWidget {
  final TaskBloc bloc;
  const TaskPage({Key? key, required this.bloc}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends BaseState<TaskPage, TaskBloc> {
  bool isInit = false;
  bool isEnableCommentButton = false;
  late TaskModel taskModel;

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController checkListItemContentController = TextEditingController();
  TextEditingController linkTitleController = TextEditingController();
  TextEditingController linkUrlController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  final _nameFormKey = GlobalKey<FormState>();
  final _descriptionFormKey = GlobalKey<FormState>();
  final _checkListItemFormKey = GlobalKey<FormState>();
  final _linkFormKey = GlobalKey<FormState>();

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
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    checkListItemContentController.dispose();
    linkTitleController.dispose();
    linkUrlController.dispose();
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    init();
    return UnFocusedWidget(
      child: StreamBuilder<TaskModel>(
          stream: bloc.getTaskStream(taskModel.id ?? ""),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return StreamBuilder<String>(
                  stream: bloc.getRole(projectId: taskModel.projectId ?? ""),
                  builder: (context, roleSnapshot) {
                    if (roleSnapshot.hasData) {
                      return Scaffold(
                        backgroundColor: AppColors.primaryWhite,
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
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return InkWellWrapper(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text(
                                                    "Delete",
                                                    style: Theme.of(context).textTheme.headline3,
                                                  ),
                                                  content: SizedBox(
                                                    width: MediaQuery.of(context).size.width,
                                                    child: Text(
                                                      "Are you sure to delete this task?",
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
                                                        'Delete',
                                                        style: Theme.of(context).textTheme.button?.copyWith(color: AppColors.mediumPersianBlue),
                                                      ),
                                                      onPressed: () {
                                                        bloc.deleteTaskAndListParticipant(taskId: taskModel.id ?? "");
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                        paddingChild: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              VectorImageAssets.ic_delete,
                                              height: 24,
                                              width: 24,
                                              color: AppColors.red70,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 16.0),
                                              child: Text(
                                                "Delete project",
                                                style: Theme.of(context).textTheme.headline5?.copyWith(color: AppColors.red70),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    });
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
                        body: Stack(
                          children: [
                            SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// Title
                                  InkWellWrapper(
                                    onTap: roleSnapshot.data != "Viewer"
                                        ? () {
                                            nameController.text = snapshot.data?.name?.trim() ?? "";
                                            showNameDialog();
                                          }
                                        : null,
                                    paddingChild: const EdgeInsets.all(16),
                                    width: MediaQuery.of(context).size.width,
                                    color: AppColors.mediumPersianBlue,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              snapshot.data?.name ?? "",
                                              style: Theme.of(context).textTheme.headline4?.copyWith(
                                                    color: AppColors.primaryWhite,
                                                    fontSize: 20,
                                                    //eight: 1.4,
                                                  ),
                                            ),
                                            Visibility(
                                              visible: roleSnapshot.data != "Viewer",
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 8.0),
                                                child: SvgPicture.asset(
                                                  VectorImageAssets.ic_edit,
                                                  height: 20,
                                                  width: 20,
                                                  fit: BoxFit.cover,
                                                  color: AppColors.primaryWhite,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  /// Description
                                  InkWellWrapper(
                                    onTap: roleSnapshot.data != "Viewer"
                                        ? () {
                                            descriptionController.text = snapshot.data?.description?.trim() ?? "";
                                            showDescriptionDialog();
                                          }
                                        : null,
                                    paddingChild: const EdgeInsets.all(16),
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Description",
                                              style: Theme.of(context).textTheme.headline4?.copyWith(
                                                    color: AppColors.neutral10,
                                                  ),
                                            ),
                                            Visibility(
                                              visible: roleSnapshot.data != "Viewer",
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 8.0),
                                                child: SvgPicture.asset(
                                                  VectorImageAssets.ic_edit,
                                                  height: 20,
                                                  width: 20,
                                                  fit: BoxFit.cover,
                                                  color: AppColors.primaryBlack,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Visibility(
                                          visible: snapshot.data?.description != null && snapshot.data!.description != "",
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 12),
                                              Text(
                                                snapshot.data?.description ?? "...",
                                                style: Theme.of(context).textTheme.headline5?.copyWith(height: 1.3),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  ///Completed
                                  Container(
                                    height: 8,
                                    width: double.infinity,
                                    color: AppColors.neutral99,
                                  ),
                                  InkWellWrapper(
                                    paddingChild: const EdgeInsets.symmetric(vertical: 8),
                                    onTap: roleSnapshot.data != "Viewer"
                                        ? () {
                                            bloc.updateCompletedState(taskId: taskModel.id ?? "", value: !(snapshot.data?.completed ?? false));
                                          }
                                        : null,
                                    child: Row(
                                      children: [
                                        Checkbox(
                                          value: snapshot.data?.completed ?? false,
                                          checkColor: AppColors.primaryWhite,
                                          activeColor: AppColors.green50,
                                          onChanged: roleSnapshot.data != "Viewer"
                                              ? (value) {
                                                  bloc.updateCompletedState(taskId: taskModel.id ?? "", value: !(snapshot.data?.completed ?? false));
                                                }
                                              : null,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            "Completed",
                                            style: Theme.of(context).textTheme.headline5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  /// Assigns
                                  Container(
                                    height: 8,
                                    width: double.infinity,
                                    color: AppColors.neutral99,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Members",
                                          style: Theme.of(context).textTheme.headline4?.copyWith(
                                                color: AppColors.neutral10,
                                              ),
                                        ),
                                        Visibility(
                                          visible: roleSnapshot.data != "Viewer",
                                          child: InkWellWrapper(
                                            paddingChild: const EdgeInsets.all(4),
                                            onTap: () {
                                              showMemberDialog();
                                            },
                                            child: SvgPicture.asset(
                                              VectorImageAssets.ic_add,
                                              height: 24,
                                              width: 24,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  StreamBuilder<List<TaskParticipant>>(
                                      stream: bloc.getListTaskParticipantByTaskIdStream(snapshot.data?.id ?? ""),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                                          return Column(
                                            children: List.generate(
                                                snapshot.data?.length ?? 0,
                                                (index) => StreamBuilder<User>(
                                                      stream: bloc.getInformationUserByIdStream(snapshot.data![index].userId ?? ""),
                                                      builder: (context, userSnapshot) {
                                                        if (userSnapshot.hasData) {
                                                          return Container(
                                                            padding: const EdgeInsets.only(left: 16, right: 16),
                                                            margin: const EdgeInsets.only(bottom: 16),
                                                            child: Row(
                                                              children: [
                                                                ClipOval(
                                                                  child: Image.network(
                                                                    userSnapshot.data?.avatar ?? "",
                                                                    height: 45,
                                                                    width: 45,
                                                                    fit: BoxFit.cover,
                                                                    loadingBuilder: (context, child, event) {
                                                                      if (event == null) return child;
                                                                      return const LoadingContainer(height: 45, width: 45);
                                                                    },
                                                                    errorBuilder: (context, object, stacktrace) {
                                                                      return AvatarWithName(
                                                                        name: userSnapshot.data?.name ?? "?",
                                                                        fontSize: 12,
                                                                        shapeSize: 45,
                                                                        count: 2,
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                                const SizedBox(width: 16),
                                                                Expanded(
                                                                  child: Text(
                                                                    userSnapshot.data?.name ?? "",
                                                                    style: Theme.of(context).textTheme.headline5,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        } else {
                                                          return Container();
                                                        }
                                                      },
                                                    )),
                                          );
                                        } else {
                                          return Container();
                                        }
                                      }),

                                  /// Time
                                  Container(
                                    height: 8,
                                    width: double.infinity,
                                    color: AppColors.neutral99,
                                  ),
                                  InkWellWrapper(
                                    onTap: roleSnapshot.data != "Viewer"
                                        ? () async {
                                            List<DateTime>? dateTimeList = await showOmniDateTimeRangePicker(
                                              context: context,
                                              type: OmniDateTimePickerType.dateAndTime,
                                              primaryColor: AppColors.mediumPersianBlue,
                                              backgroundColor: AppColors.primaryWhite,
                                              calendarTextColor: AppColors.primaryBlack,
                                              tabTextColor: AppColors.primaryBlack,
                                              unselectedTabBackgroundColor: AppColors.neutral95,
                                              buttonTextColor: AppColors.primaryBlack,
                                              timeSpinnerTextStyle: const TextStyle(color: AppColors.primaryBlack, fontSize: 18),
                                              timeSpinnerHighlightedTextStyle: const TextStyle(color: AppColors.primaryBlack, fontSize: 24),
                                              is24HourMode: false,
                                              isShowSeconds: false,
                                              startInitialDate: snapshot.data!.from,
                                              startFirstDate: DateTime(1600).subtract(const Duration(days: 3652)),
                                              startLastDate: DateTime.now().add(const Duration(days: 3652)),
                                              endInitialDate: snapshot.data!.to,
                                              endFirstDate: DateTime(1600).subtract(const Duration(days: 3652)),
                                              endLastDate: DateTime.now().add(const Duration(days: 3652)),
                                              borderRadius: const Radius.circular(16),
                                            );
                                            if (dateTimeList != null) {
                                              if (dateTimeList[0].compareTo(dateTimeList[1]) < 0) {
                                                bloc.updateFromAndToTime(
                                                  taskId: taskModel.id ?? "",
                                                  from: dateTimeList[0],
                                                  to: dateTimeList[1],
                                                );
                                              } else {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                        "Error",
                                                        style: Theme.of(context).textTheme.headline3,
                                                      ),
                                                      content: Text(
                                                        "The start time must be before the end time",
                                                        style: Theme.of(context).textTheme.bodyText2,
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () => Navigator.pop(context),
                                                          child: Text(
                                                            "Close",
                                                            style: Theme.of(context).textTheme.button?.copyWith(color: AppColors.primaryBlack),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                            }
                                          }
                                        : null,
                                    paddingChild: const EdgeInsets.all(16),
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Time",
                                              style: Theme.of(context).textTheme.headline4?.copyWith(
                                                    color: AppColors.neutral10,
                                                  ),
                                            ),
                                            Visibility(
                                              visible: roleSnapshot.data != "Viewer",
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 8.0),
                                                child: SvgPicture.asset(
                                                  VectorImageAssets.ic_edit,
                                                  height: 20,
                                                  width: 20,
                                                  fit: BoxFit.cover,
                                                  color: AppColors.primaryBlack,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Visibility(
                                          visible: snapshot.data!.from != null && snapshot.data!.to != null,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 12),
                                              Text(
                                                () {
                                                  if (snapshot.data!.from != null) {
                                                    return "From:   ${snapshot.data!.from!.day.toString().padLeft(2, '0')}/${snapshot.data!.from!.month.toString().padLeft(2, '0')}/${snapshot.data!.from!.year}  ${snapshot.data!.from!.hour.toString().padLeft(2, '0')}:${snapshot.data!.from!.minute.toString().padLeft(2, '0')}";
                                                  } else {
                                                    return "...";
                                                  }
                                                }(),
                                                style: Theme.of(context).textTheme.headline5?.copyWith(height: 1.3),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.symmetric(vertical: 12),
                                                height: 1,
                                                width: double.infinity,
                                                color: AppColors.neutral99,
                                              ),
                                              Text(
                                                () {
                                                  if (snapshot.data!.to != null) {
                                                    return "To:        ${snapshot.data!.to!.day.toString().padLeft(2, '0')}/${snapshot.data!.to!.month.toString().padLeft(2, '0')}/${snapshot.data!.to!.year}  ${snapshot.data!.to!.hour.toString().padLeft(2, '0')}:${snapshot.data!.to!.minute.toString().padLeft(2, '0')}";
                                                  } else {
                                                    return "...";
                                                  }
                                                }(),
                                                style: Theme.of(context).textTheme.headline5?.copyWith(height: 1.3),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  /// Check list
                                  Container(
                                    height: 8,
                                    width: double.infinity,
                                    color: AppColors.neutral99,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Check list",
                                          style: Theme.of(context).textTheme.headline4?.copyWith(
                                                color: AppColors.neutral10,
                                              ),
                                        ),
                                        Visibility(
                                          visible: roleSnapshot.data != "Viewer",
                                          child: InkWellWrapper(
                                            paddingChild: const EdgeInsets.all(4),
                                            onTap: roleSnapshot.data != "Viewer"
                                                ? () {
                                                    bloc.addCheckListItem(taskId: snapshot.data?.id ?? "", checklist: snapshot.data?.checklist);
                                                  }
                                                : null,
                                            child: SvgPicture.asset(
                                              VectorImageAssets.ic_add,
                                              height: 24,
                                              width: 24,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  ...List.generate(
                                    snapshot.data?.checklist?.length ?? 0,
                                    (index) => Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Slidable(
                                        endActionPane: roleSnapshot.data != "Viewer"
                                            ? ActionPane(
                                                motion: const ScrollMotion(),
                                                children: [
                                                  SlidableAction(
                                                    onPressed: (context) {
                                                      checkListItemContentController.text = snapshot.data?.checklist?[index].content ?? "";
                                                      showCheckListItemContentDialog(index: index, checklist: snapshot.data?.checklist);
                                                    },
                                                    backgroundColor: AppColors.yellow60,
                                                    foregroundColor: Colors.white,
                                                    icon: Icons.edit,
                                                  ),
                                                  SlidableAction(
                                                    onPressed: (context) => bloc.deleteCheckListItem(
                                                      taskId: snapshot.data?.id ?? "",
                                                      checklist: snapshot.data?.checklist,
                                                      index: index,
                                                    ),
                                                    backgroundColor: AppColors.red60,
                                                    foregroundColor: Colors.white,
                                                    icon: Icons.delete,
                                                  ),
                                                ],
                                              )
                                            : null,
                                        child: InkWellWrapper(
                                          onTap: roleSnapshot.data != "Viewer"
                                              ? () {
                                                  bloc.setDoneTaskState(
                                                    taskId: snapshot.data?.id ?? "",
                                                    checklist: snapshot.data?.checklist,
                                                    index: index,
                                                    isDone: !(snapshot.data?.checklist?[index].isDone ?? false),
                                                  );
                                                }
                                              : null,
                                          child: Row(
                                            children: [
                                              Checkbox(
                                                value: snapshot.data?.checklist?[index].isDone ?? false,
                                                checkColor: AppColors.primaryWhite,
                                                activeColor: AppColors.green50,
                                                onChanged: roleSnapshot.data != "Viewer"
                                                    ? (value) {
                                                        bloc.setDoneTaskState(
                                                          taskId: snapshot.data?.id ?? "",
                                                          checklist: snapshot.data?.checklist,
                                                          index: index,
                                                          isDone: !(snapshot.data?.checklist?[index].isDone ?? false),
                                                        );
                                                      }
                                                    : null,
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  snapshot.data?.checklist?[index].content ?? "",
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  /// Links
                                  Container(
                                    height: 8,
                                    width: double.infinity,
                                    color: AppColors.neutral99,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Links",
                                          style: Theme.of(context).textTheme.headline4?.copyWith(
                                                color: AppColors.neutral10,
                                              ),
                                        ),
                                        Visibility(
                                          visible: roleSnapshot.data != "Viewer",
                                          child: InkWellWrapper(
                                            paddingChild: const EdgeInsets.all(4),
                                            onTap: roleSnapshot.data != "Viewer"
                                                ? () {
                                                    linkTitleController.text = "New title";
                                                    linkUrlController.text = "http://";
                                                    showAddLinkDialog(list: snapshot.data?.links);
                                                  }
                                                : null,
                                            child: SvgPicture.asset(
                                              VectorImageAssets.ic_add,
                                              height: 24,
                                              width: 24,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  ...List.generate(
                                    snapshot.data?.links?.length ?? 0,
                                    (index) => Padding(
                                      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.data?.links?[index].title ?? "Unknown",
                                            style: Theme.of(context).textTheme.headline5?.copyWith(height: 1.3),
                                          ),
                                          const SizedBox(height: 8),
                                          Slidable(
                                            endActionPane: roleSnapshot.data != "Viewer"
                                                ? ActionPane(
                                                    motion: const ScrollMotion(),
                                                    children: [
                                                      SlidableAction(
                                                        onPressed: (context) {
                                                          linkTitleController.text = snapshot.data?.links?[index].title ?? "";
                                                          linkUrlController.text = snapshot.data?.links?[index].url ?? "";
                                                          showLinkDialog(index: index, list: snapshot.data?.links);
                                                        },
                                                        backgroundColor: AppColors.yellow60,
                                                        foregroundColor: Colors.white,
                                                        icon: Icons.edit,
                                                      ),
                                                      SlidableAction(
                                                        onPressed: (context) {
                                                          bloc.deleteLinkListItem(
                                                            taskId: snapshot.data?.id ?? "",
                                                            list: snapshot.data?.links,
                                                            index: index,
                                                          );
                                                        },
                                                        backgroundColor: AppColors.red60,
                                                        foregroundColor: Colors.white,
                                                        icon: Icons.delete,
                                                      ),
                                                    ],
                                                  )
                                                : null,
                                            child: SizedBox(
                                              height: 100,
                                              child: LinkPreviewGenerator(
                                                link: snapshot.data?.links?[index].url ?? "",
                                                linkPreviewStyle: LinkPreviewStyle.small,
                                                removeElevation: true,
                                                borderRadius: 4,
                                                showBody: false,
                                                placeholderWidget: LoadingContainer(
                                                  width: MediaQuery.of(context).size.width,
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                errorWidget: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(4),
                                                    color: const Color.fromRGBO(248, 248, 248, 1),
                                                  ),
                                                  width: MediaQuery.of(context).size.width,
                                                  child: Center(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        SvgPicture.asset(
                                                          VectorImageAssets.ic_warning,
                                                          height: 24,
                                                          width: 24,
                                                          fit: BoxFit.cover,
                                                        ),
                                                        const SizedBox(width: 8),
                                                        Text(
                                                          "Link error",
                                                          style: Theme.of(context).textTheme.headline5,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // child: AnyLinkPreview(
                                            //   link: snapshot.data?.links?[index].url ?? "",
                                            //   displayDirection: UIDirection.uiDirectionHorizontal,
                                            //   showMultimedia: true,
                                            //   bodyMaxLines: 2,
                                            //   bodyTextOverflow: TextOverflow.ellipsis,
                                            //   borderRadius: 4,
                                            //   removeElevation: true,
                                            //   previewHeight: 100,
                                            //   placeholderWidget: LoadingContainer(
                                            //     height: 100,
                                            //     width: MediaQuery.of(context).size.width,
                                            //     borderRadius: BorderRadius.circular(4),
                                            //   ),
                                            //   errorWidget: Container(
                                            //     decoration: BoxDecoration(
                                            //       borderRadius: BorderRadius.circular(4),
                                            //       color: const Color.fromRGBO(235, 235, 235, 1),
                                            //     ),
                                            //     height: 100,
                                            //     width: MediaQuery.of(context).size.width,
                                            //     child: Center(
                                            //       child: Text(
                                            //         'Link isn\'t loaded...',
                                            //         style: Theme.of(context).textTheme.headline5,
                                            //       ),
                                            //     ),
                                            //   ),
                                            // ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  /// Comments
                                  Container(
                                    height: 8,
                                    width: double.infinity,
                                    color: AppColors.neutral99,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                                    child: Text(
                                      "Comments",
                                      style: Theme.of(context).textTheme.headline4?.copyWith(
                                            color: AppColors.neutral10,
                                          ),
                                    ),
                                  ),
                                  StreamBuilder<List<CommentModel>>(
                                      stream: bloc.getListCommentByTaskId(taskModel.id ?? ""),
                                      builder: (context, commentSnapshot) {
                                        if (snapshot.hasData) {
                                          return Column(
                                            children: List.generate(
                                              commentSnapshot.data?.length ?? 0,
                                              (index) => StreamBuilder<User>(
                                                  stream: bloc.getInformationUserByIdStream(commentSnapshot.data![index].userId ?? ""),
                                                  builder: (context, userSnapshot) {
                                                    return Slidable(
                                                      endActionPane: (roleSnapshot.data == "Owner" ||
                                                              (roleSnapshot.data == "Editor" && commentSnapshot.data![index].userId == bloc.getUid()))
                                                          ? ActionPane(
                                                              motion: const ScrollMotion(),
                                                              children: [
                                                                SlidableAction(
                                                                  onPressed: (context) {
                                                                    bloc.deleteComment(commentId: commentSnapshot.data![index].id ?? "");
                                                                  },
                                                                  backgroundColor: AppColors.red60,
                                                                  foregroundColor: Colors.white,
                                                                  icon: Icons.delete,
                                                                ),
                                                              ],
                                                            )
                                                          : null,
                                                      child: Container(
                                                        padding: const EdgeInsets.only(bottom: 16, top: 16),
                                                        margin: const EdgeInsets.only(left: 16, right: 16),
                                                        decoration: const BoxDecoration(
                                                            border: Border(bottom: BorderSide(width: 1, color: AppColors.neutral99))),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                ClipOval(
                                                                  child: Image.network(
                                                                    userSnapshot.data?.avatar ?? "",
                                                                    height: 45,
                                                                    width: 45,
                                                                    fit: BoxFit.cover,
                                                                    loadingBuilder: (context, child, event) {
                                                                      if (event == null) return child;
                                                                      return const LoadingContainer(height: 45, width: 45);
                                                                    },
                                                                    errorBuilder: (context, object, stacktrace) {
                                                                      return AvatarWithName(
                                                                        name: userSnapshot.data?.name ?? "?",
                                                                        fontSize: 12,
                                                                        shapeSize: 45,
                                                                        count: 2,
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                                const SizedBox(width: 20),
                                                                Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      userSnapshot.data?.name ?? "",
                                                                      style: Theme.of(context).textTheme.headline5,
                                                                    ),
                                                                    const SizedBox(height: 4),
                                                                    Text(
                                                                      commentSnapshot.data?[index].date ?? "",
                                                                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                                                                            fontSize: 12,
                                                                            color: AppColors.neutral60,
                                                                            fontWeight: FontWeight.w400,
                                                                          ),
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                            const SizedBox(height: 8),
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 65),
                                                              child: Text(
                                                                commentSnapshot.data?[index].content ?? "",
                                                                style: Theme.of(context).textTheme.headline5?.copyWith(
                                                                      color: AppColors.neutral30,
                                                                      height: 1.3,
                                                                    ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                            ),
                                          );
                                        } else {
                                          return Container();
                                        }
                                      }),

                                  /// Container bottom
                                  const SizedBox(height: 100),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: roleSnapshot.data != "Viewer",
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  color: AppColors.neutral99,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: CustomTextField(
                                          textFieldType: TextFieldType.text,
                                          textFieldConfig: TextFieldConfig(
                                            controller: commentController,
                                            style: Theme.of(context).textTheme.bodyText2?.copyWith(color: AppColors.neutral10),
                                            cursorColor: AppColors.primaryBlack,
                                          ),
                                          decorationConfig: TextFieldDecorationConfig(
                                            hintText: "Comment here",
                                            hintStyle: Theme.of(context).textTheme.bodyText2?.copyWith(color: AppColors.neutral60),
                                            errorStyle: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                ?.copyWith(fontWeight: FontWeight.w300, fontSize: 13, color: AppColors.red60),
                                            enabledBorder: const UnderlineInputBorder(
                                              borderSide: BorderSide(color: AppColors.neutral95, width: 1),
                                            ),
                                            focusedBorder: const UnderlineInputBorder(
                                              borderSide: BorderSide(color: AppColors.mediumPersianBlue, width: 1),
                                            ),
                                            errorBorder: const UnderlineInputBorder(
                                              borderSide: BorderSide(color: AppColors.red60, width: 1),
                                            ),
                                            focusedErrorBorder: const UnderlineInputBorder(
                                              borderSide: BorderSide(color: AppColors.red60, width: 1),
                                            ),
                                          ),
                                          onChanged: (value) {
                                            if (value == "") {
                                              setState(() {
                                                isEnableCommentButton = false;
                                              });
                                            } else {
                                              setState(() {
                                                isEnableCommentButton = true;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      InkWellWrapper(
                                        onTap: isEnableCommentButton
                                            ? () {
                                                primaryFocus?.unfocus();
                                                bloc.createComment(taskId: taskModel.id ?? "", content: commentController.text.trim());
                                                commentController.clear();
                                                setState(() {
                                                  isEnableCommentButton = false;
                                                });
                                              }
                                            : null,
                                        borderRadius: BorderRadius.circular(4),
                                        paddingChild: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        color: isEnableCommentButton ? AppColors.mediumPersianBlue : AppColors.neutral50,
                                        child: SvgPicture.asset(
                                          VectorImageAssets.ic_arrow_right,
                                          height: 24,
                                          width: 24,
                                          color: AppColors.primaryWhite,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Container();
                    }
                  });
            } else {
              return Container(
                color: AppColors.primaryWhite,
              );
            }
          }),
    );
  }

  void showNameDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(16),
            title: Text(
              "Name",
              style: Theme.of(context).textTheme.headline3,
            ),
            content: Form(
              key: _nameFormKey,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: CustomTextField(
                  textFieldType: TextFieldType.name,
                  textFieldConfig: TextFieldConfig(
                    controller: nameController,
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(color: AppColors.neutral10),
                    cursorColor: AppColors.primaryBlack,
                  ),
                  decorationConfig: TextFieldDecorationConfig(
                    hintText: "Enter name",
                    hintStyle: Theme.of(context).textTheme.bodyText2?.copyWith(color: AppColors.neutral60),
                    errorStyle: Theme.of(context).textTheme.bodyText2?.copyWith(fontWeight: FontWeight.w300, fontSize: 13, color: AppColors.red60),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.neutral95, width: 1),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.mediumPersianBlue, width: 1),
                    ),
                    errorBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.red60, width: 1),
                    ),
                    focusedErrorBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.red60, width: 1),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value == "") {
                      return "Don't leave this information blank";
                    }
                    return null;
                  },
                ),
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
                  'Update',
                  style: Theme.of(context).textTheme.button?.copyWith(color: AppColors.mediumPersianBlue),
                ),
                onPressed: () {
                  primaryFocus?.unfocus();
                  if (_nameFormKey.currentState?.validate() == true) {
                    if (taskModel.id != null) {
                      bloc.updateName(taskModel.id!, nameController.text.trim());
                      Navigator.pop(context);
                    }
                  }
                },
              ),
            ],
          );
        });
  }

  void showDescriptionDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(16),
            title: Text(
              "Description",
              style: Theme.of(context).textTheme.headline3,
            ),
            content: Form(
              key: _descriptionFormKey,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: CustomTextField(
                  textFieldType: TextFieldType.text,
                  textFieldConfig: TextFieldConfig(
                    controller: descriptionController,
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(color: AppColors.neutral10),
                    cursorColor: AppColors.primaryBlack,
                  ),
                  decorationConfig: TextFieldDecorationConfig(
                    hintText: "Enter description",
                    hintStyle: Theme.of(context).textTheme.bodyText2?.copyWith(color: AppColors.neutral60),
                    errorStyle: Theme.of(context).textTheme.bodyText2?.copyWith(fontWeight: FontWeight.w300, fontSize: 13, color: AppColors.red60),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.neutral95, width: 1),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.mediumPersianBlue, width: 1),
                    ),
                    errorBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.red60, width: 1),
                    ),
                    focusedErrorBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.red60, width: 1),
                    ),
                  ),
                ),
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
                  'Update',
                  style: Theme.of(context).textTheme.button?.copyWith(color: AppColors.mediumPersianBlue),
                ),
                onPressed: () {
                  primaryFocus?.unfocus();
                  if (_descriptionFormKey.currentState?.validate() == true) {
                    if (taskModel.id != null) {
                      bloc.updateDescription(taskModel.id!, descriptionController.text.trim());
                      Navigator.pop(context);
                    }
                  }
                },
              ),
            ],
          );
        });
  }

  void showMemberDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(16),
            title: Text(
              "Members",
              style: Theme.of(context).textTheme.headline3,
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder<List<ProjectParticipant>>(
                  stream: bloc.getListProjectParticipantByProjectIdStream(taskModel.projectId ?? ""),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          snapshot.data?.length ?? 0,
                          (index) => StreamBuilder<User>(
                            stream: bloc.getInformationUserByIdStream(snapshot.data![index].userId ?? ""),
                            builder: (context, userSnapshot) {
                              if (userSnapshot.hasData) {
                                return StreamBuilder<List<TaskParticipant>>(
                                    stream: bloc.getListTaskParticipantByTaskIdStream(taskModel.id ?? ""),
                                    builder: (context, taskParticipantSnapshot) {
                                      bool isCheck = false;
                                      int index = -1;
                                      for (int i = 0; i < (taskParticipantSnapshot.data?.length ?? 0); i++) {
                                        if (taskParticipantSnapshot.data?[i].userId == userSnapshot.data!.uid) {
                                          isCheck = true;
                                          index = i;
                                        }
                                      }
                                      return InkWellWrapper(
                                        margin: const EdgeInsets.only(bottom: 16),
                                        onTap: () {
                                          if (isCheck == true) {
                                            bloc.deleteTaskParticipant(
                                                participantId: taskParticipantSnapshot.data?[index].id ?? "",
                                                taskId: taskParticipantSnapshot.data?[index].taskId ?? "");
                                          } else {
                                            bloc.createTaskParticipant(userId: userSnapshot.data!.uid ?? "", taskId: taskModel.id ?? "");
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            ClipOval(
                                              child: Image.network(
                                                userSnapshot.data?.avatar ?? "",
                                                height: 45,
                                                width: 45,
                                                fit: BoxFit.cover,
                                                loadingBuilder: (context, child, event) {
                                                  if (event == null) return child;
                                                  return const LoadingContainer(height: 45, width: 45);
                                                },
                                                errorBuilder: (context, object, stacktrace) {
                                                  return AvatarWithName(
                                                    name: userSnapshot.data?.name ?? "?",
                                                    fontSize: 12,
                                                    shapeSize: 45,
                                                    count: 2,
                                                  );
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Text(
                                                userSnapshot.data?.name ?? "",
                                                style: Theme.of(context).textTheme.headline5,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Visibility(
                                              visible: isCheck,
                                              child: Text(
                                                "assign",
                                                style: Theme.of(context).textTheme.headline4?.copyWith(
                                                      color: AppColors.green50,
                                                      fontSize: 13,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                              } else {
                                return Container();
                              }
                            },
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
            ),
            // actions: [
            //   TextButton(
            //     child: Text(
            //       'Close',
            //       style: Theme.of(context).textTheme.button?.copyWith(color: AppColors.primaryBlack),
            //     ),
            //     onPressed: () {
            //       Navigator.of(context).pop();
            //     },
            //   ),
            // ],
          );
        });
  }

  void showCheckListItemContentDialog({required int index, required List<CheckListItemModel>? checklist}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(16),
            title: Text(
              "Checklist item content",
              style: Theme.of(context).textTheme.headline3,
            ),
            content: Form(
              key: _checkListItemFormKey,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: CustomTextField(
                  textFieldType: TextFieldType.name,
                  textFieldConfig: TextFieldConfig(
                    controller: checkListItemContentController,
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(color: AppColors.neutral10),
                    cursorColor: AppColors.primaryBlack,
                  ),
                  decorationConfig: TextFieldDecorationConfig(
                    hintText: "Enter checklist item content",
                    hintStyle: Theme.of(context).textTheme.bodyText2?.copyWith(color: AppColors.neutral60),
                    errorStyle: Theme.of(context).textTheme.bodyText2?.copyWith(fontWeight: FontWeight.w300, fontSize: 13, color: AppColors.red60),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.neutral95, width: 1),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.mediumPersianBlue, width: 1),
                    ),
                    errorBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.red60, width: 1),
                    ),
                    focusedErrorBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.red60, width: 1),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value == "") {
                      return "Don't leave this information blank";
                    }
                    return null;
                  },
                ),
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
                  'Update',
                  style: Theme.of(context).textTheme.button?.copyWith(color: AppColors.mediumPersianBlue),
                ),
                onPressed: () {
                  primaryFocus?.unfocus();
                  if (_checkListItemFormKey.currentState?.validate() == true) {
                    if (taskModel.id != null) {
                      bloc.updateCheckListItemContent(
                        taskId: taskModel.id ?? "",
                        checklist: checklist,
                        index: index,
                        content: checkListItemContentController.text.trim(),
                      );
                      Navigator.pop(context);
                    }
                  }
                },
              ),
            ],
          );
        });
  }

  void showLinkDialog({required int index, required List<LinkModel>? list}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(16),
            title: Text(
              "Link title",
              style: Theme.of(context).textTheme.headline3,
            ),
            content: Form(
              key: _linkFormKey,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: CustomTextField(
                  textFieldType: TextFieldType.text,
                  textFieldConfig: TextFieldConfig(
                    controller: linkTitleController,
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(color: AppColors.neutral10),
                    cursorColor: AppColors.primaryBlack,
                  ),
                  decorationConfig: TextFieldDecorationConfig(
                    hintText: "Enter link title",
                    hintStyle: Theme.of(context).textTheme.bodyText2?.copyWith(color: AppColors.neutral60),
                    errorStyle: Theme.of(context).textTheme.bodyText2?.copyWith(fontWeight: FontWeight.w300, fontSize: 13, color: AppColors.red60),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.neutral95, width: 1),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.mediumPersianBlue, width: 1),
                    ),
                    errorBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.red60, width: 1),
                    ),
                    focusedErrorBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.red60, width: 1),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value == "") {
                      return "Don't leave this information blank";
                    }
                    return null;
                  },
                ),
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
                  'Update',
                  style: Theme.of(context).textTheme.button?.copyWith(color: AppColors.mediumPersianBlue),
                ),
                onPressed: () {
                  primaryFocus?.unfocus();
                  if (_linkFormKey.currentState?.validate() == true) {
                    if (taskModel.id != null) {
                      bloc.updateLinkListItem(
                        taskId: taskModel.id ?? "",
                        list: list,
                        index: index,
                        title: linkTitleController.text.trim(),
                        url: linkUrlController.text.trim(),
                      );
                      Navigator.pop(context);
                      setState(() {});
                    }
                  }
                },
              ),
            ],
          );
        });
  }

  void showAddLinkDialog({required List<LinkModel>? list}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(16),
            title: Text(
              "Link",
              style: Theme.of(context).textTheme.headline3,
            ),
            content: Form(
              key: _linkFormKey,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomTextField(
                      textFieldType: TextFieldType.text,
                      textFieldConfig: TextFieldConfig(
                        controller: linkTitleController,
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(color: AppColors.neutral10),
                        cursorColor: AppColors.primaryBlack,
                      ),
                      decorationConfig: TextFieldDecorationConfig(
                        hintText: "Enter link title",
                        hintStyle: Theme.of(context).textTheme.bodyText2?.copyWith(color: AppColors.neutral60),
                        errorStyle:
                            Theme.of(context).textTheme.bodyText2?.copyWith(fontWeight: FontWeight.w300, fontSize: 13, color: AppColors.red60),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.neutral95, width: 1),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.mediumPersianBlue, width: 1),
                        ),
                        errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.red60, width: 1),
                        ),
                        focusedErrorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.red60, width: 1),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value == "") {
                          return "Don't leave this information blank";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      textFieldType: TextFieldType.text,
                      textFieldConfig: TextFieldConfig(
                        controller: linkUrlController,
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(color: AppColors.neutral10),
                        cursorColor: AppColors.primaryBlack,
                      ),
                      decorationConfig: TextFieldDecorationConfig(
                        hintText: "Enter link urk",
                        hintStyle: Theme.of(context).textTheme.bodyText2?.copyWith(color: AppColors.neutral60),
                        errorStyle:
                            Theme.of(context).textTheme.bodyText2?.copyWith(fontWeight: FontWeight.w300, fontSize: 13, color: AppColors.red60),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.neutral95, width: 1),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.mediumPersianBlue, width: 1),
                        ),
                        errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.red60, width: 1),
                        ),
                        focusedErrorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.red60, width: 1),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value == "") {
                          return "Don't leave this information blank";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
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
                  'Create',
                  style: Theme.of(context).textTheme.button?.copyWith(color: AppColors.mediumPersianBlue),
                ),
                onPressed: () {
                  primaryFocus?.unfocus();
                  if (_linkFormKey.currentState?.validate() == true) {
                    if (taskModel.id != null) {
                      bloc.addLinkListItem(
                        taskId: taskModel.id ?? "",
                        list: list,
                        title: linkTitleController.text.trim(),
                        url: linkUrlController.text.trim(),
                      );
                      Navigator.pop(context);
                      setState(() {});
                    }
                  }
                },
              ),
            ],
          );
        });
  }

  @override
  TaskBloc get bloc => widget.bloc;
}
