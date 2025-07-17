import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:listplace/views/widgets/text_theme_extension.dart';
import '../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../controllers/verification_controller.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/spacing.dart';

class IdentityVerificationScreen extends StatefulWidget {
  final String? verificationType;
  final String? id;
  final int? verifyStatus;
  final bool? isSubmitted;
  const IdentityVerificationScreen(
      {super.key,
      this.id = "",
      this.verificationType = "",
      this.verifyStatus = 0,
      this.isSubmitted = false});

  @override
  State<IdentityVerificationScreen> createState() =>
      _IdentityVerificationScreenState();
}

class _IdentityVerificationScreenState
    extends State<IdentityVerificationScreen> {
  late ConfettiController _centerController;

  @override
  void initState() {
    super.initState();
    _centerController =
        ConfettiController(duration: const Duration(seconds: 15));
    _centerController.play();
  }

  @override
  void dispose() {
    _centerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<VerificationController>(builder: (verifyCtrl) {
      return Scaffold(
        appBar: CustomAppBar(
          title: "${widget.verificationType}",
        ),
        body: RefreshIndicator(
          color: AppColors.mainColor,
          onRefresh: () async {},
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: verifyCtrl.isLoading
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                if (widget.verifyStatus == 1 && widget.isSubmitted == true)
                  Align(
                    alignment: Alignment.center,
                    child: ConfettiWidget(
                      confettiController: _centerController,
                      blastDirection: pi / 2,
                      maxBlastForce: 5,
                      minBlastForce: 1,
                      emissionFrequency: 0.03,
                      numberOfParticles: 10,
                      gravity: 0,
                    ),
                  ),
                if ((widget.verifyStatus == 1 && widget.isSubmitted == true) ||
                    (widget.verifyStatus == 0 && widget.isSubmitted == true))
                  Container(
                    margin: EdgeInsets.only(top: 100.h),
                    height: 160.h,
                    width: 160.h,
                    padding: EdgeInsets.all(25.h),
                    decoration: BoxDecoration(
                      color: widget.verifyStatus == 1
                          ? AppColors.greenColor.withValues(alpha: .2)
                          : AppColors.pendingColor.withValues(alpha: .2),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      widget.verifyStatus == 1
                          ? '$rootImageDir/success.gif'
                          : '$rootImageDir/pending.gif',
                      fit: BoxFit.fill,
                    ),
                  ),
                if ((widget.verifyStatus == 1 && widget.isSubmitted == true) ||
                    (widget.verifyStatus == 0 && widget.isSubmitted == true))
                  VSpace(20.h),
                if ((widget.verifyStatus == 1 && widget.isSubmitted == true) ||
                    (widget.verifyStatus == 0 && widget.isSubmitted == true))
                  Center(
                    child: Text(
                        widget.verifyStatus == 1
                            ? "Your ${widget.verificationType} has been approved."
                            : "Your ${widget.verificationType} has been pending.",
                        textAlign: TextAlign.center,
                        style: context.t.displayMedium?.copyWith(
                            color: widget.verifyStatus == 1
                                ? AppColors.greenColor
                                : AppColors.pendingColor)),
                  ),
                if (widget.verifyStatus == 2 ||
                    (widget.verifyStatus == 0 && widget.isSubmitted == false))
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                    child: Form(
                      key: verifyCtrl.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          if (verifyCtrl.filteredList.isNotEmpty) ...[
                            VSpace(30.h),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: verifyCtrl.filteredList.length,
                              itemBuilder: (context, index) {
                                final dynamicField = verifyCtrl.filteredList[index];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (dynamicField.type == "file")
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                dynamicField.fieldLevel!,
                                                style: context.t.displayMedium,
                                              ),
                                              dynamicField.validation ==
                                                      'required'
                                                  ? const SizedBox()
                                                  : Text(
                                                      " ${storedLanguage['(Optional)'] ?? "(Optional)"}",
                                                      style: context
                                                          .t.displayMedium,
                                                    ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8.h,
                                          ),
                                          Container(
                                            height: 45.5,
                                            width: double.maxFinite,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.w,
                                                vertical: 10.h),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  Dimensions.kBorderRadius,
                                              border: Border.all(
                                                  color: verifyCtrl.fileColorOfDField ==
                                                          AppColors.redColor
                                                      ? verifyCtrl.fileColorOfDField
                                                      : AppThemes
                                                          .getSliderInactiveColor(),
                                                  width: 1),
                                            ),
                                            child: Row(
                                              children: [
                                                HSpace(12.w),
                                                Text(
                                                  verifyCtrl.imagePickerResults[
                                                              dynamicField
                                                                  .fieldName] !=
                                                          null
                                                      ? storedLanguage[
                                                              '1 File selected'] ??
                                                          "1 File selected"
                                                      : storedLanguage[
                                                              'No File selected'] ??
                                                          "No File selected",
                                                  style: context.t.bodySmall?.copyWith(
                                                      color: verifyCtrl.imagePickerResults[
                                                                  dynamicField
                                                                      .fieldName] !=
                                                              null
                                                          ? AppColors.greenColor
                                                          : AppColors.black60),
                                                ),
                                                const Spacer(),
                                                Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    onTap: () async {
                                                      Helpers.hideKeyboard();

                                                      await verifyCtrl.pickFile(
                                                          dynamicField
                                                              .fieldName!);
                                                    },
                                                    borderRadius: Dimensions
                                                        .kBorderRadius,
                                                    child: Ink(
                                                      width: 113.w,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            AppColors.mainColor,
                                                        borderRadius: Dimensions
                                                                .kBorderRadius /
                                                            1.7,
                                                        border: Border.all(
                                                            color: AppColors
                                                                .mainColor,
                                                            width: .2),
                                                      ),
                                                      child: Center(
                                                          child: Text(
                                                              storedLanguage[
                                                                      'Choose File'] ??
                                                                  'Choose File',
                                                              style: context
                                                                  .t.bodySmall
                                                                  ?.copyWith(
                                                                      color: AppColors
                                                                          .blackColor))),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 16.h,
                                          ),
                                        ],
                                      ),
                                    if (dynamicField.type == "text")
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                dynamicField.fieldLevel!,
                                                style: context.t.displayMedium,
                                              ),
                                              dynamicField.validation ==
                                                      'required'
                                                  ? const SizedBox()
                                                  : Text(
                                                      " ${storedLanguage['(Optional)'] ?? "(Optional)"}",
                                                      style: context
                                                          .t.displayMedium,
                                                    ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8.h,
                                          ),
                                          TextFormField(
                                            validator: (value) {
                                              // Perform validation based on the 'validation' property
                                              if (dynamicField.validation ==
                                                      "required" &&
                                                  value!.isEmpty) {
                                                return storedLanguage[
                                                        'Field is required'] ??
                                                    "Field is required";
                                              }
                                              return null;
                                            },
                                            onChanged: (v) {
                                              verifyCtrl
                                                  .textEditingControllerMap[
                                                      dynamicField.fieldName]!
                                                  .text = v;
                                            },
                                            controller:
                                                verifyCtrl.textEditingControllerMap[
                                                    dynamicField.fieldName],
                                            keyboardType: dynamicField
                                                    .fieldLevel
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains("number")
                                                ? TextInputType.number
                                                : TextInputType.text,
                                            inputFormatters: dynamicField
                                                    .fieldLevel
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains("number")
                                                ? <TextInputFormatter>[
                                                    FilteringTextInputFormatter
                                                        .digitsOnly,
                                                  ]
                                                : [],
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 0,
                                                      horizontal: 16),
                                              filled:
                                                  true, // Fill the background with color
                                              hintStyle: TextStyle(
                                                color: AppColors
                                                    .textFieldHintColor,
                                              ),
                                              fillColor: Colors
                                                  .transparent, // Background color
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: AppThemes
                                                      .getSliderInactiveColor(),
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    Dimensions.kBorderRadius,
                                              ),

                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    Dimensions.kBorderRadius,
                                                borderSide: BorderSide(
                                                    color: AppColors.mainColor),
                                              ),
                                            ),
                                            style: context.t.displayMedium,
                                          ),
                                          SizedBox(
                                            height: 16.h,
                                          ),
                                        ],
                                      ),
                                    if (dynamicField.type == "email")
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                dynamicField.fieldLevel!,
                                                style: context.t.displayMedium,
                                              ),
                                              dynamicField.validation ==
                                                      'required'
                                                  ? const SizedBox()
                                                  : Text(
                                                      " ${storedLanguage['(Optional)'] ?? "(Optional)"}",
                                                      style: context
                                                          .t.displayMedium,
                                                    ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8.h,
                                          ),
                                          TextFormField(
                                            validator: (value) {
                                              // Perform validation based on the 'validation' property
                                              if (dynamicField.validation ==
                                                      "required" &&
                                                  value!.isEmpty) {
                                                return storedLanguage[
                                                        'Field is required'] ??
                                                    "Field is required";
                                              }
                                              return null;
                                            },
                                            onChanged: (v) {
                                              verifyCtrl
                                                  .textEditingControllerMap[
                                                      dynamicField.fieldName]!
                                                  .text = v;
                                            },
                                            controller:
                                                verifyCtrl.textEditingControllerMap[
                                                    dynamicField.fieldName],
                                            keyboardType: dynamicField
                                                    .fieldLevel
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains("number")
                                                ? TextInputType.number
                                                : TextInputType.text,
                                            inputFormatters: dynamicField
                                                    .fieldLevel
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains("number")
                                                ? <TextInputFormatter>[
                                                    FilteringTextInputFormatter
                                                        .digitsOnly,
                                                  ]
                                                : [],
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 0,
                                                      horizontal: 16),
                                              filled:
                                                  true, // Fill the background with color
                                              hintStyle: TextStyle(
                                                color: AppColors
                                                    .textFieldHintColor,
                                              ),
                                              fillColor: Colors
                                                  .transparent, // Background color
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: AppThemes
                                                      .getSliderInactiveColor(),
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    Dimensions.kBorderRadius,
                                              ),

                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    Dimensions.kBorderRadius,
                                                borderSide: BorderSide(
                                                    color: AppColors.mainColor),
                                              ),
                                            ),
                                            style: context.t.displayMedium,
                                          ),
                                          SizedBox(
                                            height: 16.h,
                                          ),
                                        ],
                                      ),
                                    if (dynamicField.type == "url")
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                dynamicField.fieldLevel!,
                                                style: context.t.displayMedium,
                                              ),
                                              dynamicField.validation ==
                                                      'required'
                                                  ? const SizedBox()
                                                  : Text(
                                                      " ${storedLanguage['(Optional)'] ?? "(Optional)"}",
                                                      style: context
                                                          .t.displayMedium,
                                                    ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8.h,
                                          ),
                                          TextFormField(
                                            validator: (value) {
                                              // Perform validation based on the 'validation' property
                                              if (dynamicField.validation ==
                                                      "required" &&
                                                  value!.isEmpty) {
                                                return storedLanguage[
                                                        'Field is required'] ??
                                                    "Field is required";
                                              }
                                              return null;
                                            },
                                            onChanged: (v) {
                                              verifyCtrl
                                                  .textEditingControllerMap[
                                                      dynamicField.fieldName]!
                                                  .text = v;
                                            },
                                            controller:
                                                verifyCtrl.textEditingControllerMap[
                                                    dynamicField.fieldName],
                                            keyboardType: dynamicField
                                                    .fieldLevel
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains("number")
                                                ? TextInputType.number
                                                : TextInputType.text,
                                            inputFormatters: dynamicField
                                                    .fieldLevel
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains("number")
                                                ? <TextInputFormatter>[
                                                    FilteringTextInputFormatter
                                                        .digitsOnly,
                                                  ]
                                                : [],
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 0,
                                                      horizontal: 16),
                                              filled:
                                                  true, // Fill the background with color
                                              hintStyle: TextStyle(
                                                color: AppColors
                                                    .textFieldHintColor,
                                              ),
                                              fillColor: Colors
                                                  .transparent, // Background color
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: AppThemes
                                                      .getSliderInactiveColor(),
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    Dimensions.kBorderRadius,
                                              ),

                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    Dimensions.kBorderRadius,
                                                borderSide: BorderSide(
                                                    color: AppColors.mainColor),
                                              ),
                                            ),
                                            style: context.t.displayMedium,
                                          ),
                                          SizedBox(
                                            height: 16.h,
                                          ),
                                        ],
                                      ),
                                    if (dynamicField.type == "number")
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                dynamicField.fieldLevel!,
                                                style: context.t.displayMedium,
                                              ),
                                              dynamicField.validation ==
                                                      'required'
                                                  ? const SizedBox()
                                                  : Text(
                                                      " ${storedLanguage['(Optional)'] ?? "(Optional)"}",
                                                      style: context
                                                          .t.displayMedium,
                                                    ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8.h,
                                          ),
                                          TextFormField(
                                            validator: (value) {
                                              // Perform validation based on the 'validation' property
                                              if (dynamicField.validation ==
                                                      "required" &&
                                                  value!.isEmpty) {
                                                return storedLanguage[
                                                        'Field is required'] ??
                                                    "Field is required";
                                              }
                                              return null;
                                            },
                                            onChanged: (v) {
                                              verifyCtrl
                                                  .textEditingControllerMap[
                                                      dynamicField.fieldName]!
                                                  .text = v;
                                            },
                                            controller:
                                                verifyCtrl.textEditingControllerMap[
                                                    dynamicField.fieldName],
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 0,
                                                      horizontal: 16),
                                              filled:
                                                  true, // Fill the background with color
                                              hintStyle: TextStyle(
                                                color: AppColors
                                                    .textFieldHintColor,
                                              ),
                                              fillColor: Colors
                                                  .transparent, // Background color
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: AppThemes
                                                      .getSliderInactiveColor(),
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    Dimensions.kBorderRadius,
                                              ),

                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    Dimensions.kBorderRadius,
                                                borderSide: BorderSide(
                                                    color: AppColors.mainColor),
                                              ),
                                            ),
                                            style: context.t.displayMedium,
                                          ),
                                          SizedBox(
                                            height: 16.h,
                                          ),
                                        ],
                                      ),
                                    if (dynamicField.type == "date")
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                dynamicField.fieldLevel!,
                                                style: context.t.displayMedium,
                                              ),
                                              dynamicField.validation ==
                                                      'required'
                                                  ? const SizedBox()
                                                  : Text(
                                                      " ${storedLanguage['(Optional)'] ?? "(Optional)"}",
                                                      style: context
                                                          .t.displayMedium,
                                                    ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8.h,
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              /// SHOW DATE PICKER
                                              await showDatePicker(
                                                context: context,
                                                builder: (context, child) {
                                                  return Theme(
                                                      data: Theme.of(context)
                                                          .copyWith(
                                                        colorScheme:
                                                            ColorScheme.dark(
                                                          surface: Get
                                                                  .isDarkMode
                                                              ? AppColors
                                                                  .darkCardColor
                                                              : AppColors
                                                                  .paragraphColor,
                                                          onPrimary: AppColors
                                                              .whiteColor,
                                                        ),
                                                        textButtonTheme:
                                                            TextButtonThemeData(
                                                          style: TextButton
                                                              .styleFrom(
                                                            foregroundColor:
                                                                AppColors
                                                                    .mainColor, // button text color
                                                          ),
                                                        ),
                                                      ),
                                                      child: child!);
                                                },
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1900),
                                                lastDate: DateTime(
                                                    DateTime.now()
                                                            .year
                                                            .toInt() +
                                                        1),
                                              ).then((value) {
                                                if (value != null) {
                                                  verifyCtrl
                                                      .textEditingControllerMap[
                                                          dynamicField
                                                              .fieldName]!
                                                      .text = DateFormat(
                                                          'yyyy-MM-dd')
                                                      .format(value);
                                                }
                                              });
                                            },
                                            child: IgnorePointer(
                                              ignoring: true,
                                              child: TextFormField(
                                                validator: (value) {
                                                  // Perform validation based on the 'validation' property
                                                  if (dynamicField.validation ==
                                                          "required" &&
                                                      value!.isEmpty) {
                                                    return storedLanguage[
                                                            'Field is required'] ??
                                                        "Field is required";
                                                  }
                                                  return null;
                                                },
                                                controller:
                                                    verifyCtrl.textEditingControllerMap[
                                                        dynamicField.fieldName],
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 0,
                                                          horizontal: 16),
                                                  filled:
                                                      true, // Fill the background with color
                                                  hintStyle: TextStyle(
                                                    color: AppColors
                                                        .textFieldHintColor,
                                                  ),
                                                  fillColor: Colors
                                                      .transparent, // Background color
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: AppThemes
                                                          .getSliderInactiveColor(),
                                                      width: 1,
                                                    ),
                                                    borderRadius: Dimensions
                                                        .kBorderRadius,
                                                  ),

                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius: Dimensions
                                                        .kBorderRadius,
                                                    borderSide: BorderSide(
                                                        color: AppColors
                                                            .mainColor),
                                                  ),
                                                ),
                                                style: context.t.displayMedium,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 16.h,
                                          ),
                                        ],
                                      ),
                                    if (dynamicField.type == 'textarea')
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                dynamicField.fieldLevel!,
                                                style: context.t.displayMedium,
                                              ),
                                              dynamicField.validation ==
                                                      'required'
                                                  ? const SizedBox()
                                                  : Text(
                                                      " ${storedLanguage['(Optional)'] ?? "(Optional)"}",
                                                      style: context
                                                          .t.displayMedium,
                                                    ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8.h,
                                          ),
                                          TextFormField(
                                            validator: (value) {
                                              if (dynamicField.validation ==
                                                      "required" &&
                                                  value!.isEmpty) {
                                                return storedLanguage[
                                                        'Field is required'] ??
                                                    "Field is required";
                                              }
                                              return null;
                                            },
                                            controller:
                                                verifyCtrl.textEditingControllerMap[
                                                    dynamicField.fieldName],
                                            minLines: 6,
                                            maxLines: 10,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 16),
                                              filled: true,
                                              hintStyle: TextStyle(
                                                color: AppColors
                                                    .textFieldHintColor,
                                              ),
                                              fillColor: Colors
                                                  .transparent, // Background color
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: AppThemes
                                                      .getSliderInactiveColor(),
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    Dimensions.kBorderRadius,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    Dimensions.kBorderRadius,
                                                borderSide: BorderSide(
                                                    color: AppColors.mainColor),
                                              ),
                                            ),
                                            style: context.t.displayMedium,
                                          ),
                                          SizedBox(
                                            height: 16.h,
                                          ),
                                        ],
                                      ),
                                  ],
                                );
                              },
                            ),
                          ],
                          AppButton(
                              isLoading: verifyCtrl.isIdentitySubmitting ? true : false,
                              text: storedLanguage['Submit'] ?? 'Submit',
                              onTap: verifyCtrl.isIdentitySubmitting
                                  ? null
                                  : () async {
                                      Helpers.hideKeyboard();
                                      if (verifyCtrl.formKey.currentState!.validate() &&
                                          verifyCtrl.requiredFile.isEmpty) {
                                        verifyCtrl.fileColorOfDField =
                                            AppColors.mainColor;
                                        verifyCtrl.update();
                                        await verifyCtrl.renderDynamicFieldData();

                                        Map<String, String> stringMap = {};
                                        verifyCtrl.dynamicData.forEach((key, value) {
                                          if (value is String) {
                                            stringMap[key] = value;
                                          }
                                        });

                                        await Future.delayed(
                                            Duration(milliseconds: 300));

                                        Map<String, String> body = {};
                                        body.addAll(stringMap);

                                        await verifyCtrl
                                            .submitVerification(
                                                type: widget.id.toString(),
                                                fields: body,
                                                fileList: verifyCtrl.fileMap.entries
                                                    .map((e) => e.value)
                                                    .toList(),
                                                context: context)
                                            .then((value) {});
                                      } else {
                                        verifyCtrl.fileColorOfDField =
                                            AppColors.redColor;
                                        verifyCtrl.update();
                                        print(
                                            "required type file list===========================: ${verifyCtrl}");
                                        Helpers.showSnackBar(
                                            msg:
                                                "Please fill in all required fields.");
                                      }
                                    }),
                          SizedBox(height: 60.h),
                        ],
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      );
    });
  }
}
