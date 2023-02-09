import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
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

  String choice = "Viewer";

  TextEditingController taskNameController = TextEditingController();
  TextEditingController boardNameController = TextEditingController();
  TextEditingController projectNameController = TextEditingController();
  TextEditingController projectDescriptionController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final _taskNameFormKey = GlobalKey<FormState>();
  final _boardNameFormKey = GlobalKey<FormState>();
  final _projectFormKey = GlobalKey<FormState>();
  final _emailFormKey = GlobalKey<FormState>();

  bool isLoadingImage = false;

  @override
  void dispose() {
    taskNameController.dispose();
    boardNameController.dispose();
    projectNameController.dispose();
    projectDescriptionController.dispose();
    emailController.dispose();
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

  List<List<TaskModel>> list = [];

  @override
  void initState() {
    super.initState();
    List.generate(20, (index) => list.add([]));
  }

  @override
  Widget build(BuildContext context) {
    init();
    return StreamBuilder<Project>(
        stream: bloc.getProjectStream(project.id ?? ""),
        builder: (context, snapshot) {
          return StreamBuilder<String>(
              stream: bloc.getRole(projectId: project.id ?? ""),
              builder: (context, roleSnapshot) {
                if (roleSnapshot.hasData) {
                  return StreamBuilder<List<BoardModel>>(
                      stream: bloc.getListBoardOrderByIndexStream(project.id ?? ""),
                      builder: (context, boardSnapshot) {
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
                          floatingActionButton: roleSnapshot.data != "Viewer"
                              ? FloatingActionButton(
                                  onPressed: () {
                                    boardNameController.clear();
                                    showAddBoardDialog(projectId: project.id ?? "", index: boardSnapshot.data?.length ?? 0);
                                  },
                                  backgroundColor: AppColors.green60,
                                  child: SvgPicture.asset(
                                    VectorImageAssets.ic_add,
                                    height: 24,
                                    width: 24,
                                    color: AppColors.primaryWhite,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : null,
                          body: boardSnapshot.hasData
                              ? SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  child: ListView.separated(
                                    padding: const EdgeInsets.all(8),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: boardSnapshot.data!.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        width: MediaQuery.of(context).size.width * 0.7,
                                        padding: roleSnapshot.data != "Viewer"
                                            ? const EdgeInsets.only(bottom: 8, top: 4)
                                            : const EdgeInsets.symmetric(vertical: 8),
                                        decoration: const BoxDecoration(
                                          color: AppColors.neutral95,
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 8.0),
                                                    child: Text(
                                                      boardSnapshot.data![index].name ?? "",
                                                      style: Theme.of(context).textTheme.headline4,
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: roleSnapshot.data != "Viewer",
                                                  child: PopupMenuButton(
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
                                                            SvgPicture.asset(
                                                              VectorImageAssets.ic_delete,
                                                              color: AppColors.red60,
                                                            ),
                                                            const SizedBox(width: 10),
                                                            Text(
                                                              "Delete board",
                                                              style: Theme.of(context).textTheme.headline5?.copyWith(color: AppColors.red60),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                    padding: const EdgeInsets.all(0),
                                                    offset: const Offset(-20, 40),
                                                    color: AppColors.primaryWhite,
                                                    elevation: 2,
                                                    onSelected: (value) {
                                                      if (value == 1) {
                                                        taskNameController.clear();
                                                        showTaskNameDialog(
                                                            boardId: boardSnapshot.data![index].id ?? "", index: boardSnapshot.data!.length);
                                                      } else if (value == 2) {
                                                        boardNameController.text = boardSnapshot.data![index].name ?? "";
                                                        showUpdateBoardNameDialog(boardId: boardSnapshot.data![index].id ?? "", projectId: boardSnapshot.data![index].projectId ?? "");
                                                      } else if (value == 3) {
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
                                                                  "Are you sure to delete this board?",
                                                                  style: Theme.of(context).textTheme.bodyText2?.copyWith(color: AppColors.neutral10),
                                                                ),
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                  child: Text(
                                                                    'Cancel',
                                                                    style:
                                                                        Theme.of(context).textTheme.button?.copyWith(color: AppColors.primaryBlack),
                                                                  ),
                                                                  onPressed: () {
                                                                    Navigator.of(context).pop();
                                                                  },
                                                                ),
                                                                TextButton(
                                                                  child: Text(
                                                                    'Delete',
                                                                    style: Theme.of(context)
                                                                        .textTheme
                                                                        .button
                                                                        ?.copyWith(color: AppColors.mediumPersianBlue),
                                                                  ),
                                                                  onPressed: () {
                                                                    bloc.deleteBoardAndListTask(boardId: boardSnapshot.data![index].id ?? "");
                                                                    Navigator.of(context).pop();
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 12),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                                                                                  return 50.0;
                                                                                }
                                                                              }(),
                                                                              color: () {
                                                                                if (listTaskSnapshot.data![indexListTask].completed == true) {
                                                                                  return AppColors.green60;
                                                                                } else {
                                                                                  if (listTaskSnapshot.data![indexListTask].to != null &&
                                                                                      listTaskSnapshot.data![indexListTask].to!
                                                                                              .compareTo(DateTime.now()) <
                                                                                          0) {
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
                                                                                        style: Theme.of(context)
                                                                                            .textTheme
                                                                                            .headline5
                                                                                            ?.copyWith(fontSize: 14),
                                                                                      ),
                                                                                      const SizedBox(height: 8),
                                                                                      Text(
                                                                                        "To: ${listTaskSnapshot.data![indexListTask].to?.day.toString().padLeft(2, '0')}/${listTaskSnapshot.data![indexListTask].to?.month.toString().padLeft(2, '0')}/${listTaskSnapshot.data![indexListTask].to?.year} - ${listTaskSnapshot.data![indexListTask].to?.hour.toString().padLeft(2, '0')}:${listTaskSnapshot.data![indexListTask].to?.minute.toString().padLeft(2, '0')}",
                                                                                        style: Theme.of(context)
                                                                                            .textTheme
                                                                                            .headline5
                                                                                            ?.copyWith(fontSize: 14),
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
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    separatorBuilder: (BuildContext context, int index) {
                                      return const SizedBox(width: 8);
                                    },
                                  ),
                                )
                              : Container(),
                        );
                      });
                } else {
                  return Container();
                }
              });
        });
  }

  Widget _boardInformationBottomSheet(Project? project) {
    return StreamBuilder<Project>(
        stream: bloc.getProjectStream(project?.id ?? ""),
        builder: (context, snapshot) {
          return StreamBuilder<String>(
              stream: bloc.getRole(projectId: project?.id ?? ""),
              builder: (context, roleSnapshot) {
                if (roleSnapshot.hasData) {
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
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: StreamBuilder<ProjectParticipant>(
                                    stream: bloc.getFavoriteStream(projectId: project?.id ?? ""),
                                    builder: (context, favoriteSnapshot) {
                                      return InkWellWrapper(
                                        onTap: () {
                                          bloc.setFavoriteValue(id: favoriteSnapshot.data?.id ?? "", value: !(favoriteSnapshot.data?.favorite ?? false));
                                        },
                                        margin: const EdgeInsets.only(right: 16),
                                        child: favoriteSnapshot.hasData && favoriteSnapshot.data != null && favoriteSnapshot.data!.favorite == true
                                            ? SvgPicture.asset(
                                                VectorImageAssets.ic_heart_bold,
                                          color: AppColors.red60,
                                              )
                                            : SvgPicture.asset(
                                                VectorImageAssets.ic_heart,
                                              ),
                                      );
                                    }),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 16),
                            height: 8,
                            width: double.infinity,
                            color: AppColors.neutral99,
                          ),
                          InkWellWrapper(
                            onTap: roleSnapshot.data == "Owner"
                                ? () {
                                    projectNameController.text = snapshot.data?.name ?? "";
                                    showUpdateProjectNameDialog(projectId: project?.id ?? "");
                                  }
                                : null,
                            paddingChild: const EdgeInsets.all(16),
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Name",
                                      style: Theme.of(context).textTheme.headline4?.copyWith(
                                            color: AppColors.neutral10,
                                          ),
                                    ),
                                    Visibility(
                                      visible: roleSnapshot.data == "Owner",
                                      child: SvgPicture.asset(
                                        VectorImageAssets.ic_edit,
                                        height: 20,
                                        width: 20,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  ],
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
                            onTap: roleSnapshot.data != "Viewer"
                                ? () {
                                    projectDescriptionController.text = snapshot.data?.description ?? "";
                                    showUpdateProjectDescriptionDialog(projectId: project?.id ?? "");
                                  }
                                : null,
                            paddingChild: const EdgeInsets.all(16),
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Description",
                                      style: Theme.of(context).textTheme.headline4?.copyWith(
                                            color: AppColors.neutral10,
                                          ),
                                    ),
                                    Visibility(
                                      visible: roleSnapshot.data == "Owner",
                                      child: SvgPicture.asset(
                                        VectorImageAssets.ic_edit,
                                        height: 20,
                                        width: 20,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  ],
                                ),
                                Visibility(
                                  visible: snapshot.data?.description != null && snapshot.data!.description != "",
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 12),
                                      Text(
                                        (snapshot.data?.description == null || snapshot.data!.description == "")
                                            ? "..."
                                            : snapshot.data?.description ?? "...",
                                        style: Theme.of(context).textTheme.headline5?.copyWith(height: 1.3),
                                      ),
                                    ],
                                  ),
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
                            onTap: roleSnapshot.data != "Viewer"
                                ? () async {
                                    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                                    if (pickedFile != null) {
                                      setState(() {
                                        isLoadingImage = true;
                                      });
                                      bloc.changeImage(filePath: pickedFile.path, projectId: project?.id ?? "").whenComplete(
                                            () => {
                                              setState(() {
                                                isLoadingImage = false;
                                              })
                                            },
                                          );
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
                                  children: [
                                    Text(
                                      "Picture",
                                      style: Theme.of(context).textTheme.headline4?.copyWith(
                                            color: AppColors.neutral10,
                                          ),
                                    ),
                                    Visibility(
                                      visible: roleSnapshot.data == "Owner",
                                      child: SvgPicture.asset(
                                        VectorImageAssets.ic_edit,
                                        height: 20,
                                        width: 20,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Stack(
                                  children: [
                                    const LoadingContainer(height: 100, width: 100),
                                    Visibility(
                                      visible: !isLoadingImage,
                                      child: Image.network(
                                        snapshot.data?.image ?? "",
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, event) {
                                          if (event == null) return child;
                                          return const LoadingContainer(height: 100, width: 100);
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
                                    ),
                                  ],
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
                            padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16, bottom: 8),
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
                                                  return Slidable(
                                                    endActionPane: roleSnapshot.data == "Owner"
                                                        ? ActionPane(
                                                            motion: const ScrollMotion(),
                                                            children: [
                                                              SlidableAction(
                                                                onPressed: (context) {},
                                                                backgroundColor: AppColors.yellow60,
                                                                foregroundColor: Colors.white,
                                                                icon: Icons.edit,
                                                              ),
                                                              Visibility(
                                                                visible: userSnapshot.data!.uid != bloc.getUid() && userSnapshot.data!.uid != "",
                                                                child: SlidableAction(
                                                                  onPressed: (context) {},
                                                                  backgroundColor: AppColors.red60,
                                                                  foregroundColor: Colors.white,
                                                                  icon: Icons.delete,
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : null,
                                                    child: Container(
                                                      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                                                      margin: const EdgeInsets.only(bottom: 8),
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
                          StreamBuilder<List<InvitationModel>>(
                              stream: bloc.getListInvitationByProjectId(project?.id ?? ""),
                              builder: (context, inviteSnapshot) {
                                if (inviteSnapshot.hasData && inviteSnapshot.data!.isNotEmpty) {
                                  return Column(
                                    children: List.generate(
                                        inviteSnapshot.data?.length ?? 0,
                                        (index) => StreamBuilder<User>(
                                              stream: bloc.getInformationUserByIdStream(inviteSnapshot.data![index].receiverId ?? ""),
                                              builder: (context, userSnapshot) {
                                                if (userSnapshot.hasData) {
                                                  return Slidable(
                                                    endActionPane: roleSnapshot.data == "Owner"
                                                        ? ActionPane(
                                                            motion: const ScrollMotion(),
                                                            children: [
                                                              SlidableAction(
                                                                onPressed: (context) {
                                                                  bloc.deleteInvitation(id: inviteSnapshot.data?[index].id ?? "");
                                                                },
                                                                backgroundColor: AppColors.red60,
                                                                foregroundColor: Colors.white,
                                                                icon: Icons.delete,
                                                              ),
                                                            ],
                                                          )
                                                        : null,
                                                    child: Container(
                                                      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                                                      margin: const EdgeInsets.only(bottom: 8),
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
                                                            "inviting...",
                                                            style: Theme.of(context).textTheme.headline6?.copyWith(
                                                                  fontStyle: FontStyle.italic,
                                                                  fontSize: 16,
                                                                ),
                                                          )
                                                        ],
                                                      ),
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
                          Visibility(
                            visible: roleSnapshot.data == "Owner",
                            child: InkWellWrapper(
                              onTap: () {
                                emailController.clear();
                                setState(() {
                                  choice = "Viewer";
                                });
                                showAddMemberDialog(projectId: project?.id ?? "");
                              },
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
                          Visibility(
                            visible: roleSnapshot.data != "Owner",
                            child: InkWellWrapper(
                              paddingChild: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                              border: const Border(top: BorderSide(color: AppColors.neutral99)),
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
                          ),
                          Visibility(
                            visible: roleSnapshot.data != "Viewer",
                            child: InkWellWrapper(
                              paddingChild: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              });
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
                  if (_taskNameFormKey.currentState?.validate() == true && taskNameController.text != "") {
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

  void showUpdateBoardNameDialog({required String boardId, required String projectId}) {
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
                    bloc.updateBoardName(id: boardId, name: boardNameController.text.trim(), projectId: projectId);
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

  void showAddBoardDialog({required String projectId, required int index}) {
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
                  textFieldType: TextFieldType.text,
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
                  if (_boardNameFormKey.currentState?.validate() == true && boardNameController.text != "") {
                    primaryFocus?.unfocus();
                    bloc.createBoard(projectId: projectId, name: boardNameController.text.trim(), index: index);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          );
        });
  }

  void showAddMemberDialog({required String projectId}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(16),
            title: Text(
              "Add new member",
              style: Theme.of(context).textTheme.headline3,
            ),
            content: StatefulBuilder(
              builder: (BuildContext context, void Function(void Function()) setState) {
                return Form(
                  key: _emailFormKey,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomTextField(
                          textFieldType: TextFieldType.email,
                          textFieldConfig: TextFieldConfig(
                            controller: emailController,
                            style: Theme.of(context).textTheme.bodyText2?.copyWith(color: AppColors.neutral10),
                            cursorColor: AppColors.primaryBlack,
                          ),
                          decorationConfig: TextFieldDecorationConfig(
                            hintText: "Enter email new member",
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
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: DropdownButtonFormField(
                            value: choice,
                            items: const [
                              DropdownMenuItem(
                                value: "Viewer",
                                child: Text("Viewer"),
                              ),
                              DropdownMenuItem(
                                value: "Editor",
                                child: Text("Editor"),
                              ),
                              DropdownMenuItem(
                                value: "Owner",
                                child: Text("Owner"),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                choice = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
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
                  'Invite',
                  style: Theme.of(context).textTheme.button?.copyWith(color: AppColors.mediumPersianBlue),
                ),
                onPressed: () async {
                  primaryFocus?.unfocus();
                  if (_emailFormKey.currentState?.validate() == true && emailController.text != "") {
                    primaryFocus?.unfocus();
                    bool checkNewUser = await bloc.checkInvalidNewUser(projectId: projectId, email: emailController.text.trim());
                    bool checkNewInvitation = await bloc.checkInvalidInvitation(projectId: projectId, email: emailController.text.trim());
                    if (checkNewUser == true && checkNewInvitation == true) {
                      primaryFocus?.unfocus();
                      String? receiverId = await bloc.getUidByEmail(email: emailController.text.trim());
                      bloc
                          .createInvitation(projectId: projectId, role: choice, receiverId: receiverId ?? "")
                          .whenComplete(() => Navigator.pop(context));
                    } else {
                      if (checkNewUser == false) {
                        print("message ::: Không tìm thấy người này");
                      } else {
                        print("message ::: Người này đang được mời");
                      }
                    }
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
