import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../base/base.dart';
import '../../blocs/blocs.dart';
import '../../models/models.dart';
import '../../resources/resources.dart';
import '../../widgets/widgets.dart';
import 'widgets/favorite_project_item.dart';
import 'widgets/project_item.dart';

class HomeTabPage extends StatefulWidget {
  final HomeTabBloc bloc;
  const HomeTabPage({Key? key, required this.bloc}) : super(key: key);

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends BaseState<HomeTabPage, HomeTabBloc> {
  TextEditingController projectNameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    projectNameController.dispose();
    super.dispose();
  }

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
            icon: StreamBuilder<Object>(
                stream: null,
                builder: (context, snapshot) {
                  return Badge(
                    badgeContent: Text(
                      "1",
                      style: Theme.of(context).textTheme.headline5?.copyWith(fontSize: 12, color: AppColors.primaryWhite),
                    ),
                    child: SvgPicture.asset(
                      VectorImageAssets.ic_notification,
                      height: 24,
                      width: 24,
                      fit: BoxFit.cover,
                      color: AppColors.primaryWhite,
                    ),
                  );
                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          projectNameController.clear();
          showProjectDialog();
        },
        backgroundColor: AppColors.green60,
        child: SvgPicture.asset(
          VectorImageAssets.ic_add,
          height: 24,
          width: 24,
          color: AppColors.primaryWhite,
          fit: BoxFit.cover,
        ),
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
                      ...List.generate(
                          10,
                          (index) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                child: Row(
                                  children: [
                                    LoadingContainer(
                                      height: 40,
                                      width: 40,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    const SizedBox(width: 16),
                                    LoadingContainer(
                                      height: 24,
                                      width: 200,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
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

  void showProjectDialog() {
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
              key: _formKey,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: CustomTextField(
                  textFieldType: TextFieldType.text,
                  textFieldConfig: TextFieldConfig(
                    controller: projectNameController,
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(color: AppColors.neutral10),
                    cursorColor: AppColors.primaryBlack,
                  ),
                  decorationConfig: TextFieldDecorationConfig(
                    hintText: "Enter project name",
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
                  if (_formKey.currentState?.validate() == true && projectNameController.text != "") {
                    primaryFocus?.unfocus();
                    bloc.createProject(name: projectNameController.text.trim());
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          );
        });
  }

  @override
  HomeTabBloc get bloc => widget.bloc;
}
