import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../base/base.dart';
import '../../blocs/blocs.dart';
import '../../models/models.dart';
import '../../resources/resources.dart';
import '../../router/router.dart';
import '../../widgets/widgets.dart';

class ProjectPage extends StatefulWidget {
  final ProjectBloc bloc;
  const ProjectPage({Key? key, required this.bloc}) : super(key: key);

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends BaseState<ProjectPage, ProjectBloc> {
  bool isInit = false;
  late Project project;

  TextEditingController taskNameController = TextEditingController();
  TextEditingController boardNameController = TextEditingController();
  TextEditingController projectNameController = TextEditingController();
  TextEditingController projectDescriptionController = TextEditingController();

  final _taskNameFormKey = GlobalKey<FormState>();
  final _boardNameFormKey = GlobalKey<FormState>();
  final _projectFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    taskNameController.dispose();
    boardNameController.dispose();
    projectNameController.dispose();
    projectDescriptionController.dispose();
    super.dispose();
  }

  void init() {
    if (isInit == false) {
      final projectTemp = ModalRoute.of(context)!.settings.arguments as Project;
      setState(() {
        project = projectTemp;
        isInit = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    init();
    return StreamBuilder<Project>(
        stream: bloc.getProjectStream(project.id ?? ""),
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: AppColors.mediumPersianBlue,
              title: Text(
                snapshot.data?.name ?? "",
                style: Theme.of(context).textTheme.headline4?.copyWith(color: AppColors.primaryWhite),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
                      ),
                      backgroundColor: AppColors.primaryWhite,
                      builder: (context) {
                        return _boardInformationBottomSheet(snapshot.data);
                      },
                    );
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
            body: StreamBuilder<List<BoardModel>>(
                stream: bloc.getListBoardOrderByIndexStream(project.id ?? ""),
                builder: (context, boardSnapshot) {
                  if (boardSnapshot.hasData) {
                    return Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.all(8),
                            scrollDirection: Axis.horizontal,
                            itemCount: boardSnapshot.data!.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                decoration: const BoxDecoration(
                                  color: AppColors.neutral95,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            boardSnapshot.data![index].name ?? "",
                                            style: Theme.of(context).textTheme.headline4,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        PopupMenuButton<int>(
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              value: 1,
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(VectorImageAssets.ic_add),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    "Create task",
                                                    style: Theme.of(context).textTheme.headline5,
                                                  )
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              value: 2,
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(VectorImageAssets.ic_edit),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    "Board name",
                                                    style: Theme.of(context).textTheme.headline5,
                                                  )
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              value: 3,
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(VectorImageAssets.ic_delete, color: AppColors.red60,),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    "Delete board",
                                                    style: Theme.of(context).textTheme.headline5?.copyWith(color: AppColors.red60),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                          offset: const Offset(-20, 40),
                                          color: AppColors.primaryWhite,
                                          elevation: 2,
                                          onSelected: (value) {
                                            if (value == 1) {
                                              taskNameController.clear();
                                              showTaskNameDialog(boardId: boardSnapshot.data![index].id ?? "", index: boardSnapshot.data!.length);
                                            } else if (value == 2) {
                                              boardNameController.text = boardSnapshot.data![index].name ?? "";
                                              showUpdateBoardNameDialog(boardId: boardSnapshot.data![index].id ?? "");
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: StreamBuilder<List<TaskModel>>(
                                            stream: bloc.getListTaskOrderByIndexStream(boardSnapshot.data![index].id ?? ""),
                                            builder: (context, listTaskSnapshot) {
                                              if (listTaskSnapshot.hasData && listTaskSnapshot.data!.isNotEmpty) {
                                                return Column(
                                                  children: List.generate(
                                                      listTaskSnapshot.data!.length,
                                                      (indexListTask) => SizedBox(
                                                            width: MediaQuery.of(context).size.width,
                                                            child: InkWellWrapper(
                                                              onTap: () => Navigator.pushNamed(context, Routes.task,
                                                                  arguments: listTaskSnapshot.data![indexListTask]),
                                                              margin: const EdgeInsets.only(bottom: 16),
                                                              //paddingChild: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                                              color: AppColors.primaryWhite,
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    width: 8,
                                                                    height: () {
                                                                      if (listTaskSnapshot.data![indexListTask].to != null &&
                                                                          listTaskSnapshot.data![indexListTask].from != null) {
                                                                        return 90.0;
                                                                      } else {
                                                                        return 60.0;
                                                                      }
                                                                    }(),
                                                                    color: () {
                                                                      if (listTaskSnapshot.data![indexListTask].completed == true) {
                                                                        return AppColors.green60;
                                                                      } else {
                                                                        if (listTaskSnapshot.data![indexListTask].to != null &&
                                                                            listTaskSnapshot.data![indexListTask].to!.compareTo(DateTime.now()) < 0) {
                                                                          return AppColors.red60;
                                                                        } else {
                                                                          return AppColors.mediumPersianBlue;
                                                                        }
                                                                      }
                                                                    }(),
                                                                  ),
                                                                  const SizedBox(width: 16),
                                                                  Column(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Text(
                                                                        listTaskSnapshot.data![indexListTask].name ?? "",
                                                                        style: Theme.of(context).textTheme.headline4,
                                                                        maxLines: 1,
                                                                        overflow: TextOverflow.ellipsis,
                                                                      ),
                                                                      Visibility(
                                                                        visible: listTaskSnapshot.data![indexListTask].to != null &&
                                                                            listTaskSnapshot.data![indexListTask].from != null,
                                                                        child: Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            const SizedBox(height: 8),
                                                                            Text(
                                                                              "From: ${listTaskSnapshot.data![indexListTask].from?.day.toString().padLeft(2, '0')}/${listTaskSnapshot.data![indexListTask].from?.month.toString().padLeft(2, '0')}/${listTaskSnapshot.data![indexListTask].from?.year} - ${listTaskSnapshot.data![indexListTask].from?.hour.toString().padLeft(2, '0')}:${listTaskSnapshot.data![indexListTask].from?.minute.toString().padLeft(2, '0')}",
                                                                              style: Theme.of(context).textTheme.headline5?.copyWith(fontSize: 14),
                                                                            ),
                                                                            const SizedBox(height: 8),
                                                                            Text(
                                                                              "To: ${listTaskSnapshot.data![indexListTask].to?.day.toString().padLeft(2, '0')}/${listTaskSnapshot.data![indexListTask].to?.month.toString().padLeft(2, '0')}/${listTaskSnapshot.data![indexListTask].to?.year} - ${listTaskSnapshot.data![indexListTask].to?.hour.toString().padLeft(2, '0')}:${listTaskSnapshot.data![indexListTask].to?.minute.toString().padLeft(2, '0')}",
                                                                              style: Theme.of(context).textTheme.headline5?.copyWith(fontSize: 14),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          )),
                                                );
                                              } else {
                                                return Container();
                                              }
                                            }),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (BuildContext context, int index) {
                              return const SizedBox(width: 8);
                            },
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Container();
                  }
                }),
          );
        });
  }

  Widget _boardInformationBottomSheet(Project? project) {
    return StreamBuilder<Project>(
        stream: bloc.getProjectStream(project?.id ?? ""),
        builder: (context, snapshot) {
          return Container(
            height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      InkWellWrapper(
                        margin: const EdgeInsets.only(left: 16),
                        onTap: () => Navigator.pop(context),
                        child: SvgPicture.asset(
                          VectorImageAssets.ic_close,
                          height: 24,
                          width: 24,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Center(
                        child: Text(
                          "About project",
                          style: Theme.of(context).textTheme.headline5?.copyWith(fontSize: 20),
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    height: 8,
                    width: double.infinity,
                    color: AppColors.neutral99,
                  ),
                  InkWellWrapper(
                    onTap: () {
                      projectNameController.text = snapshot.data?.name ?? "";
                      showUpdateProjectNameDialog(projectId: project?.id ?? "");
                    },
                    paddingChild: const EdgeInsets.all(16),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name",
                          style: Theme.of(context).textTheme.headline4?.copyWith(
                                color: AppColors.neutral10,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          snapshot.data?.name ?? "",
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 8,
                    width: double.infinity,
                    color: AppColors.neutral99,
                  ),
                  InkWellWrapper(
                    onTap: () {
                      projectDescriptionController.text = snapshot.data?.description ?? "";
                      showUpdateProjectDescriptionDialog(projectId: project?.id ?? "");
                    },
                    paddingChild: const EdgeInsets.all(16),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Description",
                          style: Theme.of(context).textTheme.headline4?.copyWith(
                                color: AppColors.neutral10,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          (snapshot.data?.description == null || snapshot.data!.description == "") ? "..." : snapshot.data?.description ?? "...",
                          style: Theme.of(context).textTheme.headline5?.copyWith(height: 1.3),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 8,
                    width: double.infinity,
                    color: AppColors.neutral99,
                  ),
                  InkWellWrapper(
                    onTap: () {},
                    paddingChild: const EdgeInsets.all(16),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Picture",
                          style: Theme.of(context).textTheme.headline4?.copyWith(
                                color: AppColors.neutral10,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Image.network(
                          snapshot.data?.image ?? "",
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, event) {
                            if (event == null) return child;
                            return const LoadingContainer(height: 74, width: 74);
                          },
                          errorBuilder: (context, object, stacktrace) {
                            return AvatarWithName(
                              name: snapshot.data?.name ?? "?",
                              fontSize: 24,
                              shapeSize: 100,
                              boxShape: BoxShape.rectangle,
                              count: 2,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 8,
                    width: double.infinity,
                    color: AppColors.neutral99,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Members",
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                            color: AppColors.neutral10,
                          ),
                    ),
                  ),
                  StreamBuilder<List<ProjectParticipant>>(
                      stream: bloc.getListProjectParticipantByProjectIdStream(project?.id ?? ""),
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
                                                const SizedBox(width: 8),
                                                Text(
                                                  snapshot.data?[index].role ?? "",
                                                  style: Theme.of(context).textTheme.headline6,
                                                )
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
                  InkWellWrapper(
                    onTap: () {},
                    margin: const EdgeInsets.all(16),
                    paddingChild: const EdgeInsets.symmetric(vertical: 12),
                    color: AppColors.mediumPersianBlue,
                    borderRadius: BorderRadius.circular(4),
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Text(
                        "Add new member",
                        style: Theme.of(context).textTheme.button,
                      ),
                    ),
                  ),
                  Container(
                    height: 8,
                    width: double.infinity,
                    color: AppColors.neutral99,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 16),
                    child: Text(
                      "Others",
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                            color: AppColors.neutral10,
                          ),
                    ),
                  ),
                  InkWellWrapper(
                    paddingChild: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    onTap: () {},
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          VectorImageAssets.ic_logout,
                          height: 24,
                          width: 24,
                          color: AppColors.primaryBlack,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text(
                            "Leave project",
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        )
                      ],
                    ),
                  ),
                  InkWellWrapper(
                    paddingChild: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    border: const Border(top: BorderSide(color: AppColors.neutral99)),
                    onTap: () {},
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
                  ),
                ],
              ),
            ),
          );
        });
  }

  void showTaskNameDialog({required String boardId, required int index}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(16),
            title: Text(
              "Task name",
              style: Theme.of(context).textTheme.headline3,
            ),
            content: Form(
              key: _taskNameFormKey,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: CustomTextField(
                  textFieldType: TextFieldType.name,
                  textFieldConfig: TextFieldConfig(
                    controller: taskNameController,
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(color: AppColors.neutral10),
                    cursorColor: AppColors.primaryBlack,
                  ),
                  decorationConfig: TextFieldDecorationConfig(
                    hintText: "Enter task name",
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
                  'Create',
                  style: Theme.of(context).textTheme.button?.copyWith(color: AppColors.mediumPersianBlue),
                ),
                onPressed: () {
                  primaryFocus?.unfocus();
                  if (_taskNameFormKey.currentState?.validate() == true) {
                    primaryFocus?.unfocus();
                    bloc.createTask(name: taskNameController.text.trim(), boardId: boardId, projectId: project.id ?? "", index: index);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          );
        });
  }

  void showUpdateBoardNameDialog({required String boardId}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(16),
            title: Text(
              "Board name",
              style: Theme.of(context).textTheme.headline3,
            ),
            content: Form(
              key: _boardNameFormKey,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: CustomTextField(
                  textFieldType: TextFieldType.name,
                  textFieldConfig: TextFieldConfig(
                    controller: boardNameController,
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(color: AppColors.neutral10),
                    cursorColor: AppColors.primaryBlack,
                  ),
                  decorationConfig: TextFieldDecorationConfig(
                    hintText: "Enter board name",
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
                  if (_boardNameFormKey.currentState?.validate() == true) {
                    primaryFocus?.unfocus();
                    bloc.updateBoardName(id: boardId, name: boardNameController.text.trim());
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          );
        });
  }

  void showUpdateProjectNameDialog({required String projectId}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(16),
            title: Text(
              "Project name",
              style: Theme.of(context).textTheme.headline3,
            ),
            content: Form(
              key: _projectFormKey,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: CustomTextField(
                  textFieldType: TextFieldType.name,
                  textFieldConfig: TextFieldConfig(
                    controller: projectNameController,
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(color: AppColors.neutral10),
                    cursorColor: AppColors.primaryBlack,
                  ),
                  decorationConfig: TextFieldDecorationConfig(
                    hintText: "Enter project name",
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
                  if (_projectFormKey.currentState?.validate() == true) {
                    primaryFocus?.unfocus();
                    bloc.updateProjectName(projectId: projectId, name: projectNameController.text.trim());
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          );
        });
  }

  void showUpdateProjectDescriptionDialog({required String projectId}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(16),
            title: Text(
              "Project description",
              style: Theme.of(context).textTheme.headline3,
            ),
            content: Form(
              key: _projectFormKey,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: CustomTextField(
                  textFieldType: TextFieldType.text,
                  textFieldConfig: TextFieldConfig(
                    controller: projectDescriptionController,
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(color: AppColors.neutral10),
                    cursorColor: AppColors.primaryBlack,
                  ),
                  decorationConfig: TextFieldDecorationConfig(
                    hintText: "Enter project description",
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
                  if (_projectFormKey.currentState?.validate() == true) {
                    primaryFocus?.unfocus();
                    bloc.updateProjectDescription(projectId: projectId, description: projectDescriptionController.text.trim());
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          );
        });
  }

  @override
  ProjectBloc get bloc => widget.bloc;
}
