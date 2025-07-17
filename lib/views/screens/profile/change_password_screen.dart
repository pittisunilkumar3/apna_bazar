import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:listplace/config/dimensions.dart';
import 'package:listplace/themes/themes.dart';
import 'package:listplace/utils/services/helpers.dart';
import 'package:listplace/views/widgets/app_button.dart';
import 'package:listplace/views/widgets/custom_appbar.dart';
import 'package:listplace/views/widgets/custom_textfield.dart';
import 'package:listplace/views/widgets/spacing.dart';
import '../../../config/app_colors.dart';
import '../../../controllers/profile_controller.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    ProfileController controller = Get.find<ProfileController>();
    return GetBuilder<ProfileController>(builder: (_) {
      return Scaffold(
        appBar: CustomAppBar(
          isReverseIconBgColor: true,
          title: storedLanguage['Change Password'] ?? "Change Password",
          actions: const [],
        ),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VSpace(Dimensions.screenHeight * .05),
              Container(
                height: Dimensions.screenHeight * .85,
                width: double.maxFinite,
                padding: Dimensions.kDefaultPadding,
                decoration: BoxDecoration(
                  color: AppThemes.getDarkBgColor(),
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(18.r)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VSpace(42.h),
                    Text(
                        storedLanguage['Current Password'] ??
                            "Current Password",
                        style: t.displayMedium),
                    VSpace(10.h),
                    GetBuilder<ProfileController>(builder: (_) {
                      return Container(
                        height: 50.h,
                        width: double.maxFinite,
                        padding: EdgeInsets.only(left: 10.w),
                        decoration: BoxDecoration(
                          borderRadius: Dimensions.kBorderRadius,
                          border: Border.all(
                              color: AppThemes.getSliderInactiveColor()),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.lock_outline,
                              size: 20.h,
                              color: Get.isDarkMode
                                  ? AppColors.whiteColor
                                  : AppColors.greyColor,
                            ),
                            Expanded(
                              child: CustomTextField(
                                height: 50.h,
                                obsCureText:
                                    controller.currentPassShow ? true : false,
                                hintext:
                                    storedLanguage['Enter Current Password'] ??
                                        "Enter Current Password",
                                controller:
                                    controller.currentPassEditingController,
                                onChanged: (v) {
                                  controller.currentPassVal.value = v;
                                },
                                isBorderColor: false,
                                bgColor: Colors.transparent,
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  controller.currentPassObscure();
                                },
                                icon: Image.asset(
                                  controller.currentPassShow
                                      ? "$rootImageDir/hide.png"
                                      : "$rootImageDir/show.png",
                                  height: 20.h,
                                  width: 20.w,
                                )),
                          ],
                        ),
                      );
                    }),
                    VSpace(24.h),
                    Text(storedLanguage['New Password'] ?? "New Password",
                        style: t.displayMedium),
                    VSpace(10.h),
                    GetBuilder<ProfileController>(builder: (_) {
                      return Container(
                        height: 50.h,
                        width: double.maxFinite,
                        padding: EdgeInsets.only(left: 10.w),
                        decoration: BoxDecoration(
                          borderRadius: Dimensions.kBorderRadius,
                          border: Border.all(
                              color: AppThemes.getSliderInactiveColor()),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.lock_outline,
                              size: 20.h,
                              color: Get.isDarkMode
                                  ? AppColors.whiteColor
                                  : AppColors.greyColor,
                            ),
                            Expanded(
                              child: CustomTextField(
                                height: 50.h,
                                isBorderColor: false,
                                obsCureText:
                                    controller.isNewPassShow ? true : false,
                                hintext: storedLanguage['Enter New Password'] ??
                                    "Enter New Password",
                                controller: controller.newPassEditingController,
                                onChanged: (v) {
                                  controller.newPassVal.value = v;
                                },
                                bgColor: Colors.transparent,
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  controller.newPassObscure();
                                },
                                icon: Image.asset(
                                  controller.isNewPassShow
                                      ? "$rootImageDir/hide.png"
                                      : "$rootImageDir/show.png",
                                  height: 20.h,
                                  width: 20.w,
                                )),
                          ],
                        ),
                      );
                    }),
                    VSpace(24.h),
                    Text(
                        storedLanguage['Confirm  Password'] ??
                            "Confirm Password",
                        style: t.displayMedium),
                    VSpace(10.h),
                    GetBuilder<ProfileController>(builder: (_) {
                      return Container(
                          height: 50.h,
                          width: double.maxFinite,
                          padding: EdgeInsets.only(left: 10.w),
                          decoration: BoxDecoration(
                            borderRadius: Dimensions.kBorderRadius,
                            border: Border.all(
                                color: AppThemes.getSliderInactiveColor()),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.lock_outline,
                                size: 20.h,
                                color: Get.isDarkMode
                                    ? AppColors.whiteColor
                                    : AppColors.greyColor,
                              ),
                              Expanded(
                                child: CustomTextField(
                                  height: 50.h,
                                  isBorderColor: false,
                                  obsCureText: controller.isConfirmPassShow
                                      ? true
                                      : false,
                                  hintext: storedLanguage['Confirm Password'] ??
                                      "Confirm Password",
                                  controller:
                                      controller.confirmEditingController,
                                  onChanged: (v) {
                                    controller.confirmPassVal.value = v;
                                  },
                                  bgColor: Colors.transparent,
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    controller.confirmPassObscure();
                                  },
                                  icon: Image.asset(
                                    controller.isConfirmPassShow
                                        ? "$rootImageDir/hide.png"
                                        : "$rootImageDir/show.png",
                                    height: 20.h,
                                    width: 20.w,
                                  )),
                            ],
                          ));
                    }),
                    VSpace(24.h),
                    Material(
                      color: Colors.transparent,
                      child: AppButton(
                        isLoading: controller.isLoading,
                        onTap: controller.isLoading
                            ? null
                            : () {
                                if (controller.currentPassVal.value.isEmpty) {
                                  Helpers.showSnackBar(
                                      msg: "Current Password is required");
                                } else if (controller
                                    .newPassVal.value.isEmpty) {
                                  Helpers.showSnackBar(
                                      msg: "New Password is required");
                                } else if (controller
                                    .confirmPassVal.value.isEmpty) {
                                  Helpers.showSnackBar(
                                      msg: "Confirm Password is required");
                                } else {
                                  Helpers.hideKeyboard();
                                  controller.validateUpdatePass(context);
                                }
                              },
                        text: storedLanguage['Update Passwrod'] ??
                            "Update Password",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
