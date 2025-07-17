import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/dimensions.dart';
import '../../../../controllers/manage_listing_controller.dart';
import '../../../../themes/themes.dart';
import '../../../../utils/services/localstorage/hive.dart';
import '../../../../utils/services/localstorage/keys.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_custom_dropdown.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/spacing.dart';

class CustomFormTab extends StatelessWidget {
  final bool? isFromEditListing;
  const CustomFormTab({super.key,this.isFromEditListing=false});

  @override
  Widget build(BuildContext context) {
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
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
                  decoration: BoxDecoration(
                    borderRadius: Dimensions.kBorderRadius,
                    color: AppThemes.getFillColor(),
                  ),
                  child: Column(
                    children: [
                      CustomTextField(
                        isBorderColor: false,
                      
                        isReverseColor: true,
                        controller: manageListingCtrl.formNameEditingCtrl,
                        hintext:storedLanguage['Form Name']?? "Form Name",
                      ),
                      VSpace(20.h),
                      CustomTextField(
                        isBorderColor: false,
                  
                        isReverseColor: true,
                        controller: manageListingCtrl.formButtonEditingCtrl,
                        hintext:storedLanguage['Form Button Text']?? "Form Button Text",
                      ),
                    ],
                  ),
                ),
                VSpace(32.h),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: manageListingCtrl.customFromList.length,
                    itemBuilder: (c, i) {
                      return CustomFormCard(
                        customform: manageListingCtrl.customFromList[i],
                        onRemove: () {
                          manageListingCtrl.removeCustomForm(i);
                        },
                        onAdd: () {
                          manageListingCtrl.addCustomForm();
                        },
                      );
                    }),
                VSpace(40.h),
                AppButton(
                  onTap: manageListingCtrl.isLoading
                      ? null
                      : () async {
                          await manageListingCtrl.onSubmit(context,isFromUpdateListing: isFromEditListing);
                        },
                  text:storedLanguage['Submit']?? "Submit",
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

class CustomFormCard extends StatelessWidget {
  final CustomForm customform;
  final VoidCallback onRemove;
  final VoidCallback onAdd;

  const CustomFormCard({
    required this.customform,
    required this.onRemove,
    required this.onAdd,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ManageListingController>(builder: (manageListingCtrl) {
      return Container(
        margin: EdgeInsets.only(bottom: 24.h),
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
        decoration: BoxDecoration(
          borderRadius: Dimensions.kBorderRadius,
          color: AppThemes.getFillColor(),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppThemes.getDarkBgColor(), width: 5),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(10.h),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        borderRadius: Dimensions.kBorderRadius,
                        onTap: onAdd,
                        child: Container(
                          height: 46.h,
                          decoration: BoxDecoration(
                            color: AppThemes.getDarkBgColor(),
                            borderRadius: Dimensions.kBorderRadius,
                          ),
                          child: Center(
                              child: Icon(
                            Icons.add,
                            size: 20.h,
                          )),
                        ),
                      ),
                    ),
                    HSpace(8.w),
                    Expanded(
                      child: InkWell(
                        onTap: onRemove,
                        child: Container(
                          height: 46.h,
                          decoration: BoxDecoration(
                            color: AppThemes.getDarkBgColor(),
                            borderRadius: Dimensions.kBorderRadius,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.delete,
                                size: 20.h,
                                color: AppColors.redColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                VSpace(8.h),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        isBorderColor: false,
                    
                        isReverseColor: true,
                        controller: customform.fieldName,
                        hintext: "Field Name",
                      ),
                    ),
                    HSpace(8.w),
                    Expanded(
                      child: Container(
                        height: 46.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppThemes.getDarkBgColor(),
                          borderRadius: Dimensions.kBorderRadius,
                        ),
                        child: AppCustomDropDown(
                          bgColor: AppThemes.getDarkCardColor(),
                          height: 46.h,
                          items: manageListingCtrl.validationTypeList,
                          selectedValue: customform.validationType.isEmpty
                              ? null
                              : customform.validationType,
                          onChanged: (v) {
                            customform.validationType = v ?? "";

                            manageListingCtrl.update();
                          },
                          hint: "Validation",
                          fontSize: 14.sp,
                          hintStyle: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textFieldHintColor),
                        ),
                      ),
                    ),
                  ],
                ),
                VSpace(8.h),
                Container(
                  height: 46.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppThemes.getDarkBgColor(),
                    borderRadius: Dimensions.kBorderRadius,
                  ),
                  child: AppCustomDropDown(
                    bgColor: AppThemes.getDarkCardColor(),
                    height: 46.h,
                    items: manageListingCtrl.inputTypeList,
                    selectedValue: customform.inputType.isEmpty
                        ? null
                        : customform.inputType,
                    onChanged: (v) {
                      customform.inputType = v ?? "";
                      if (customform.inputType == "Select" &&
                          customform.optionsModel.length < 1) {
                        manageListingCtrl.addOption(customform.optionsModel);
                      } else if (customform.inputType != "Select") {
            
                          customform.optionsModel.clear();
                        
                    
                      }

                      manageListingCtrl.update();
                    },
                    hint: "Input Type",
                    searchHintext: "Search type",
                    fontSize: 14.sp,
                    hintStyle: TextStyle(
                        fontSize: 14.sp, color: AppColors.textFieldHintColor),
                  ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: customform.optionsModel.length,
                    itemBuilder: (c, j) {
                      return OptionCard(
                          optionsModel: customform.optionsModel[j],
                          onAdd: () {
                            manageListingCtrl.addOption(customform.optionsModel);
                          },
                          onRemove: () {
                            manageListingCtrl.removeOption(j, customform.optionsModel);
                          });
                    }),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class OptionCard extends StatelessWidget {
  const OptionCard({
    super.key,
    required this.optionsModel,
    required this.onAdd,
    required this.onRemove,
  });

  final OptionsModel optionsModel;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: AppThemes.getDarkBgColor(), width: 3),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            CustomTextField(
              isBorderColor: false,
         
              isReverseColor: true,
              controller: optionsModel.optionName,
              hintext: "Option Name",
            ),
            VSpace(8.h),
            CustomTextField(
              isBorderColor: false,
             
              isReverseColor: true,
              controller: optionsModel.optionVal,
              hintext: "Option Value",
            ),
            VSpace(8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: InkWell(
                    borderRadius: Dimensions.kBorderRadius,
                    onTap: onAdd,
                    child: Container(
                      height: 46.h,
                      decoration: BoxDecoration(
                        color: AppThemes.getDarkBgColor(),
                        borderRadius: Dimensions.kBorderRadius,
                      ),
                      child: Center(
                          child: Icon(
                        Icons.add,
                        size: 20.h,
                      )),
                    ),
                  ),
                ),
                HSpace(8.w),
                Expanded(
                  child: InkWell(
                    onTap: onRemove,
                    child: Container(
                      height: 46.h,
                      decoration: BoxDecoration(
                        color: AppThemes.getDarkBgColor(),
                        borderRadius: Dimensions.kBorderRadius,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delete,
                            size: 20.h,
                            color: AppColors.redColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
