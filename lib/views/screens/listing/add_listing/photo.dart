import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/dimensions.dart';
import '../../../../controllers/manage_listing_controller.dart';
import '../../../../themes/themes.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/services/localstorage/hive.dart';
import '../../../../utils/services/localstorage/keys.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/spacing.dart';

class PhotoTab extends StatelessWidget {
  final bool? isFromEditListing;
  const PhotoTab({super.key, this.isFromEditListing = false});

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
              children: [
                VSpace(40.h),
                Align(
                    alignment: Alignment.center,
                    child: Text(storedLanguage['Thumbnail'] ?? "Thumbnail",
                        style: t.bodyLarge?.copyWith(fontSize: 20.sp))),
                VSpace(14.h),
                InkWell(
                  onTap: () async {
                    await manageListingCtrl.pickPhotosSection(fieldName: "thumbnail");
                  },
                  child: DottedBorder(
                    color: AppColors.mainColor,
                    dashPattern: const <double>[6, 4],
                    child: Container(
                      padding: EdgeInsets.all(45.h),
                      width: double.maxFinite,
                      height: 168.h,
                      decoration: BoxDecoration(
                        color: AppThemes.getFillColor(),
                        borderRadius: Dimensions.kBorderRadius,
                      ),
                      child: manageListingCtrl.selectedSinglePathFromPhotosSection.isNotEmpty
                          ? Container(
                              width: 70.h,
                              height: 70.h,
                              margin: EdgeInsets.only(right: 10.w),
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image:
                                          manageListingCtrl.selectedSinglePathFromPhotosSection
                                                  .contains("http")
                                              ? DecorationImage(
                                                  image: CachedNetworkImageProvider(
                                                      manageListingCtrl.selectedSinglePathFromPhotosSection),
                                                  fit: BoxFit.fill,
                                                )
                                              : DecorationImage(
                                                  image: FileImage(File(manageListingCtrl
                                                      .selectedSinglePathFromPhotosSection)),
                                                  fit: BoxFit.fill,
                                                ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: GestureDetector(
                                      onTap: () {
                                        manageListingCtrl.selectedSinglePathFromPhotosSection =
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
                VSpace(24.h),
                Align(
                    alignment: Alignment.center,
                    child: Text(storedLanguage['Images'] ?? "Images",
                        style: t.bodyLarge?.copyWith(fontSize: 20.sp))),
                VSpace(14.h),
                DottedBorder(
                  color: AppColors.mainColor,
                  dashPattern: const <double>[6, 4],
                  child: Container(
                    width: double.maxFinite,
                    height: 238.h,
                    padding: EdgeInsets.all(12.h),
                    decoration: BoxDecoration(
                      color: AppThemes.getFillColor(),
                      borderRadius: Dimensions.kBorderRadius,
                    ),
                    child: manageListingCtrl.selectedFilePathsFromPhotosSection.isNotEmpty
                        ? Wrap(
                            children: [
                              ...List.generate(
                                  manageListingCtrl.selectedFilePathsFromPhotosSection.length,
                                  (i) => Container(
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
                                                    manageListingCtrl.selectedFilePathsFromPhotosSection[
                                                                i]
                                                            .contains("http")
                                                        ? DecorationImage(
                                                            image: CachedNetworkImageProvider(
                                                                manageListingCtrl.selectedFilePathsFromPhotosSection[
                                                                    i]),
                                                            fit: BoxFit.fill,
                                                          )
                                                        : DecorationImage(
                                                            image: FileImage(File(
                                                                manageListingCtrl.selectedFilePathsFromPhotosSection[
                                                                    i])),
                                                            fit: BoxFit.fill,
                                                          ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 4,
                                              right: 4,
                                              child: GestureDetector(
                                                onTap: () => manageListingCtrl.removeFile(i),
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
                                      )),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "$rootImageDir/drop.png",
                                color: AppColors.mainColor,
                                height: 57.h,
                              ),
                              VSpace(12.h),
                              InkWell(
                                onTap: () async {
                                  await manageListingCtrl.pickPhotosSection(
                                      fieldName: "listing_image",
                                      allowMuptiple: true);
                                },
                                borderRadius: Dimensions.kBorderRadius,
                                child: Container(
                                  width: 165.w,
                                  height: 38.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.mainColor,
                                    borderRadius: Dimensions.kBorderRadius,
                                  ),
                                  child: Center(
                                    child: Text(
                                      storedLanguage['Browse Files'] ??
                                          "Browse Files",
                                      style: t.bodyLarge?.copyWith(
                                          color: AppColors.blackColor),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
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
              ],
            ),
          ),
        ),
      );
    });
  }
}
