import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:listplace/config/app_colors.dart';

class Styles {
  static const String appFontFamily = 'Jost';
  static const String appSecondaryFontFamily = 'Glory';
  static const String appOtherFontFamily = 'Goldman';

  static var baseStyle = TextStyle(
    color: AppColors.blackColor,
    fontSize: 16.sp,
    fontFamily: appFontFamily,
    fontWeight: FontWeight.w400,
  );
  static var largeTitle = TextStyle(
    color: AppColors.blackColor,
    fontSize: 24.sp,
    fontFamily: appFontFamily,
    fontWeight: FontWeight.w500,
  );
  static var smallTitle = TextStyle(
    color: AppColors.blackColor,
    fontSize: 22.sp,
    fontFamily: appFontFamily,
    fontWeight: FontWeight.w500,
  );
  static var bodyLarge = TextStyle(
    color: AppColors.blackColor,
    fontSize: 18.sp,
    fontFamily: appFontFamily,
    fontWeight: FontWeight.w400,
  );
  static var bodyMedium = TextStyle(
    color: AppColors.blackColor,
    fontSize: 16.sp,
    fontFamily: appFontFamily,
    fontWeight: FontWeight.w500,
  );
  static var bodySmall = TextStyle(
    color: AppColors.blackColor,
    fontSize: 14.sp,
    fontFamily: appFontFamily,
    fontWeight: FontWeight.w400,
  );
  static var appBarTitle = TextStyle(
    color: AppColors.blackColor,
    fontSize: 20.sp,
    fontFamily: appFontFamily,
    fontWeight: FontWeight.w500,
  );
}
