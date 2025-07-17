import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:listplace/config/dimensions.dart';
import 'package:listplace/controllers/app_controller.dart';
import 'package:listplace/routes/routes_name.dart';
import 'package:listplace/themes/themes.dart';
import 'package:listplace/utils/services/localstorage/hive.dart';
import 'package:listplace/views/widgets/spacing.dart';
import 'package:photo_view/photo_view.dart';
import '../../../config/app_colors.dart';
import '../../../controllers/profile_controller.dart';
import '../../../controllers/verification_controller.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/custom_appbar.dart';

class ProfileSettingScreen extends StatelessWidget {
  final bool? isIdentityVerification;
  const ProfileSettingScreen({super.key, this.isIdentityVerification = false});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return GetBuilder<AppController>(builder: (appCtrl) {
      var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
      return GetBuilder<ProfileController>(builder: (profileCtrl) {
        return Scaffold(
          body: Column(
            children: [
              Container(
                height: 249.h,
                width: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage(
                    "$rootImageDir/login_img.png",
                  ),
                  fit: BoxFit.cover,
                )),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      bottom: -53.h,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (profileCtrl.userPhoto != '') {
                                Get.to(() => Scaffold(
                                      appBar: const CustomAppBar(
                                          title: "PhotoView"),
                                      body: PhotoView(
                                          imageProvider:
                                              CachedNetworkImageProvider(
                                                  profileCtrl.userPhoto)),
                                    ));
                              }
                            },
                            child: Container(
                              width: 116.h,
                              height: 116.h,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.mainColor,
                                    width: 1,
                                  )),
                              child: ClipOval(
                                child: profileCtrl.userPhoto == '' ||
                                        profileCtrl.userPhoto
                                            .contains("default")
                                    ? Image.asset(
                                        "$rootImageDir/profile_pic.webp",
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                profileCtrl.userPhoto,
                                              ),
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              VSpace(60.h),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: Dimensions.kDefaultPadding,
                    child: Column(
                      children: [
                        VSpace(10.h),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "${profileCtrl.firstNameEditingController.text} ${profileCtrl.lastNameEditingController.text}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: t.bodyMedium?.copyWith(
                                fontSize: 20.sp, fontWeight: FontWeight.w500),
                          ),
                        ),
                        VSpace(25.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Column(
                                children: [
                                  Text(
                                    profileCtrl.totalFollowing,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: t.bodyLarge?.copyWith(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  VSpace(5.h),
                                  Text(
                                    storedLanguage['Following'] ?? 'Following',
                                    style: t.displayMedium?.copyWith(
                                        color: AppThemes.getParagraphColor()),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 55.h,
                              width: 1,
                              color: Get.isDarkMode
                                  ? AppColors.darkCardColorDeep
                                  : AppColors.black10,
                            ),
                            Flexible(
                              child: Column(
                                children: [
                                  Text(
                                    profileCtrl.totalFollowers,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: t.bodyLarge?.copyWith(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  VSpace(5.h),
                                  Text(
                                    storedLanguage['Followers'] ?? 'Followers',
                                    maxLines: 1,
                                    style: t.displayMedium?.copyWith(
                                        color: AppThemes.getParagraphColor()),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 55.h,
                              width: 1,
                              color: Get.isDarkMode
                                  ? AppColors.darkCardColorDeep
                                  : AppColors.black10,
                            ),
                            Flexible(
                              child: Column(
                                children: [
                                  Text(
                                    profileCtrl.totalFollowing,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: t.bodyLarge?.copyWith(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  VSpace(5.h),
                                  Text(
                                    storedLanguage['Following'] ?? 'Following',
                                    style: t.displayMedium?.copyWith(
                                        color: AppThemes.getParagraphColor()),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        VSpace(25.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 36.h,
                                      width: 36.h,
                                      padding: EdgeInsets.all(10.h),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(18.r),
                                        color: Get.isDarkMode
                                            ? AppColors.darkCardColor
                                            : AppColors.fillColor,
                                      ),
                                      child: Image.asset(
                                        "$rootImageDir/moon.png",
                                        color: AppThemes.getIconBlackColor(),
                                      ),
                                    ),
                                    HSpace(10.w),
                                    Text(
                                      Get.isDarkMode
                                          ? storedLanguage['Light Mode'] ??
                                              "Light Mode"
                                          : storedLanguage['Dark Mode'] ??
                                              "Dark Mode",
                                      style: t.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                Transform.scale(
                                    scale: .8,
                                    child: Switch(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      thumbColor: WidgetStatePropertyAll(
                                          AppThemes.getGreyColor()),
                                      trackColor: WidgetStatePropertyAll(
                                          !Get.isDarkMode
                                              ? Colors.grey.shade300
                                              : AppColors.mainColor),
                                      value:
                                          HiveHelp.read(Keys.isDark) ?? false,
                                      onChanged: appCtrl.onChanged,
                                    )),
                              ],
                            ),
                            VSpace(32.h),
                            Text(
                              storedLanguage['Profile Settings'] ??
                                  "Profile Settings",
                              style: t.bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.w400),
                            ),
                            VSpace(20.h),
                            if (isIdentityVerification == true)
                              buildWidget2(t, storedLanguage),
                            if (isIdentityVerification == false)
                              buildWidget(t, storedLanguage),
                            VSpace(20.h),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      });
    });
  }

  ListView buildWidget(TextTheme t, storedLanguage) {
    return ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 7,
        itemBuilder: (context, i) {
          return ListTile(
            contentPadding: EdgeInsets.zero,
            onTap: () {
              if (i == 0) {
                Get.toNamed(RoutesName.editProfileScreen);
              } else if (i == 1) {
                Get.toNamed(RoutesName.changePasswordScreen);
              } else if (i == 2) {
                Get.find<VerificationController>().getTwoFa();
                Get.toNamed(RoutesName.twoFaVerificationScreen);
              } else if (i == 3) {
                Get.find<VerificationController>().getVerificationList();
                Get.toNamed(RoutesName.verificationListScreen);
              } else if (i == 4) {
                Get.toNamed(RoutesName.notificationPermissionScreen);
              } else if (i == 5) {
                Get.toNamed(RoutesName.deleteAccountScreen);
              } else {
                buildLogoutDialog(context, t, storedLanguage);
              }
            },
            leading: Container(
              height: 36.h,
              width: 36.h,
              padding: EdgeInsets.all(10.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.r),
                color: Get.isDarkMode
                    ? AppColors.darkCardColor
                    : AppColors.fillColor,
              ),
              child: i == 0
                  ? Image.asset(
                      "$rootImageDir/edit.png",
                      color: AppThemes.getIconBlackColor(),
                    )
                  : i == 1
                      ? Image.asset(
                          "$rootImageDir/lock_main.png",
                          color: AppThemes.getIconBlackColor(),
                        )
                      : i == 2
                          ? Image.asset(
                              "$rootImageDir/2fa.png",
                              color: AppThemes.getIconBlackColor(),
                            )
                          : i == 3
                              ? Image.asset(
                                  "$rootImageDir/verification.png",
                                  color: AppThemes.getIconBlackColor(),
                                )
                              : i == 4
                                  ? Image.asset(
                                      "$rootImageDir/notification.png",
                                      color: AppThemes.getIconBlackColor(),
                                    )
                                  : i == 5
                                      ? Image.asset(
                                          "$rootImageDir/delete_account.png",
                                          color: AppThemes.getIconBlackColor(),
                                        )
                                      : Image.asset(
                                          "$rootImageDir/log_out.png",
                                          color: AppThemes.getIconBlackColor(),
                                        ),
            ),
            title: Text(
                i == 0
                    ? storedLanguage['Edit Profile'] ?? "Edit Profile"
                    : i == 1
                        ? storedLanguage['Change Password'] ?? "Change Password"
                        : i == 2
                            ? storedLanguage['2FA Security'] ?? "2FA Security"
                            : i == 3
                                ? storedLanguage['KYC information'] ??
                                    "KYC information"
                                : i == 4
                                    ? storedLanguage['Notification Settings'] ??
                                        "Notification Settings"
                                    : i == 5
                                        ? storedLanguage['Delete'] ??
                                            "Delete Account"
                                        : storedLanguage['Log Out'] ??
                                            "Log Out",
                style: t.displayMedium),
            trailing: i == 6
                ? const SizedBox.shrink()
                : Container(
                    height: 32.h,
                    width: 32.h,
                    padding: EdgeInsets.all(10.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                      color: Get.isDarkMode
                          ? AppColors.darkCardColor
                          : AppColors.fillColor,
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 13.h,
                      color: AppThemes.getGreyColor(),
                    ),
                  ),
          );
        });
  }

  ListView buildWidget2(TextTheme t, storedLanguage) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        padding: EdgeInsets.zero,
        itemBuilder: (context, i) {
          return ListTile(
            contentPadding: EdgeInsets.zero,
            onTap: () {
              if (i == 0) {
                Get.toNamed(RoutesName.changePasswordScreen);
              } else if (i == 1) {
                Get.find<VerificationController>().getVerificationList();
                Get.toNamed(RoutesName.verificationListScreen);
              } else {
                buildLogoutDialog(context, t, storedLanguage);
              }
            },
            leading: Container(
              height: 36.h,
              width: 36.h,
              padding: EdgeInsets.all(10.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.r),
                color: AppColors.mainColor.withValues(alpha: .1),
              ),
              child: i == 0
                  ? Image.asset(
                      "$rootImageDir/lock_main.png",
                      color: AppColors.mainColor,
                    )
                  : i == 1
                      ? Image.asset(
                          "$rootImageDir/verification.png",
                          color: AppColors.mainColor,
                        )
                      : Image.asset(
                          "$rootImageDir/log_out.png",
                          color: AppColors.mainColor,
                        ),
            ),
            title: Text(
                i == 0
                    ? storedLanguage['Change Password'] ?? "Change Password"
                    : i == 1
                        ? storedLanguage['KYC information'] ?? "KYC information"
                        : storedLanguage['Log Out'] ?? "Log Out",
                style: t.displayMedium),
            trailing: i == 2
                ? const SizedBox.shrink()
                : Container(
                    height: 36.h,
                    width: 36.h,
                    padding: EdgeInsets.all(10.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                      color: Get.isDarkMode
                          ? AppColors.darkCardColor
                          : AppColors.mainColor.withValues(alpha: .1),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 16.h,
                      color: AppThemes.getGreyColor(),
                    ),
                  ),
          );
        });
  }

  Future<dynamic> buildLogoutDialog(
      BuildContext context, TextTheme t, storedLanguage) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            storedLanguage['Log out'] ?? "Log out",
            style: t.bodyLarge?.copyWith(fontSize: 20.sp),
          ),
          content: Text(
            storedLanguage['Do you want to Log Out?'] ??
                "Do you want to Log Out?",
            style: t.bodyMedium,
          ),
          actions: [
            MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  storedLanguage['No'] ?? "No",
                  style: t.bodyLarge,
                )),
            MaterialButton(
                onPressed: () async {
                  HiveHelp.remove(Keys.token);
                  Get.offAllNamed(RoutesName.loginScreen);
                },
                child: Text(
                  storedLanguage['Yes'] ?? "Yes",
                  style: t.bodyLarge,
                )),
          ],
        );
      },
    );
  }
}
