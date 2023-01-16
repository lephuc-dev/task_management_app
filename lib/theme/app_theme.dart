import 'package:flutter/material.dart';
import '../resources/resources.dart';

class AppThemes {
  static AppThemes? _instance;

  AppThemes._();

  factory AppThemes() {
    _instance ??= AppThemes._();
    return _instance!;
  }

  ThemeData get lightTheme => _lightTheme;

  static const TextTheme _lightTextTheme = TextTheme(
    headline1: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: AppColors.primaryBlack),
    headline2: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w900, color: AppColors.primaryBlack),
    headline3: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w800, color: AppColors.primaryBlack),
    headline4: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700, color: AppColors.primaryBlack),
    headline5: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: AppColors.primaryBlack),
    headline6: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: AppColors.primaryBlack),
    subtitle1: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: AppColors.primaryBlack),
    subtitle2: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400, color: AppColors.primaryBlack),
    bodyText1: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: AppColors.primaryBlack),
    bodyText2: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400, color: AppColors.primaryBlack),
    caption: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700, color: AppColors.primaryBlack),
    button: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: AppColors.primaryWhite),
    overline: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700, color: AppColors.primaryBlack),
  );

  final _lightTheme = ThemeData(
    fontFamily: 'AvenirNextRoundedPro',
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: _lightTextTheme,
  );
}
