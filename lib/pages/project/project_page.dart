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
                                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
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
                                        GestureDetector(
                                          onTap: () {},
                                          child: SvgPicture.asset(
                                            VectorImageAssets.ic_more,
                                            height: 20,
                                            width: 20,
                                            fit: BoxFit.cover,
                                            color: AppColors.primaryBlack,
                                          ),
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
                                                              onTap: () => Navigator.pushNamed(context, Routes.task, arguments: listTaskSnapshot.data![indexListTask]),
                                                              margin: const EdgeInsets.only(bottom: 8),
                                                              paddingChild: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                                                              borderRadius: BorderRadius.circular(4),
                                                              color: AppColors.primaryWhite,
                                                              child: Column(
                                                                mainAxisSize: MainAxisSize.min,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    listTaskSnapshot.data![indexListTask].name ?? "",
                                                                    style: Theme.of(context).textTheme.headline5,
                                                                    maxLines: 1,
                                                                    overflow: TextOverflow.ellipsis,
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
                    onTap: () {},
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
                    onTap: () {},
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

  @override
  ProjectBloc get bloc => widget.bloc;
}
