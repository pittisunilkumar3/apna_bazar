import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:listplace/views/widgets/text_theme_extension.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/dimensions.dart';
import '../../../../controllers/manage_listing_controller.dart';
import '../../../../themes/themes.dart';
import '../../../../utils/services/localstorage/hive.dart';
import '../../../../utils/services/localstorage/keys.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/spacing.dart';

class CommunicationTab extends StatelessWidget {
  final bool? isFromEditListing;
  const CommunicationTab({super.key, this.isFromEditListing = false});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<ManageListingController>(builder: (manageListingCtrl) {
      return Scaffold(
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: Dimensions.kDefaultPadding,
            child: Column(
              children: [
                VSpace(40.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  decoration: BoxDecoration(
                    borderRadius: Dimensions.kBorderRadius,
                    color: AppThemes.getFillColor(),
                  ),
                  child: Row(
                    children: [
                      Text(storedLanguage['Instruction'] ?? "Instruction",
                          style: t.bodyLarge),
                      Spacer(),
                      InkWell(
                        onTap: () async {
                          await showInstructionDialog(
                              context, manageListingCtrl, storedLanguage);
                        },
                        child: Container(
                          height: 35.h,
                          width: 210.w,
                          decoration: BoxDecoration(
                            color: AppColors.mainColor,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FontAwesomeIcons.youtube,
                                size: 18.h,
                                color: AppColors.blackColor,
                              ),
                              HSpace(10.w),
                              Text(
                                storedLanguage['How to set up it?'] ??
                                    "How to set up it?",
                                style: t.bodyMedium
                                    ?.copyWith(color: AppColors.blackColor),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                if (ManageListingController
                        .to.selectedSinglePackage.isMessenger ==
                    1)
                  VSpace(32.h),
                if (ManageListingController
                        .to.selectedSinglePackage.isMessenger ==
                    1)
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    decoration: BoxDecoration(
                      borderRadius: Dimensions.kBorderRadius,
                      color: AppThemes.getFillColor(),
                    ),
                    child: Column(
                      children: [
                        Text(
                            storedLanguage['FB Messenger Controll'] ??
                                "FB Messenger Controll",
                            style: t.bodyLarge),
                        VSpace(12.h),
                        CustomTextField(
                          isBorderColor: false,
                          isReverseColor: true,
                          controller: manageListingCtrl.appIdEditingCtrl,
                          hintext: storedLanguage['App Id'] ?? "App Id",
                        ),
                        VSpace(20.h),
                        CustomTextField(
                          isBorderColor: false,
                          isReverseColor: true,
                          controller: manageListingCtrl.pageIdEditingCtrl,
                          hintext: storedLanguage['Page Id'] ?? "Page Id",
                        ),
                      ],
                    ),
                  ),
                if (ManageListingController
                        .to.selectedSinglePackage.isWhatsapp ==
                    1)
                  VSpace(32.h),
                if (ManageListingController
                        .to.selectedSinglePackage.isWhatsapp ==
                    1)
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    decoration: BoxDecoration(
                      borderRadius: Dimensions.kBorderRadius,
                      color: AppThemes.getFillColor(),
                    ),
                    child: Column(
                      children: [
                        Text(
                            storedLanguage['Whatsapp Chat Controll'] ??
                                "Whatsapp Chat Control",
                            style: t.bodyLarge),
                        VSpace(12.h),
                        CustomTextField(
                          isBorderColor: false,
                          isReverseColor: true,
                          controller: manageListingCtrl.whatsappEditingCtrl,
                          hintext: storedLanguage['Whatsapp Number'] ??
                              "Whatsapp Number",
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                        VSpace(20.h),
                        CustomTextField(
                          isBorderColor: false,
                          isReverseColor: true,
                          controller: manageListingCtrl.typicallyEditingCtrl,
                          hintext: storedLanguage[
                                  'Typically Replies Within A Day'] ??
                              "Typically Replies Within A Day",
                        ),
                        VSpace(20.h),
                        CustomTextField(
                          isBorderColor: false,
                          isReverseColor: true,
                          height: 132.h,
                          contentPadding: EdgeInsets.only(
                              left: 10.w, bottom: 0.h, top: 10.h, right: 10.w),
                          alignment: Alignment.topLeft,
                          minLines: 6,
                          maxLines: 10,
                          controller: manageListingCtrl.communicationDescriptionEditingCtrl,
                          hintext:
                              storedLanguage['Description'] ?? "Descriptioin",
                        ),
                      ],
                    ),
                  ),
                VSpace(40.h),
                AppButton(
                  onTap: manageListingCtrl.isLoading
                      ? null
                      : () async {
                          await manageListingCtrl.onSubmit(context,
                              isFromUpdateListing: isFromEditListing);
                        },
                  text: storedLanguage['Submit'] ?? "Submit",
                  isLoading: manageListingCtrl.isLoading,
                ),
                VSpace(40.h),
              ],
            ),
          ),
        ),
      );
    });
  }

  Future<dynamic> showInstructionDialog(
      BuildContext context, ManageListingController manageListingCtrl, storedLanguage) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(storedLanguage['Instruction'] ?? 'Instruction',
                  style: context.t.bodyLarge),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    color: AppColors.redColor,
                    size: 24.h,
                  )),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                  onPressed: () async {
                    await manageListingCtrl.launchYouTube();
                  },
                  style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
                  child: Text(
                    storedLanguage['See Demo Video'] ?? "See Demo Video",
                    style: context.t.bodyMedium?.copyWith(color: Colors.blue),
                  )),
              SelectableText(
                "Step One: Visit The Facebook Developers Page. To start with, navigate your browser to the Facebook Developers page. ... Step Three: Add Products In Your App. Now you have to add “Facebook Login” product in your app. ... Step Four: Set Up Your Product. ... Step Five: Make Your App Live.",
                style: context.t.displayMedium?.copyWith(height: 1.7.h),
              ),
            ],
          ),
        );
      },
    );
  }
}
