import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:task_management_app/base/base.dart';
import 'package:task_management_app/blocs/blocs.dart';
import 'package:task_management_app/pages/pages.dart';

import '../../resources/resources.dart';

class MainPage extends StatefulWidget {
  final MainBloc bloc;
  final ProfileTabBloc profileTabBloc;
  const MainPage({
    Key? key,
    required this.bloc,
    required this.profileTabBloc,
  }) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends BaseState<MainPage, MainBloc> {
  int currentIndex = 0;

  final bottomBarIcons = [
    VectorImageAssets.ic_home,
    VectorImageAssets.ic_schedule,
    VectorImageAssets.ic_notification,
    VectorImageAssets.ic_user,
  ];

  final bottomBarActiveIcons = [
    VectorImageAssets.ic_home_solid,
    VectorImageAssets.ic_schedule_solid,
    VectorImageAssets.ic_notification_solid,
    VectorImageAssets.ic_user_solid,
  ];

  final List<String> bottomBarTitles = [
    "Home",
    "Schedule",
    "Notification",
    "Profile",
  ];

  late List<Widget> tabScreens = [
    const Scaffold(),
    const Scaffold(),
    const Scaffold(),
    ProfileTabPage(bloc: widget.profileTabBloc),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mediumPersianBlue,
      body: tabScreens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          if (index != currentIndex) {
            setState(() {
              currentIndex = index;
            });
          }
        },
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        fixedColor: AppColors.mediumPersianBlue,
        selectedLabelStyle: Theme.of(context).textTheme.subtitle1?.copyWith(
              fontSize: 12,
            ),
        unselectedLabelStyle: Theme.of(context).textTheme.subtitle1?.copyWith(
              fontSize: 12,
            ),
        items: List.generate(
          bottomBarIcons.length,
          (index) => BottomNavigationBarItem(
            icon: SvgPicture.asset(
              bottomBarIcons[index],
              width: 24.0,
              height: 24.0,
              color: AppColors.primaryBlack,
              fit: BoxFit.cover,
            ),
            label: bottomBarTitles[index],
            activeIcon: SvgPicture.asset(
              bottomBarActiveIcons[index],
              width: 24.0,
              height: 24.0,
              color: AppColors.mediumPersianBlue,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  @override
  MainBloc get bloc => widget.bloc;
}