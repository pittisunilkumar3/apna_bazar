import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:listplace/config/dimensions.dart';
import 'package:listplace/controllers/auth_controller.dart';
import 'package:listplace/themes/themes.dart';
import 'package:listplace/utils/app_constants.dart';
import 'package:listplace/utils/services/helpers.dart';
import 'package:listplace/views/widgets/appDialog.dart';
import 'package:listplace/views/widgets/app_button.dart';
import 'package:listplace/views/widgets/app_textfield.dart';
import 'package:listplace/views/widgets/mediaquery_extension.dart';
import 'package:listplace/views/widgets/spacing.dart';
import '../../../config/app_colors.dart';
import '../../../routes/routes_name.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isRemember = false;
  @override
  Widget build(BuildContext context) {
    AuthController controller = Get.find<AuthController>();
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    //--------------REMEMBER ME----------------
    if (HiveHelp.read(Keys.userName) != null &&
        HiveHelp.read(Keys.userPass) != null &&
        HiveHelp.read(Keys.isRemember) != null) {
      if (HiveHelp.read(Keys.isRemember) == true) {
        controller.userNameEditingController.text =
            HiveHelp.read(Keys.userName);
        controller.signInPassEditingController.text =
            HiveHelp.read(Keys.userPass);
        controller.userNameVal = HiveHelp.read(Keys.userName);
        controller.singInPassVal = HiveHelp.read(Keys.userPass);
      }
    }
    if (HiveHelp.read(Keys.isRemember) != null) {
      controller.isRemember = HiveHelp.read(Keys.isRemember);
    }
    return GetBuilder<AuthController>(builder: (_) {
      return Scaffold(
        body: Column(
          children: [
            Image.asset(
              "$rootImageDir/login_img.png",
              height: 249.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            VSpace(38.h),
            SizedBox(
              height: context.mQuery.height * .6,
              child: SingleChildScrollView(
                child: Padding(
                  padding: Dimensions.kDefaultPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        hintext: storedLanguage['Username or Email'] ??
                            "Username or Email",
                        isPrefixIcon: true,
                        prefixIcon: 'person',
                        controller: controller.userNameEditingController,
                        onChanged: (v) {
                          controller.userNameVal = v;
                          controller.update();
                        },
                      ),
                      VSpace(32.h),
                      CustomTextField(
                        hintext: storedLanguage['Password'] ?? "Password",
                        isPrefixIcon: true,
                        isSuffixIcon: true,
                        obsCureText: controller.isNewPassShow ? true : false,
                        prefixIcon: 'lock',
                        suffixIcon: controller.isNewPassShow ? 'hide' : 'show',
                        controller: controller.signInPassEditingController,
                        onChanged: (v) {
                          controller.singInPassVal = v;
                          controller.update();
                        },
                        onSuffixPressed: () {
                          controller.isNewPassShow = !controller.isNewPassShow;
                          controller.update();
                        },
                      ),
                      VSpace(29.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isRemember = !isRemember;
                              });
                            },
                            child: Row(
                              children: [
                                Transform.scale(
                                  scale: .82,
                                  child: Checkbox(
                                      checkColor: AppColors.blackColor,
                                      activeColor: AppColors.mainColor,
                                      visualDensity: const VisualDensity(
                                        horizontal:
                                            -4.0, // Adjust the horizontal padding
                                        vertical:
                                            -4.0, // Adjust the vertical padding
                                      ),
                                      side: BorderSide(
                                          color: AppThemes.getHintColor()),
                                      value: controller.isRemember,
                                      onChanged: (v) {
                                        controller.isRemember = v!;
                                        HiveHelp.write(Keys.isRemember, v);
                                        controller.update();
                                      }),
                                ),
                                HSpace(5.w),
                                Text(
                                  storedLanguage['Remember me'] ??
                                      "Remember me",
                                  style: t.displayMedium?.copyWith(
                                      color: AppThemes.getHintColor()),
                                )
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              buildForgotPassDialog(context, t, controller);
                            },
                            child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8.h),
                                child: Text(
                                  storedLanguage['Forgot Your Password?'] ??
                                      "Forgot Your Password?",
                                  style: t.displayMedium,
                                )),
                          )
                        ],
                      ),
                      VSpace(48.h),
                      Material(
                        color: Colors.transparent,
                        child: AppButton(
                          text: storedLanguage['Sign In'] ?? "Sign In",
                          style: t.bodyLarge?.copyWith(
                              fontSize: 20.sp, color: AppColors.blackColor),
                          isLoading: controller.isLoading ? true : false,
                          bgColor: controller.userNameVal.isEmpty ||
                                  controller.singInPassVal.isEmpty
                              ? AppThemes.getInactiveColor()
                              : AppColors.mainColor,
                          onTap: controller.userNameVal.isEmpty ||
                                  controller.singInPassVal.isEmpty
                              ? null
                              : controller.isLoading
                                  ? null
                                  : () async {
                                      Helpers.hideKeyboard();
                                      await controller.login();
                                    },
                        ),
                      ),
                      VSpace(32.h),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          storedLanguage["Don't have and account?"] ??
                              "Don’t have an account?",
                          style: t.displayMedium
                              ?.copyWith(color: AppThemes.getHintColor()),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {
                            Get.toNamed(RoutesName.signUpScreen);
                          },
                          child: Text(
                            storedLanguage['Create account'] ??
                                "Create account",
                            style: t.displayMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  buildForgotPassDialog(
      BuildContext context, TextTheme t, AuthController controller) {
    appDialog(
      context: context,
      title: Align(
        alignment: Alignment.center,
        child: Text(
          "Forgot Password",
          style: t.titleLarge,
        ),
      ),
      content: GetBuilder<AuthController>(builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                "Please enter your email address to\nreceive a verification code",
                textAlign: TextAlign.center,
                style: t.displayMedium
                    ?.copyWith(color: AppThemes.getGreyColor(), height: 1.7),
              ),
            ),
            VSpace(32.h),
            CustomTextField(
                isPrefixIcon: true,
                prefixIcon: 'email',
                controller: controller.forgotPassEmailEditingController,
                onChanged: (v) {
                  controller.forgotPassEmailVal = v.contains('@') ? v : "";
                  controller.update();
                },
                hintext: "Enter your Email"),
            VSpace(32.h),
            AppButton(
              isLoading: controller.isPassReset ? true : false,
              bgColor: controller.forgotPassEmailVal.isEmpty ||
                      controller.isPassReset
                  ? AppThemes.getInactiveColor()
                  : AppColors.mainColor,
              onTap: controller.forgotPassEmailVal.isEmpty ||
                      controller.isPassReset
                  ? null
                  : () async {
                      Helpers.hideKeyboard();
                      await controller.forgotPass(
                          context: context, t: t, controller: controller);
                    },
            ),
          ],
        );
      }),
    );
  }
}

