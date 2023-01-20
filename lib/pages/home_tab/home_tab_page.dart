import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_management_app/widgets/loading_container.dart';
import '../../base/base.dart';
import '../../blocs/blocs.dart';
import '../../models/models.dart';
import '../../resources/resources.dart';
import 'widgets/favorite_project_item.dart';
import 'widgets/project_item.dart';

class HomeTabPage extends StatefulWidget {
  final HomeTabBloc bloc;
  const HomeTabPage({Key? key, required this.bloc}) : super(key: key);

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends BaseState<HomeTabPage, HomeTabBloc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Taskez",
          style: Theme.of(context).textTheme.headline5?.copyWith(color: AppColors.primaryWhite, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: AppColors.mediumPersianBlue,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: AppColors.primaryWhite),
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              VectorImageAssets.ic_add,
              height: 24,
              width: 24,
              fit: BoxFit.cover,
              color: AppColors.primaryWhite,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder<List<ProjectParticipant>>(
              stream: widget.bloc.getListFavoriteProjectByMyIdStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    return Column(
                    children: [
                      titleWidget(title: "Favorite Project"),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                        child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                            childAspectRatio: 2.0,
                          ),
                          itemBuilder: (BuildContext context, int i) {
                            return StreamBuilder<Project>(
                                stream: widget.bloc.getProjectStream(snapshot.data![i].projectId ?? ""),
                                builder: (context, projectSnapshot) {
                                  if (projectSnapshot.hasData) {
                                    return FavoriteProjectItem(project: projectSnapshot.data!);
                                  } else {
                                    return Container();
                                  }
                                });
                          },
                        ),
                      ),
                    ],
                  );
                  } else {
                    return Container();
                  }
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: LoadingContainer(
                          height: 24,
                          width: 68,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: 4,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                            childAspectRatio: 2.0,
                          ),
                          itemBuilder: (BuildContext context, int i) {
                            return LoadingContainer(borderRadius: BorderRadius.circular(4));
                          },
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
            StreamBuilder<List<ProjectParticipant>>(
              stream: widget.bloc.getListProjectByMyIdStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      titleWidget(title: "Project"),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (BuildContext context, int i) {
                          return StreamBuilder<Project>(
                              stream: widget.bloc.getProjectStream(snapshot.data![i].projectId ?? ""),
                              builder: (context, projectSnapshot) {
                                if (projectSnapshot.hasData) {
                                  return ProjectItem(project: projectSnapshot.data!);
                                } else {
                                  return Container();
                                }
                              });
                        },
                      ),
                    ],
                  );
                  } else {
                    return const Center(
                      child: Text("No Project"),
                    );
                  }
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: LoadingContainer(
                          height: 24,
                          width: 68,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      ...List.generate(10, (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            LoadingContainer(height: 40, width: 40, borderRadius: BorderRadius.circular(4),),
                            const SizedBox(width: 16),
                            LoadingContainer(height: 24, width: 200, borderRadius: BorderRadius.circular(4),),
                          ],
                        ),
                      ))
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget titleWidget({required String title}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
          color: AppColors.primaryWhite,
          border: Border(
            bottom: BorderSide(color: Color(0xFFC1C2C4), width: 0.5),
            top: BorderSide(color: Color(0xFFC1C2C4), width: 0.5),
          )),
      width: MediaQuery.of(context).size.width,
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }

  @override
  HomeTabBloc get bloc => widget.bloc;
}
