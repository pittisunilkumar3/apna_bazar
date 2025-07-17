import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:listplace/views/widgets/text_theme_extension.dart';

import '../../../../config/app_colors.dart';
import '../../../../config/dimensions.dart';
import '../../../../controllers/manage_listing_controller.dart';
import '../../../../themes/themes.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/services/localstorage/hive.dart';
import '../../../../utils/services/localstorage/keys.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/spacing.dart';

class SEOTab extends StatelessWidget {
   final bool? isFromEditListing;
  const SEOTab({super.key,this.isFromEditListing=false});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<ManageListingController>(builder: (manageListingCtrl) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: Dimensions.kDefaultPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VSpace(40.h),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: Dimensions.kBorderRadius,
                    color: AppThemes.getFillColor(),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    child: Column(
                      children: [
                        Text(storedLanguage['SEO & META Keywords']??"SEO & META Keywords", style: t.bodyLarge),
                        VSpace(16.h),
                        CustomTextField(
                          isBorderColor: false,
                      
                          isReverseColor: true,
                          controller: manageListingCtrl.SEOTitleEditingCtrl,
                          hintext:storedLanguage['Title']?? "Title",
                        ),
                        VSpace(16.h),
                        CustomTextField(
                          isBorderColor: false,
                      
                          isReverseColor: true,
                          controller: manageListingCtrl.SEOKeywordEditingCtrl,
                          hintext:storedLanguage['Keywords']?? "Keywords",
                          isSuffixIcon: true,
                          isSuffixBgColor: true,
                          onFieldSubmitted: (v) {
                            manageListingCtrl.addKeyword();
                          },
                          suffix: IconButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () {
                                manageListingCtrl.addKeyword();
                              },
                              icon: Icon(
                                Icons.add,
                                color: AppColors.whiteColor,
                                size: 22.h,
                              )),
                        ),
                        VSpace(5.h),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            runSpacing: 8.w,
                            spacing: 8.w,
                            children: [
                              ...List.generate(
                                manageListingCtrl.keywordList.length,
                                (i) => Chip(
                                    label: Text(manageListingCtrl.keywordList[i],
                                        style: context.t.bodySmall?.copyWith(
                                            color: AppColors.whiteColor)),
                                    backgroundColor: AppColors.mainColor,
                                    side: BorderSide(color: Colors.transparent),
                                    deleteIcon: Icon(Icons.close,
                                        size: 18.h,
                                        color: AppColors.whiteColor),
                                    onDeleted: () => manageListingCtrl.removeKeyword(i)),
                              ),
                            ],
                          ),
                        ),
                        VSpace(16.h),
                        CustomTextField(
                          isBorderColor: false,
                      
                          isReverseColor: true,
                          height: 132.h,
                          contentPadding: EdgeInsets.only(
                              left: 10.w, bottom: 0.h, top: 10.h),
                          alignment: Alignment.topLeft,
                          minLines: 6,
                          maxLines: 10,
                          controller: manageListingCtrl.SEODescriptionEditingCtrl,
                          hintext: storedLanguage['Description']??"Description",
                        ),
                        VSpace(32.h),
                        InkWell(
                          onTap: () async {
                            await manageListingCtrl.pickSEOSection(
                              fieldName: "product_thumbnail",
                            );
                          },
                          child: DottedBorder(
                            color: AppColors.mainColor,
                            dashPattern: const <double>[6, 4],
                            child: Container(
                              padding: EdgeInsets.all(45.h),
                              width: double.maxFinite,
                              height: 168.h,
                              decoration: BoxDecoration(
                                color: AppThemes.getDarkBgColor(),
                                borderRadius: Dimensions.kBorderRadius,
                              ),
                              child: manageListingCtrl.selectedSinglePathFromSEOSection
                                      .isNotEmpty
                                  ? Container(
                                      width: 70.h,
                                      height: 70.h,
                                      margin: EdgeInsets.only(right: 10.w),
                                      child: Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              image:
                                                  manageListingCtrl.selectedSinglePathFromSEOSection
                                                          .contains("http")
                                                      ? DecorationImage(
                                                          image: CachedNetworkImageProvider(
                                                              manageListingCtrl.selectedSinglePathFromSEOSection),
                                                          fit: BoxFit.fill,
                                                        )
                                                      : DecorationImage(
                                                          image: FileImage(File(
                                                              manageListingCtrl.selectedSinglePathFromSEOSection)),
                                                          fit: BoxFit.fill,
                                                        ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 4,
                                            right: 4,
                                            child: GestureDetector(
                                              onTap: () {
                                                manageListingCtrl.selectedSinglePathFromSEOSection =
                                                    "";
                                                manageListingCtrl.update();
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Image.asset(
                                      "$rootImageDir/image.png",
                                      color: AppColors.mainColor,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                VSpace(40.h),
                AppButton(
                  onTap: manageListingCtrl.isLoading
                      ? null
                      : () async {
                     await manageListingCtrl.onSubmit(context,isFromUpdateListing: isFromEditListing);
                        },
                  text: storedLanguage['Submit']??"Submit",
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
}
