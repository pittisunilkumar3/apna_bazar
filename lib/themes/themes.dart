import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:listplace/config/styles.dart';
import '../../config/app_colors.dart';

class AppThemes {
  static getIconBlackColor() {
    return Get.isDarkMode ? AppColors.whiteColor : AppColors.blackColor;
  }

  static getGreyColor() {
    return Get.isDarkMode ? AppColors.whiteColor : AppColors.greyColor;
  }

  static getHintColor() {
    return Get.isDarkMode ? AppColors.whiteColor : AppColors.textFieldHintColor;
  }

  static getDarkCardColor() {
    return Get.isDarkMode ? AppColors.darkCardColor : AppColors.whiteColor;
  }

  static getSliderInactiveColor() {
    return Get.isDarkMode
        ? AppColors.darkCardColorDeep
        : AppColors.sliderInActiveColor;
  }

  static getDarkBgColor() {
    return Get.isDarkMode ? AppColors.darkBgColor : AppColors.whiteColor;
  }

  static borderColor() {
    return Get.isDarkMode ? Colors.transparent : Colors.transparent;
  }

  static getParagraphColor() {
    return Get.isDarkMode ? AppColors.black40 : AppColors.paragraphColor;
  }

  static getBlack10Color() {
    return Get.isDarkMode ? AppColors.darkCardColor : AppColors.black10;
  }

  static getFillColor() {
    return Get.isDarkMode ? AppColors.darkCardColor : AppColors.fillColor;
  }

  static getInactiveColor() {
    return Get.isDarkMode
        ? AppColors.darkCardColor
        : AppColors.textFieldHintColor;
  }

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.whiteColor,
    drawerTheme: const DrawerThemeData(backgroundColor: AppColors.whiteColor),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: AppColors.whiteColor,
      elevation: 0,
    ),
    dialogTheme: const DialogThemeData(backgroundColor: AppColors.whiteColor),
    iconTheme: const IconThemeData(
      color: AppColors.blackColor,
    ),
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.whiteColor),
    textTheme: TextTheme(
      displayMedium: Styles.baseStyle,
      titleLarge: Styles.largeTitle,
      titleMedium: Styles.appBarTitle,
      titleSmall: Styles.smallTitle,
      bodyLarge: Styles.bodyLarge,
      bodyMedium: Styles.bodyMedium,
      bodySmall: Styles.bodySmall,
    ),
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: AppColors.mainColor.withValues(alpha: .4),
      cursorColor: AppColors.mainColor.withValues(alpha: .4),
      selectionHandleColor: AppColors.mainColor.withValues(alpha: 0.4),
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: Styles.baseStyle.copyWith(color: AppColors.textFieldHintColor),
      filled: true,
      fillColor: AppColors.fillColor,
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red), // Error border color
        borderRadius: BorderRadius.circular(6.r), // Border radius
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red), // Error border color
        borderRadius: BorderRadius.circular(6.r),
      ),
    ),
    useMaterial3: true,
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBgColor,
    drawerTheme: const DrawerThemeData(backgroundColor: AppColors.darkBgColor),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: AppColors.darkBgColor,
      elevation: 0,
    ),
    iconTheme: const IconThemeData(
      color: AppColors.whiteColor,
    ),
    dialogTheme:
        const DialogThemeData(backgroundColor: AppColors.darkCardColor),
    colorScheme: const ColorScheme.dark(primary: AppColors.darkCardColor),
    textTheme: TextTheme(
      displayMedium: Styles.baseStyle.copyWith(color: AppColors.whiteColor),
      titleLarge: Styles.largeTitle.copyWith(color: AppColors.whiteColor),
      titleMedium: Styles.appBarTitle.copyWith(color: AppColors.whiteColor),
      titleSmall: Styles.smallTitle.copyWith(color: AppColors.whiteColor),
      bodyLarge: Styles.bodyLarge.copyWith(color: AppColors.whiteColor),
      bodyMedium: Styles.bodyMedium.copyWith(color: AppColors.whiteColor),
      bodySmall: Styles.bodySmall.copyWith(color: AppColors.whiteColor),
    ),
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: AppColors.mainColor.withValues(alpha: .4),
      cursorColor: AppColors.mainColor.withValues(alpha: .4),
      selectionHandleColor: AppColors.mainColor.withValues(alpha: 0.4),
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: Styles.baseStyle.copyWith(color: AppColors.textFieldHintColor),
      filled: true,
      fillColor: AppColors.darkCardColor,
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red), // Error border color
        borderRadius: BorderRadius.circular(6.r), // Border radius
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red), // Error border color
        borderRadius: BorderRadius.circular(6.r),
      ),
    ),
    useMaterial3: true,
  );
}
