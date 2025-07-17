import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:listplace/config/dimensions.dart';
import 'package:listplace/controllers/bindings/controller_index.dart';
import 'package:listplace/themes/themes.dart';
import 'package:listplace/utils/app_constants.dart';
import 'package:listplace/utils/services/helpers.dart';
import 'package:listplace/views/widgets/custom_appbar.dart';
import 'package:listplace/views/widgets/custom_textfield.dart';
import 'package:listplace/views/widgets/text_theme_extension.dart';
import 'package:listplace/views/widgets/spacing.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../config/app_colors.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/app_button.dart';

class TwoFaVerificationScreen extends StatelessWidget {
  const TwoFaVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<VerificationController>(
        builder: (verificationController) {
      return Scaffold(
        appBar: CustomAppBar(
          title: storedLanguage['Two Step Security'] ?? "Two Step Security",
        ),
        body: RefreshIndicator(
          color: AppColors.mainColor,
          onRefresh: () async {
            verificationController.getTwoFa();
          },
          child: Column(
            children: [
              VSpace(20.h),
              Expanded(
                child: Container(
                  padding: Dimensions.kDefaultPadding,
                  width: double.maxFinite,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        VSpace(24.h),
                        Get.isDarkMode
                            ? Image.asset(
                                "$rootImageDir/two_fa_image_dark.png",
                                height: 148.h,
                                width: 148.h,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 148.h,
                                height: 148.h,
                                decoration: BoxDecoration(
                                    color: AppColors.fillColor2,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: AppColors.black10, width: .5)),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Image.asset(
                                            "$rootImageDir/twofa_triangle.png",
                                            width: 65.w,
                                            height: 80.h,
                                            color: AppColors.mainColor,
                                            fit: BoxFit.fitHeight),
                                        Positioned(
                                          bottom: 25.h,
                                          child: Container(
                                            width: 32.w,
                                            height: 32.h,
                                            padding: EdgeInsets.all(3.h),
                                            decoration: BoxDecoration(
                                              color: AppColors.blackColor,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: AppColors.whiteColor,
                                                width: 3.h,
                                              ),
                                            ),
                                            child: Image.asset(
                                                "$rootImageDir/twofa_user.png",
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                        right: 30.w,
                                        top: 62.h,
                                        child: Container(
                                          width: 9.h,
                                          height: 9.h,
                                          decoration: BoxDecoration(
                                            color: AppColors.mainColor,
                                            shape: BoxShape.circle,
                                          ),
                                        )),
                                    Positioned(
                                        left: 50.w,
                                        bottom: 25.h,
                                        child: Container(
                                          width: 9.h,
                                          height: 9.h,
                                          decoration: BoxDecoration(
                                            color: AppColors.mainColor,
                                            shape: BoxShape.circle,
                                          ),
                                        )),
                                    Positioned(
                                        left: 40.w,
                                        top: 35.h,
                                        child: Container(
                                          width: 9.h,
                                          height: 9.h,
                                          decoration: BoxDecoration(
                                            color: AppColors.whiteColor,
                                            shape: BoxShape.circle,
                                          ),
                                        )),
                                    Positioned(
                                        left: 40.w,
                                        top: 35.h,
                                        child: Container(
                                          width: 9.h,
                                          height: 9.h,
                                          decoration: BoxDecoration(
                                            color: AppColors.whiteColor,
                                            shape: BoxShape.circle,
                                          ),
                                        )),
                                    Positioned( 
                                        right: 43.w,
                                        bottom: 35.h,
                                        child: Image.asset(
                                            "$rootImageDir/question_mark.png",
                                            width: 23.h,
                                            height: 23.h,
                                            fit: BoxFit.fitHeight)),
                                  ],
                                ),
                              ),
                        VSpace(24.h),
                        Text(
                          storedLanguage['Two Factor Authenticator'] ??
                              "Two Factor Authenticator",
                          style: context.t.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w400),
                        ),
                        VSpace(16.h),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 43.h,
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 16.h),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: Get.isDarkMode
                                            ? AppColors.darkCardColorDeep
                                            : AppColors.black10),
                                    top: BorderSide(
                                        color: Get.isDarkMode
                                            ? AppColors.darkCardColorDeep
                                            : AppColors.black10),
                                    left: BorderSide(
                                        color: Get.isDarkMode
                                            ? AppColors.darkCardColorDeep
                                            : AppColors.black10),
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(6.r),
                                    bottomLeft: Radius.circular(6.r),
                                  ),
                                ),
                                child: Text(
                                  "${verificationController.secretKey}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: context.t.bodySmall?.copyWith(
                                      color: Get.isDarkMode
                                          ? AppColors.whiteColor
                                          : AppColors.black50),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                Clipboard.setData(new ClipboardData(
                                    text:
                                        "${verificationController.secretKey}"));
                                Helpers.showSnackBar(
                                    title: "Success",
                                    msg: "Copied Successfully",
                                    bgColor: AppColors.greenColor);
                              },
                              child: Container(
                                height: 44.h,
                                width: 41.w,
                                padding: EdgeInsets.all(12.h),
                                decoration: BoxDecoration(
                                  color: AppColors.mainColor,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(6.r),
                                    bottomRight: Radius.circular(6.r),
                                  ),
                                ),
                                child: Image.asset(
                                  "$rootImageDir/copy.png",
                                  color: AppColors.blackColor,
                                ),
                              ),
                            ),
                          ],
                        ), 
                        VSpace(32.h),
                        Container(
                          height: 260.h,
                          width: 220.h,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.mainColor),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      "$rootImageDir/frame.png",
                                      color: AppColors.mainColor,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: QrImageView(
                                      data:
                                          '${verificationController.qrCodeUrl}',
                                      version: QrVersions.auto,
                                      size: 200.h,
                                      dataModuleStyle: QrDataModuleStyle(
                                          dataModuleShape:
                                              QrDataModuleShape.square,
                                          color: AppThemes.getIconBlackColor()),
                                      eyeStyle: QrEyeStyle(
                                          color: AppThemes.getIconBlackColor(),
                                          eyeShape: QrEyeShape.square),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Stack(
                                alignment: Alignment.topCenter,
                                clipBehavior: Clip.none,
                                children: [
                                  Transform.rotate(
                                    angle: .85,
                                    child: Container(
                                      height: 20.h,
                                      width: 35.h,
                                      decoration: BoxDecoration(
                                        color: AppColors.mainColor,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 30.h,
                                    width: 220.h,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: AppColors.mainColor,
                                      borderRadius: BorderRadius.vertical(
                                          bottom: Radius.circular(8.r)),
                                    ),
                                    child: Text(
                                      "Scane Here",
                                      style: context.t.displayMedium?.copyWith(
                                          color: AppColors.blackColor),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        VSpace(32.h),
                        SizedBox(
                          width: double.maxFinite,
                          height: Dimensions.buttonHeight,
                          child: MaterialButton(
                            color: AppColors.mainColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: Dimensions.kBorderRadius,
                            ),
                            onPressed: () {
                              Get.defaultDialog(
                                  barrierDismissible: false,
                                  titlePadding: EdgeInsets.only(top: 10.h),
                                  titleStyle: context.t.bodyLarge,
                                  title: storedLanguage['2 Step Security'] ??
                                      '2 Step Security',
                                  content: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          verificationController
                                                  .isTwoFactorEnabled
                                              ? storedLanguage['Password'] ??
                                                  "Password"
                                              : storedLanguage[
                                                      'Verify your OTP'] ??
                                                  'Verify your OTP',
                                          style: context.t.bodySmall,
                                        ),
                                        SizedBox(height: 20.h),
                                        CustomTextField(
                                            isBorderColor: false,
                                            fillColor: Get.isDarkMode
                                                ? AppColors.darkBgColor
                                                : AppColors.fillColor,
                                            keyboardType: verificationController
                                                    .isTwoFactorEnabled
                                                ? TextInputType.text
                                                : TextInputType.number,
                                            inputFormatters:
                                                verificationController
                                                        .isTwoFactorEnabled
                                                    ? []
                                                    : <TextInputFormatter>[
                                                        FilteringTextInputFormatter
                                                            .digitsOnly
                                                      ],
                                            contentPadding:
                                                EdgeInsets.only(left: 10.w),
                                            hintext: verificationController
                                                    .isTwoFactorEnabled
                                                ? storedLanguage[
                                                        'Enter your password'] ??
                                                    "Enter your password"
                                                : storedLanguage[
                                                        'Enter Code'] ??
                                                    "Enter Code",
                                            controller: verificationController
                                                .TwoFAEditingController),
                                      ],
                                    ),
                                  ),
                                  cancel: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors
                                          .redColor, // Customize the button color
                                    ),
                                    onPressed: () {
                                      Get.back(); // Close the dialog
                                    },
                                    child: Text(
                                      storedLanguage['Cancel'] ?? 'Cancel',
                                      style: context.t.bodySmall?.copyWith(
                                          color: AppColors.whiteColor),
                                    ),
                                  ),
                                  confirm: GetBuilder<VerificationController>(
                                      builder: (verificationController) {
                                    return ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors
                                              .mainColor // Customize the button color
                                          ),
                                      onPressed:
                                          verificationController.isVerifying
                                              ? null
                                              : () async {
                                                  if (verificationController
                                                      .TwoFAEditingController
                                                      .text
                                                      .isNotEmpty) {
                                                    if (verificationController
                                                            .isTwoFactorEnabled ==
                                                        false) {
                                                      await verificationController
                                                          .enableTwoFa(
                                                        context: context,
                                                        fields: {
                                                          "code":
                                                              "${verificationController.TwoFAEditingController.text}",
                                                          "key":
                                                              verificationController
                                                                  .secretKey
                                                                  .toString(),
                                                        },
                                                      );
                                                    } else {
                                                      await verificationController
                                                          .disableTwoFa(
                                                        context: context,
                                                        fields: {
                                                          "password":
                                                              "${verificationController.TwoFAEditingController.text}",
                                                        },
                                                      );
                                                    }
                                                  }
                                                },
                                      child: Text(
                                        verificationController.isVerifying
                                            ? storedLanguage['Verifying...'] ??
                                                'Verifying...'
                                            : storedLanguage['Verify'] ??
                                                'Verify',
                                        style: context.t.bodySmall?.copyWith(
                                            color: AppColors.blackColor),
                                      ),
                                    );
                                  }));
                            },
                            child: Center(
                              child: Text(
                                verificationController.isTwoFactorEnabled
                                    ? storedLanguage[
                                            'Disable Two Factor Authenticator'] ??
                                        "Disable Two Factor Authenticator"
                                    : storedLanguage[
                                            'Enable Two Factor Authenticator'] ??
                                        "Enable Two Factor Authenticator",
                                style: context.t.bodyMedium
                                    ?.copyWith(color: AppColors.blackColor),
                              ),
                            ),
                          ),
                        ),
                        VSpace(32.h),
                        Text(
                            storedLanguage['Google Authenticator'] ??
                                "Google Authenticator",
                            style: context.t.bodyLarge),
                        VSpace(8.h),
                        Divider(
                            color: Get.isDarkMode
                                ? AppColors.darkCardColorDeep
                                : AppColors.black10),
                        VSpace(12.h),
                        Text(
                          "Use Google Authenticator to Scan The QR code or use the code",
                          style: context.t.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w400),
                        ),
                        VSpace(12.h),
                        Text(
                          "Google Authenticator is a multifactor app for mobile devices. It generates timed codes used during the Two-step verification process. To use Google Authenticator, install the Google Authenticator application on your mobile device.",
                          style: context.t.displayMedium?.copyWith(
                              color: Get.isDarkMode
                                  ? AppColors.black20
                                  : AppColors.black50),
                        ),
                        VSpace(30.h),
                        Material(
                          color: Colors.transparent,
                          child: AppButton(
                            text: "Download App",
                            onTap: () async {
                              var url = Uri.parse(
                                  "https://play.google.com/store/search?q=google+authenticator&c=apps&hl=en&gl=US");
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                          ),
                        ),
                        VSpace(50.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