buildNewPassDialog(
    BuildContext context, TextTheme t, AuthController controller) {
  appDialog(
    context: context,
    title: Align(
      alignment: Alignment.center,
      child: Text(
        "Create New Password",
        style: t.titleLarge,
      ),
    ),
    content: GetBuilder<AuthController>(builder: (_) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
              alignment: Alignment.center,
              child: Text(
                "Set the new password for your account so that you can login and access all the features.",
                textAlign: TextAlign.center,
                style: t.displayMedium
                    ?.copyWith(color: AppThemes.getGreyColor(), height: 1.7),
              )),
          VSpace(32.h),
          AppTextField(
              border: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: AppThemes.getSliderInactiveColor())),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.mainColor)),
              prefixIcon: Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: Image.asset(
                  "$rootImageDir/lock.png",
                  height: 16.h,
                  width: 16.h,
                  color: AppThemes.getGreyColor(),
                ),
              ),
              suffixIcon: SizedBox(
                height: 25.h,
                child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      controller.forgotPassNewPassObscure();
                    },
                    constraints: const BoxConstraints(),
                    icon: Image.asset(
                      controller.isNewPassShow
                          ? "$rootImageDir/hide.png"
                          : "$rootImageDir/show.png",
                      height: 20.h,
                      width: 20.w,
                    )),
              ),
              controller: controller.forgotPassNewPassEditingController,
              onChanged: (v) {
                controller.forgotPassNewPassVal = v;
                controller.update();
              },
              obscureText: controller.isNewPassShow ? true : false,
              hinText: "New Password"),
          VSpace(32.h),
          AppTextField(
              border: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: AppThemes.getSliderInactiveColor())),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.mainColor)),
              prefixIcon: Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: Image.asset(
                  "$rootImageDir/lock.png",
                  height: 16.h,
                  width: 16.h,
                  color: AppThemes.getGreyColor(),
                ),
              ),
              suffixIcon: SizedBox(
                height: 25.h,
                child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      controller.forgotPassNewPassObscure();
                    },
                    constraints: const BoxConstraints(),
                    icon: Image.asset(
                      controller.isNewPassShow
                          ? "$rootImageDir/hide.png"
                          : "$rootImageDir/show.png",
                      height: 20.h,
                      width: 20.w,
                    )),
              ),
              controller: controller.forgotPassConfirmPassEditingController,
              onChanged: (v) {
                controller.forgotPassConfirmPassVal = v;
                controller.update();
              },
              obscureText: controller.isConfirmPassShow ? true : false,
              hinText: "Confirm Password"),
          VSpace(32.h),
          AppButton(
            isLoading: controller.isPassReset ? true : false,
            bgColor: controller.forgotPassNewPassVal.isEmpty ||
                    controller.forgotPassConfirmPassVal.isEmpty
                ? AppThemes.getInactiveColor()
                : AppColors.mainColor,
            onTap: controller.forgotPassNewPassVal.isEmpty ||
                    controller.forgotPassConfirmPassVal.isEmpty
                ? null
                : () async {
                    Helpers.hideKeyboard();
                    await controller.updatePass();
                  },
          ),
        ],
      );
    }),
  );
}

