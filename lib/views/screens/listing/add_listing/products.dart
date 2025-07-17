import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/spacing.dart';

class ProductsTab extends StatelessWidget {
  final bool? isFromEditListing;
  const ProductsTab({super.key, this.isFromEditListing = false});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<ManageListingController>(builder: (manageListingCtrl) {
      return Scaffold(
        body: Padding(
          padding: Dimensions.kDefaultPadding,
          child: Column(
            children: [
              VSpace(40.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(storedLanguage['Product'] ?? "Product",
                      style: t.bodyLarge),
                  InkWell(
                    borderRadius: BorderRadius.circular(22.r),
                    onTap: manageListingCtrl.addProductModel,
                    child: Ink(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: AppColors.mainColor,
                        borderRadius: BorderRadius.circular(22.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            size: 20.h,
                            color: AppColors.blackColor,
                          ),
                          HSpace(5.w),
                          Text(
                            "Add More (${manageListingCtrl.selectedSinglePackage.noOfProduct})",
                            style: t.displayMedium
                                ?.copyWith(color: AppColors.blackColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              VSpace(16.h),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: manageListingCtrl.productList.length,
                          itemBuilder: (c, i) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 24.h),
                              child: ProductCard(
                                t: t,
                                i: i,
                                productModel: manageListingCtrl.productList[i],
                                onRemove: () {
                                  manageListingCtrl.removeProductModel(i);
                                },
                              ),
                            );
                          }),
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
            ],
          ),
        ),
      );
    });
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.t,
    required this.i,
    required this.productModel,
    required this.onRemove,
  });

  final TextTheme t;
  final int i;
  final ProductModel productModel;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<ManageListingController>(builder: (manageListingCtrl) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: Dimensions.kBorderRadius,
          color: AppThemes.getFillColor(),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                children: [
                  CustomTextField(
                    isBorderColor: false,
                    isReverseColor: true,
                    controller: productModel.titleEditingController,
                    hintext: storedLanguage['Title'] ?? "Title",
                  ),
                  VSpace(16.h),
                  CustomTextField(
                    isBorderColor: false,
                    isReverseColor: true,
                    controller: productModel.priceEditingController,
                    hintext: storedLanguage['Price'] ?? "Price",
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  VSpace(16.h),
                  CustomTextField(
                    isBorderColor: false,
                    isReverseColor: true,
                    height: 132.h,
                    contentPadding:
                        EdgeInsets.only(left: 10.w, bottom: 0.h, top: 10.h),
                    alignment: Alignment.topLeft,
                    minLines: 6,
                    maxLines: 10,
                    controller: productModel.descriptionEditingController,
                    hintext: storedLanguage['Description'] ?? "Description",
                  ),
                  VSpace(32.h),
                  DottedBorder(
                    color: AppColors.mainColor,
                    dashPattern: const <double>[6, 4],
                    child: Container(
                      width: double.maxFinite,
                      height: 238.h,
                      padding: EdgeInsets.all(12.h),
                      decoration: BoxDecoration(
                        color: AppThemes.getDarkBgColor(),
                        borderRadius: Dimensions.kBorderRadius,
                      ),
                      child: productModel.filePath.isNotEmpty
                          ? Wrap(
                              children: [
                                ...List.generate(
                                    productModel.filePath.length,
                                    (j) => Container(
                                          width: 70.h,
                                          height: 70.h,
                                          margin: EdgeInsets.only(right: 10.w),
                                          child: Stack(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  image: productModel
                                                          .filePath[j]
                                                          .toString()
                                                          .contains("http")
                                                      ? DecorationImage(
                                                          image: CachedNetworkImageProvider(
                                                              productModel
                                                                  .filePath[j]),
                                                          fit: BoxFit.fill,
                                                        )
                                                      : DecorationImage(
                                                          image: FileImage(File(
                                                              productModel
                                                                      .filePath[
                                                                  j])),
                                                          fit: BoxFit.fill,
                                                        ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 4,
                                                right: 4,
                                                child: GestureDetector(
                                                  onTap: () =>
                                                      manageListingCtrl.removeFileFromProduct(
                                                          i, j),
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
                                    await manageListingCtrl.pickProductSection(
                                        allowMuptiple: true,
                                        fieldName: "product_image",
                                        product: productModel);
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
                  VSpace(14.h),
                  InkWell(
                    onTap: () async {
                      await manageListingCtrl.pickProductSection(
                          fieldName: "product_thumbnail",
                          product: productModel);
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
                        child: productModel.singlePath.isNotEmpty
                            ? Container(
                                width: 70.h,
                                height: 70.h,
                                margin: EdgeInsets.only(right: 10.w),
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: productModel.singlePath
                                                .toString()
                                                .contains("http")
                                            ? DecorationImage(
                                                image:
                                                    CachedNetworkImageProvider(
                                                        productModel.singlePath
                                                            .toString()),
                                                fit: BoxFit.fill,
                                              )
                                            : DecorationImage(
                                                image: FileImage(File(
                                                    productModel.singlePath
                                                        .toString())),
                                                fit: BoxFit.fill,
                                              ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: GestureDetector(
                                        onTap: () {
                                          productModel.singlePath = "";
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
            if (i != 0)
              Positioned(
                top: 0.h,
                right: 0.h,
                child: InkResponse(
                  onTap: onRemove,
                  child: Container(
                    width: 20.h,
                    height: 20.h,
                    decoration: BoxDecoration(
                      color: AppColors.redColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.close,
                        color: AppColors.whiteColor,
                        size: 16.h,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}
