import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppStyles {
  static const TextStyle titleStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textWhite,
    fontFamily: 'SF Pro Display',
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSubtitle,
    fontFamily: 'SF Pro Display',
  );

  static const TextStyle errorTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.textError,
    fontFamily: 'SF Pro Display',
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    color: AppColors.buttonText,
    fontWeight: FontWeight.bold,
    fontFamily: 'SF Pro Display',
  );
}
