import 'package:flutter/material.dart';
import '../../base/base.dart';
import '../../blocs/blocs.dart';
import '../../models/models.dart';
import '../../resources/resources.dart';
import '../../router/router.dart';
import '../../widgets/widgets.dart';
import 'widgets/option_item.dart';

class ProfileTabPage extends StatefulWidget {
  final ProfileTabBloc bloc;
  const ProfileTabPage({Key? key, required this.bloc}) : super(key: key);

  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends BaseState<ProfileTabPage, ProfileTabBloc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryWhite,
        centerTitle: true,
        title: Text(
          "Profile",
          style: Theme.of(context).textTheme.headline5?.copyWith(fontSize: 19),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWellWrapper(
              onTap: () {},
              paddingChild: const EdgeInsets.only(top: 16.0),
              child: StreamBuilder<User?>(
                  stream: bloc.getInformationUserStream(),
                  builder: (context, snapshot) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: snapshot.hasData
                              ? Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      child: Image.network(
                                        snapshot.data?.avatar ?? "",
                                        height: 60,
                                        width: 60,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, event) {
                                          if (event == null) return child;
                                          return const LoadingContainer(height: 74, width: 74);
                                        },
                                        errorBuilder: (context, object, stacktrace) {
                                          return AvatarWithName(
                                            name: snapshot.data?.name ?? "?",
                                            fontSize: 18,
                                            shapeSize: 60,
                                            count: 2,
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.data?.name ?? "Unknown",
                                            style: Theme.of(context).textTheme.headline4?.copyWith(fontSize: 20),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            snapshot.data?.email ?? "Unknown",
                                            style: Theme.of(context).textTheme.subtitle2?.copyWith(fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    const ClipOval(
                                      child: LoadingContainer(
                                        height: 60,
                                        width: 60,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          LoadingContainer(
                                            height: 24,
                                            width: 100,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          const SizedBox(height: 4),
                                          LoadingContainer(
                                            height: 18,
                                            width: 150,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                        Container(
                          height: 8,
                          margin: const EdgeInsets.only(top: 16),
                          width: double.infinity,
                          color: AppColors.neutral99,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16, top: 16),
                          child: Text(
                            "Account",
                            style: Theme.of(context).textTheme.headline4?.copyWith(
                                  color: AppColors.neutral10,
                                ),
                          ),
                        ),
                        OptionItem(
                          title: 'Change name',
                          icon: VectorImageAssets.ic_edit_name,
                          onTap: () {
                            ///TODO: Thêm sự kiện chuyển sang màn hình MyTasks
                          },
                        ),
                        OptionItem(
                          title: 'Change avatar',
                          icon: VectorImageAssets.ic_avatar,
                          onTap: () {
                            ///TODO: Thêm sự kiện chuyển sang màn hình MyTasks
                          },
                        ),
                        OptionItem(
                          title: 'Change Password',
                          icon: VectorImageAssets.ic_password,
                          onTap: () {
                            ///TODO: Thêm sự kiện chuyển sang màn hình MyTasks
                          },
                        ),
                      ],
                    );
                  }),
            ),
            Container(
              height: 8,
              width: double.infinity,
              color: AppColors.neutral99,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 16),
              child: Text(
                "Settings",
                style: Theme.of(context).textTheme.headline4?.copyWith(
                      color: AppColors.neutral10,
                    ),
              ),
            ),
            OptionItem(
              title: 'Notifications',
              icon: VectorImageAssets.ic_notification,
              onTap: () {
                ///TODO: Thêm sự kiện chuyển sang màn hình MyTasks
              },
            ),
            OptionItem(
              title: 'Languages',
              icon: VectorImageAssets.ic_language,
              onTap: () {
                ///TODO: Thêm sự kiện chuyển sang màn hình MyTasks
              },
            ),
            OptionItem(
              title: 'Theme',
              icon: VectorImageAssets.ic_sun,
              onTap: () {
                ///TODO: Thêm sự kiện chuyển sang màn hình MyTasks
              },
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
            OptionItem(
              title: 'Help',
              icon: VectorImageAssets.ic_help,
              onTap: () {
                ///TODO: Thêm sự kiện chuyển sang màn hình MyTasks
              },
            ),
            OptionItem(
              title: 'Privacy & Policy',
              icon: VectorImageAssets.ic_privacy,
              onTap: () {
                Navigator.pushNamed(context, Routes.privacy);
              },
            ),
            OptionItem(
              title: 'Terms & Conditions',
              icon: VectorImageAssets.ic_book,
              onTap: () {
                Navigator.pushNamed(context, Routes.terms);
              },
            ),
            OptionItem(
              title: 'Log Out',
              icon: VectorImageAssets.ic_logout,
              onTap: () {
                bloc.signOut().then((value) => Navigator.pushNamedAndRemoveUntil(context, Routes.signIn, (route) => false));
              },
            ),
            Container(
              height: 8,
              width: double.infinity,
              color: AppColors.neutral99,
            ),
          ],
        ),
      ),
    );
  }

  @override
  ProfileTabBloc get bloc => widget.bloc;
}
