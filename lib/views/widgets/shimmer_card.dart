import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:listplace/config/app_colors.dart';
import 'package:shimmer/shimmer.dart';

import '../../config/dimensions.dart';

class ShimmerCard extends StatelessWidget {
  final double? height;
  final double? width;
  const ShimmerCard({Key? key, this.height, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor:
          Get.isDarkMode ? AppColors.darkCardColorDeep : Colors.grey.shade300,
      highlightColor:
          Get.isDarkMode ? AppColors.darkCardColor : Colors.grey.shade500,
      child: Container(
        height: height ?? 95.h,
        width: width,
        decoration: BoxDecoration(
          color: Get.isDarkMode
              ? AppColors.darkCardColor
              : AppColors.mainColor.withValues(alpha: .2),
          borderRadius: Dimensions.kBorderRadius,
        ),
      ),
    );
  }
}
