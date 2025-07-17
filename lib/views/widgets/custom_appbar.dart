import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../config/app_colors.dart';
import '../../utils/app_constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final List<Widget>? actions;
  final String? title;
  final double? toolberHeight;
  final double? prefferSized;
  final Color? bgColor;
  final bool? isReverseIconBgColor;
  final bool? isTitleMarginTop;
  final double? fontSize;
  final Widget? titleWidget;
  final void Function()? onBackPressed;
  final bool? centerTitle;
  const CustomAppBar(
      {super.key,
      this.leading,
      this.actions,
      this.title,
      this.titleWidget,
      this.toolberHeight,
      this.prefferSized,
      this.isReverseIconBgColor = false,
      this.isTitleMarginTop = false,
      this.bgColor,
      this.onBackPressed,
      this.centerTitle,
      this.fontSize});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return AppBar(
      toolbarHeight: toolberHeight ?? 100.h,
      backgroundColor: bgColor,
      centerTitle: centerTitle ?? true,
      title: titleWidget ??
          Padding(
            padding: isTitleMarginTop == true
                ? EdgeInsets.only(top: Platform.isIOS ? 40.h : 20.h)
                : EdgeInsets.zero,
            child: Text(
              title ?? "",
              style: t.titleSmall?.copyWith(
                fontSize: fontSize ?? 22.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      leading: leading ??
          IconButton(
              onPressed: onBackPressed ??
                  () {
                    Get.back();
                  },
              icon: Container(
                padding: EdgeInsets.all(8.h),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Get.isDarkMode
                        ? AppColors.darkCardColorDeep
                        : AppColors.sliderInActiveColor,
                    width: Get.isDarkMode ? .8 : .9,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  "$rootImageDir/back.png",
                  height: 16.h,
                  width: 16.h,
                  color:
                      Get.isDarkMode ? AppColors.whiteColor : AppColors.black70,
                  fit: BoxFit.fitHeight,
                ),
              )),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(prefferSized ?? 70.h);
}
