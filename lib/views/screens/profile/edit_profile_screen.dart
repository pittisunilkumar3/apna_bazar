import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:listplace/config/dimensions.dart';
import 'package:listplace/themes/themes.dart';
import 'package:listplace/views/widgets/app_button.dart';
import 'package:listplace/views/widgets/custom_appbar.dart';
import 'package:listplace/views/widgets/custom_textfield.dart';
import 'package:listplace/views/widgets/mediaquery_extension.dart';
import 'package:listplace/views/widgets/spacing.dart';
import 'package:listplace/views/widgets/text_theme_extension.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:photo_view/photo_view.dart';
import '../../../config/app_colors.dart';
import '../../../controllers/app_controller.dart';
import '../../../controllers/profile_controller.dart';
import '../../../data/models/language_model.dart' as l;
import '../../../utils/app_constants.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/app_custom_dropdown.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    Get.find<ProfileController>().isLanguageSelected = false;
    return GetBuilder<ProfileController>(builder: (profileController) {
      return GetBuilder<AppController>(builder: (appController) {
        var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
        return Scaffold(
          // appBar: CustomAppBar(
          //   bgColor: Get.isDarkMode
          //       ? AppColors.darkCardColor
          //       : AppColors.mainColorWithOpacity,
          //   isReverseIconBgColor: true,
          //   title: storedLanguage['Edit Profile'] ?? "Edit Profile",
          // ),
          body: RefreshIndicator(
            color: AppColors.mainColor,
            onRefresh: () async {
              await profileController.getProfile();
              await profileController.getLanguageList();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: AppThemes.getDarkBgColor(),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(18.r)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 249.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage("$rootImageDir/login_img.png"),
                            fit: BoxFit.cover,
                          )),
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 60.h),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      icon: Container(
                                        padding: EdgeInsets.all(8.h),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: AppColors.black40,
                                            width: Get.isDarkMode ? .8 : .9,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Image.asset(
                                          "$rootImageDir/back.png",
                                          height: 16.h,
                                          width: 16.h,
                                          color: Get.isDarkMode
                                              ? AppColors.whiteColor
                                              : AppColors.black70,
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "Edit Profile",
                                      style: t.titleSmall?.copyWith(
                                        fontSize: 22.sp,
                                      ),
                                    ),
                                    Text("              "),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                top: -80.h,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      width: 150.h,
                                      height: 150.h,
                                      child: CircularPercentIndicator(
                                        radius: 63.0.r,
                                        lineWidth: 4.h,
                                        percent: 0.57,
                                        center: SizedBox(
                                          height: 0,
                                          width: 0,
                                        ),
                                        backgroundColor: Colors.transparent,
                                        progressColor: AppColors.mainColor,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (profileController.userPhoto != '' &&
                                            !profileController.userPhoto
                                                .contains("default")) {
                                          Get.to(() => Scaffold(
                                              appBar: const CustomAppBar(
                                                  title: "PhotoView"),
                                              body: PhotoView(
                                                imageProvider: NetworkImage(
                                                    Get.find<
                                                            ProfileController>()
                                                        .userPhoto),
                                              )));
                                        } else {
                                          Get.to(() => Scaffold(
                                              appBar: const CustomAppBar(
                                                  title: "PhotoView"),
                                              body: PhotoView(
                                                imageProvider: AssetImage(
                                                    "$rootImageDir/demo_avatar.png"),
                                              )));
                                        }
                                      },
                                      child: Container(
                                        width: 116.h,
                                        height: 116.h,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: AppColors.mainColor
                                                  .withValues(alpha: .005),
                                              width: 7.h,
                                            )),
                                        child: ClipOval(
                                          child: profileController.userPhoto ==
                                                      '' ||
                                                  profileController.userPhoto
                                                      .contains("default")
                                              ? Image.asset(
                                                  "$rootImageDir/profile_pic.webp",
                                                  fit: BoxFit.cover,
                                                )
                                              : CachedNetworkImage(
                                                  imageUrl: Get.find<
                                                          ProfileController>()
                                                      .userPhoto,
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        bottom: 15.h,
                                        right: 15.h,
                                        child: InkResponse(
                                          onTap: () async {
                                            await showbottomsheet(
                                                context, storedLanguage);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(8.h),
                                            decoration: BoxDecoration(
                                              color: AppColors.mainColor,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.camera_alt,
                                              color: AppColors.blackColor,
                                              size: 20.h,
                                            ),
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                              Padding(
                                padding: Dimensions.kDefaultPadding,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    VSpace(80.h),
                                    Text(
                                        storedLanguage['First Name'] ??
                                            "First Name",
                                        style: t.displayMedium),
                                    VSpace(10.h),
                                    CustomTextField(
                                      height: 50.h,
                                      hintext: storedLanguage['First Name'] ??
                                          "First Name",
                                      controller: profileController
                                          .firstNameEditingController,
                                      bgColor: Get.isDarkMode
                                          ? AppColors.darkCardColor
                                          : AppColors.mainColorWithOpacity,
                                    ),
                                    VSpace(24.h),
                                    Text(
                                        storedLanguage['Last Name'] ??
                                            "Last Name",
                                        style: t.displayMedium),
                                    VSpace(10.h),
                                    CustomTextField(
                                      height: 50.h,
                                      hintext: storedLanguage['Last Name'] ??
                                          "Last Name",
                                      controller: profileController
                                          .lastNameEditingController,
                                      bgColor: Get.isDarkMode
                                          ? AppColors.darkCardColor
                                          : AppColors.mainColorWithOpacity,
                                    ),
                                    VSpace(24.h),
                                    Text(
                                        storedLanguage['Username'] ??
                                            "Username",
                                        style: t.displayMedium),
                                    VSpace(10.h),
                                    CustomTextField(
                                      height: 50.h,
                                      hintext: storedLanguage['Username'] ??
                                          "Username",
                                      controller: profileController
                                          .userNameEditingController,
                                      bgColor: Get.isDarkMode
                                          ? AppColors.darkCardColor
                                          : AppColors.mainColorWithOpacity,
                                    ),
                                    VSpace(24.h),
                                    Text(
                                        storedLanguage['Email Address'] ??
                                            "Email Address",
                                        style: t.displayMedium),
                                    VSpace(10.h),
                                    CustomTextField(
                                      height: 50.h,
                                      hintext: storedLanguage[
                                              'Enter Email Address'] ??
                                          "Enter Email Address",
                                      controller: profileController
                                          .emailEditingController,
                                      bgColor: Get.isDarkMode
                                          ? AppColors.darkCardColor
                                          : AppColors.mainColorWithOpacity,
                                    ),
                                    VSpace(24.h),
                                    Text(
                                        storedLanguage['Phone Number'] ??
                                            "Phone Number",
                                        style: t.displayMedium),
                                    VSpace(10.h),
                                    CustomTextField(
                                      height: 50.h,
                                      hintext: storedLanguage['Enter Number'] ??
                                          "Enter Number",
                                      controller: profileController
                                          .phoneNumberEditingController,
                                      keyboardType: TextInputType.phone,
                                      bgColor: Get.isDarkMode
                                          ? AppColors.darkCardColor
                                          : AppColors.mainColorWithOpacity,
                                    ),
                                    VSpace(24.h),
                                    Text(
                                        storedLanguage['Preferred Language'] ??
                                            "Preferred Language",
                                        style: t.displayMedium),
                                    VSpace(10.h),
                                    Container(
                                      height: 50.h,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppThemes
                                                .getSliderInactiveColor()),
                                        borderRadius: Dimensions.kBorderRadius,
                                      ),
                                      child: AppCustomDropDown(
                                        height: 46.h,
                                        width: double.infinity,
                                        items: profileController.languageList
                                            .map((l.Language e) => e.name)
                                            .toList(),
                                        selectedValue: profileController
                                                .languageList.isEmpty
                                            ? null
                                            : profileController
                                                    .selectedLanguageInitialVal ??
                                                profileController
                                                    .selectedLanguage,
                                        onChanged:
                                            profileController.onChangedLanguage,
                                        hint:
                                            storedLanguage['Select Language'] ??
                                                "Select Language",
                                        selectedStyle: t.displayMedium,
                                      ),
                                    ),
                                    VSpace(24.h),
                                    Text(
                                        storedLanguage['Address One'] ??
                                            "Address One",
                                        style: t.displayMedium),
                                    VSpace(10.h),
                                    CustomTextField(
                                      hintext:
                                          storedLanguage['Enter Address One'] ??
                                              "Enter Address One",
                                      controller: profileController
                                          .addressEditingController1,
                                      bgColor: Get.isDarkMode
                                          ? AppColors.darkCardColor
                                          : AppColors.mainColorWithOpacity,
                                    ),
                                    VSpace(24.h),
                                    Text(
                                        storedLanguage['Address Two'] ??
                                            "Address Two",
                                        style: t.displayMedium),
                                    VSpace(10.h),
                                    CustomTextField(
                                      hintext:
                                          storedLanguage['Enter Address Two'] ??
                                              "Enter Address Two",
                                      controller: profileController
                                          .addressEditingController2,
                                      bgColor: Get.isDarkMode
                                          ? AppColors.darkCardColor
                                          : AppColors.mainColorWithOpacity,
                                    ),
                                    VSpace(24.h),
                                    Material(
                                      color: Colors.transparent,
                                      child: AppButton(
                                        isLoading:
                                            profileController.isUpdateProfile
                                                ? true
                                                : false,
                                        onTap: profileController.isUpdateProfile
                                            ? null
                                            : () async {
                                                Helpers.hideKeyboard();
                                                if (profileController
                                                        .isLanguageSelected ==
                                                    true) {
                                                  await appController
                                                      .getLanguageListBuyId(
                                                          id: profileController
                                                              .selectedLanguageId);
                                                  await profileController
                                                      .validateEditProfile(
                                                          context);
                                                } else if (profileController
                                                        .isLanguageSelected ==
                                                    false) {
                                                  await profileController
                                                      .validateEditProfile(
                                                          context);
                                                }
                                              },
                                        text:
                                            storedLanguage['Update Profile'] ??
                                                'Update Profile',
                                      ),
                                    ),
                                    VSpace(50.h),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
    });
  }

  Future<dynamic> showbottomsheet(BuildContext context, storedLanguage) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return GetBuilder<AppController>(builder: (_) {
          return GetBuilder<ProfileController>(builder: (profileController) {
            return SizedBox(
              height: context.mQuery.height * 0.2,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 10.h),
                  GestureDetector(
                    onTap: () async {
                      Get.back();
                      profileController.pickImage(ImageSource.camera);
                    },
                    child: Container(
                      height: 80.h,
                      width: 150.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppThemes.getDarkBgColor(),
                          border: Border.all(
                              color: AppColors.mainColor, width: .2)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 35.h,
                            color: Get.isDarkMode
                                ? AppColors.whiteColor
                                : AppColors.black50,
                          ),
                          Text(
                            storedLanguage['Pick from Camera'] ??
                                'Pick from Camera',
                            style: context.t.bodySmall?.copyWith(
                                color: AppThemes.getIconBlackColor()),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  GestureDetector(
                    onTap: () async {
                      Get.back();
                      profileController.pickImage(ImageSource.gallery);
                    },
                    child: Container(
                      height: 80.h,
                      width: 150.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppThemes.getDarkBgColor(),
                          border: Border.all(
                              color: AppColors.mainColor, width: .2)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera,
                            size: 35.h,
                            color: Get.isDarkMode
                                ? AppColors.whiteColor
                                : AppColors.black50,
                          ),
                          Text(
                            storedLanguage['Pick from Gallery'] ??
                                'Pick from Gallery',
                            style: context.t.bodySmall?.copyWith(
                                color: AppThemes.getIconBlackColor()),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
        });
      },
    );
  }
}