buildOtpDialog(BuildContext context, TextTheme t, AuthController controller) {
  return appDialog(
      context: context,
      title: Align(
        alignment: Alignment.center,
        child: Text(
          "Enter Your OTP Code",
          style: t.titleLarge,
        ),
      ),
      content: GetBuilder<AuthController>(builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
                alignment: Alignment.center,
                child: Text(
                  "Enter the 5 digits code that you\nreceived on your email",
                  textAlign: TextAlign.center,
                  style: t.displayMedium
                      ?.copyWith(color: AppThemes.getGreyColor(), height: 1.7),
                )),
            VSpace(32.h),
            Padding(
              padding: Dimensions.kDefaultPadding / 2,
              child: Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppThemes.getSliderInactiveColor())),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.mainColor)),
                      controller: controller.otpEditingController1,
                      onChanged: (v) {
                        controller.otpVal1 = v;
                        controller.update();
                        if (v.length == 1) {
                          FocusManager.instance.primaryFocus?.nextFocus();
                        }
                      },
                      keyboardType: TextInputType.number,
                      contentPadding: EdgeInsets.zero,
                      textAlign: TextAlign.center,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(1),
                      ],
                    ),
                  ),
                  HSpace(20.w),
                  Expanded(
                    child: AppTextField(
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppThemes.getSliderInactiveColor())),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.mainColor)),
                      controller: controller.otpEditingController2,
                      onChanged: (v) {
                        controller.otpVal2 = v;
                        controller.update();
                        if (v.length == 1) {
                          FocusManager.instance.primaryFocus?.nextFocus();
                        }
                      },
                      keyboardType: TextInputType.number,
                      contentPadding: EdgeInsets.zero,
                      textAlign: TextAlign.center,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(1),
                      ],
                    ),
                  ),
                  HSpace(20.w),
                  Expanded(
                    child: AppTextField(
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppThemes.getSliderInactiveColor())),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.mainColor)),
                      controller: controller.otpEditingController3,
                      onChanged: (v) {
                        controller.otpVal3 = v;
                        controller.update();
                        if (v.length == 1) {
                          FocusManager.instance.primaryFocus?.nextFocus();
                        }
                      },
                      keyboardType: TextInputType.number,
                      contentPadding: EdgeInsets.zero,
                      textAlign: TextAlign.center,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(1),
                      ],
                    ),
                  ),
                  HSpace(20.w),
                  Expanded(
                    child: AppTextField(
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppThemes.getSliderInactiveColor())),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.mainColor)),
                      controller: controller.otpEditingController4,
                      onChanged: (v) {
                        controller.otpVal4 = v;
                        controller.update();
                        if (v.length == 1) {
                          FocusManager.instance.primaryFocus?.nextFocus();
                        }
                      },
                      keyboardType: TextInputType.number,
                      contentPadding: EdgeInsets.zero,
                      textAlign: TextAlign.center,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(1),
                      ],
                    ),
                  ),
                  HSpace(20.w),
                  Expanded(
                    child: AppTextField(
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppThemes.getSliderInactiveColor())),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.mainColor)),
                      controller: controller.otpEditingController5,
                      onChanged: (v) {
                        controller.otpVal5 = v;
                        controller.update();
                        if (v.length == 1) {
                          Helpers.hideKeyboard();
                        }
                      },
                      keyboardType: TextInputType.number,
                      contentPadding: EdgeInsets.zero,
                      textAlign: TextAlign.center,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(1),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            VSpace(32.h),
            AppButton(
              isLoading: controller.isPassReset ? true : false,
              bgColor: controller.otpVal1.isEmpty ||
                      controller.otpVal2.isEmpty ||
                      controller.otpVal3.isEmpty ||
                      controller.otpVal4.isEmpty ||
                      controller.otpVal5.isEmpty ||
                      controller.isPassReset
                  ? AppThemes.getInactiveColor()
                  : AppColors.mainColor,
              onTap: controller.otpVal1.isEmpty ||
                      controller.otpVal2.isEmpty ||
                      controller.otpVal3.isEmpty ||
                      controller.otpVal4.isEmpty ||
                      controller.otpVal5.isEmpty ||
                      controller.isPassReset
                  ? null
                  : () async {
                      Helpers.hideKeyboard();
                      await controller.geCode(
                          context: context, t: t, controller: controller);
                    },
            ),
          ],
        );
      }));
}
