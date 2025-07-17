import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/dimensions.dart';
import '../../../../controllers/manage_listing_controller.dart';
import '../../../../themes/themes.dart';
import '../../../../utils/services/localstorage/hive.dart';
import '../../../../utils/services/localstorage/keys.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/multi_select_dropdown.dart';
import '../../../widgets/spacing.dart';

class AmenitiesTab extends StatelessWidget {
  final bool? isFromEditListing;
  const AmenitiesTab({super.key, this.isFromEditListing = false});

  @override
  Widget build(BuildContext context) {
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    TextTheme t = Theme.of(context).textTheme;
    return GetBuilder<ManageListingController>(builder: (manageListingCtrl) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: Dimensions.kDefaultPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VSpace(40.h),
                Text(storedLanguage['Amenities'] ?? "Amenities",
                    style: t.bodyLarge),
                VSpace(12.h),
                Container(
                  height: 46.h,
                  decoration: BoxDecoration(
                    color: AppThemes.getFillColor(),
                    borderRadius: Dimensions.kBorderRadius,
                  ),
                  child: DropDownMultiSelect(
                    onChanged: manageListingCtrl.onChangedAmenities,
                    options:
                        manageListingCtrl.amenitiList.map((e) => e.name.toString()).toList(),
                    selectedValues: manageListingCtrl.selectedAmenityList,
                    whenEmpty: storedLanguage['Select Amenities'] ??
                        'Select Amenities',
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.r),
                          )),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.r),
                          )),
                    ),
                  ),
                ),
                VSpace(32.h),
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
