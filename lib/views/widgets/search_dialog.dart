import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:listplace/views/widgets/appDialog.dart';
import 'package:listplace/views/widgets/custom_textfield.dart';
import 'package:listplace/views/widgets/spacing.dart';
import '../../config/app_colors.dart';
import '../../config/styles.dart';
import '../../themes/themes.dart';
import 'app_button.dart';

searchDialog(
    {required BuildContext context,
    TextEditingController? transaction,
    TextEditingController? remark,
    TextEditingController? startDate,
    dynamic Function(String)? onRemarkChanged,
    bool? isRemarkField = true,
    bool? isTransactionField = true,
    bool? isDateTimeField = true,
    String? remarkHint,
    String? transactionHintext,
    void Function()? onStartDatePressed,
    void Function()? onEndDatePressed,
    void Function()? onSearchPressed}) {
  return appDialog(
      context: context,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Filter Now",
              style: Styles.bodyMedium.copyWith(
                  color: Get.isDarkMode
                      ? AppColors.whiteColor
                      : AppColors.blackColor)),
          InkResponse(
            onTap: () {
              Get.back();
            },
            child: Container(
              padding: EdgeInsets.all(7.h),
              decoration: BoxDecoration(
                color: AppThemes.getFillColor(),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                size: 14.h,
                color: AppThemes.getIconBlackColor(),
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          isTransactionField == true
              ? CustomTextField(
                  hintext: transactionHintext ?? "Search Transaction ID",
                  controller: transaction!,
                  contentPadding: EdgeInsets.only(left: 20.w),
                )
              : const SizedBox(),
          VSpace(isTransactionField == true ? 24.h : 0),
          isRemarkField == true
              ? CustomTextField(
                  hintext: remarkHint ?? "Remark",
                  controller: remark!,
                  contentPadding: EdgeInsets.only(left: 20.w),
                  onChanged: onRemarkChanged,
                )
              : const SizedBox(),
          VSpace(isRemarkField == true ? 24.h : 0),
          if (isDateTimeField == true)
            InkWell(
              onTap: onStartDatePressed,
              child: IgnorePointer(
                ignoring: true,
                child: CustomTextField(
                  hintext: "Date",
                  controller: startDate ?? TextEditingController(),
                  contentPadding: EdgeInsets.only(left: 20.w),
                ),
              ),
            ),
          VSpace(isDateTimeField == true ? 24.h : 0),
          AppButton(
            text: "Search Now",
            onTap: onSearchPressed,
          ),
        ],
      ));
}
