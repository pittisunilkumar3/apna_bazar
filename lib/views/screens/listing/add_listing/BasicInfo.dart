import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:listplace/controllers/profile_controller.dart';
import 'package:listplace/views/widgets/app_button.dart';
import 'package:listplace/views/widgets/text_theme_extension.dart';
import 'package:searchfield/searchfield.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/dimensions.dart';
import '../../../../controllers/manage_listing_controller.dart';
import '../../../../themes/themes.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/services/localstorage/hive.dart';
import '../../../../utils/services/localstorage/keys.dart';
import '../../../widgets/app_custom_dropdown.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/google_map_screen.dart';
import '../../../widgets/leaflet_map.dart';
import '../../../widgets/multi_select_dropdown.dart';
import '../../../widgets/spacing.dart';
import 'package:latlong2/latlong.dart' as latlng;

class BasicInfoTab extends StatelessWidget {
  final bool? isFromEditListing;
  const BasicInfoTab({super.key, this.isFromEditListing = false});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};

    return GetBuilder<ManageListingController>(builder: (manageListingCtrl) {
      return Scaffold(
        body: RefreshIndicator(
          color: AppColors.mainColor,
          onRefresh: () async {
            await manageListingCtrl.getListingCategories();
            await manageListingCtrl.getCountryList();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
                padding: Dimensions.kDefaultPadding,
                child: Form(
                    key: manageListingCtrl.basicInfoFormKey,
                    child: Column(
                      children: [
                        VSpace(40.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 20.h),
                          decoration: BoxDecoration(
                            borderRadius: Dimensions.kBorderRadius,
                            color: AppThemes.getFillColor(),
                          ),
                          child: Column(
                            children: [
                              Text(storedLanguage['Basic Info'] ?? "Basic Info",
                                  style: t.bodyLarge),
                              VSpace(12.h),
                              CustomTextField(
                                bgColor: AppThemes.getDarkBgColor(),
                                controller: manageListingCtrl.basicInfoTitleEditingCtrlr,
                                onChanged: (v) {
                                  manageListingCtrl.slugEditingCtrlr.text = v
                                      .toString()
                                      .toLowerCase()
                                      .replaceAll(RegExp(r'\s+'), "-");
                                },
                                hintext: storedLanguage['Title'] ?? "Title",
                                isReverseColor: true,
                                borderColor: manageListingCtrl.titleColor,
                                errorBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: AppColors.redColor)),
                                isBorderColor:
                                    manageListingCtrl.titleColor == Colors.transparent
                                        ? false
                                        : true,
                                fillColor: AppThemes.getDarkBgColor(),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "This field cannot be empty";
                                  }
                                  return null;
                                },
                              ),
                              VSpace(20.h),
                              CustomTextField(
                                isReverseColor: true,
                                borderColor: manageListingCtrl.titleColor,
                                errorBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: AppColors.redColor)),
                                isBorderColor:
                                    manageListingCtrl.titleColor == Colors.transparent
                                        ? false
                                        : true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "This field cannot be empty";
                                  }
                                  return null;
                                },
                                bgColor: AppThemes.getDarkBgColor(),
                                controller: manageListingCtrl.slugEditingCtrlr,
                                hintext: storedLanguage['Slug'] ?? "Slug",
                              ),
                              VSpace(20.h),
                              Container(
                                height: 46.h,
                                decoration: BoxDecoration(
                                  color: manageListingCtrl.selectedCategoryList.isEmpty &&
                                          manageListingCtrl.isSubmitBtnTapped
                                      ? Colors.transparent
                                      : AppThemes.getDarkBgColor(),
                                  border: Border.all(
                                      color: manageListingCtrl.selectedCategoryList.isEmpty &&
                                              manageListingCtrl.isSubmitBtnTapped
                                          ? AppColors.redColor
                                          : Colors.transparent,
                                      width: manageListingCtrl.selectedCategoryList.isEmpty &&
                                              manageListingCtrl.isSubmitBtnTapped
                                          ? 1
                                          : 0),
                                  borderRadius: Dimensions.kBorderRadius,
                                ),
                                child: DropDownMultiSelect(
                                  onChanged: manageListingCtrl.onChangedCategories,
                                  options: manageListingCtrl.listingCategoryList
                                      .map((e) => e.name.toString())
                                      .toList(),
                                  selectedValues: manageListingCtrl.selectedCategoryList,
                                  whenEmpty:
                                      storedLanguage['Select Categories'] ??
                                          'Select Categories',
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    fillColor: AppThemes.getDarkBgColor(),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(12.r),
                                        )),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(12.r),
                                        )),
                                  ),
                                ),
                              ),
                              VSpace(20.h),
                              CustomTextField(
                                isBorderColor: false,
                                isReverseColor: true,
                                controller: manageListingCtrl.emailEditingCtrlr,
                                hintext: storedLanguage['Email'] ?? "Email",
                              ),
                              VSpace(20.h),
                              CustomTextField(
                                isBorderColor: false,
                                isReverseColor: true,
                                controller: manageListingCtrl.phoneEditingCtrlr,
                                hintext: storedLanguage['Phone'] ?? "Phone",
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),
                              VSpace(20.h),
                              CustomTextField(
                                isReverseColor: true,
                                borderColor: manageListingCtrl.desColor,
                                errorBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: AppColors.redColor)),
                                isBorderColor: manageListingCtrl.desColor == Colors.transparent
                                    ? false
                                    : true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "This field cannot be empty";
                                  }
                                  return null;
                                },
                                height: 132.h,
                                contentPadding: EdgeInsets.only(
                                    left: 10.w,
                                    bottom: 0.h,
                                    top: 10.h,
                                    right: 10.w),
                                alignment: Alignment.topLeft,
                                minLines: 6,
                                maxLines: 10,
                                bgColor: AppThemes.getDarkBgColor(),
                                controller: manageListingCtrl.descriptionEditingCtrlr,
                                hintext: storedLanguage['Details'] ?? "Details",
                              ),
                            ],
                          ),
                        ),
                        VSpace(32.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 20.h),
                          decoration: BoxDecoration(
                            borderRadius: Dimensions.kBorderRadius,
                            color: AppThemes.getFillColor(),
                          ),
                          child: Column(
                            children: [
                              Text(storedLanguage['Location'] ?? "Location",
                                  style: t.bodyLarge),
                              VSpace(12.h),
                              Container(
                                height: 46.h,
                                decoration: BoxDecoration(
                                  color: manageListingCtrl.selectedCountry == null &&
                                          manageListingCtrl.isSubmitBtnTapped
                                      ? Colors.transparent
                                      : AppThemes.getDarkBgColor(),
                                  border: Border.all(
                                      color: manageListingCtrl.selectedCountry == null &&
                                              manageListingCtrl.isSubmitBtnTapped
                                          ? AppColors.redColor
                                          : Colors.transparent,
                                      width: manageListingCtrl.selectedCountry == null &&
                                              manageListingCtrl.isSubmitBtnTapped
                                          ? 1.h
                                          : 0),
                                  borderRadius: Dimensions.kBorderRadius,
                                ),
                                child: AppCustomDropDown(
                                  bgColor: AppThemes.getDarkCardColor(),
                                  height: 46.h,
                                  width: double.infinity,
                                  items: manageListingCtrl.countryList
                                      .map((e) => e.name.toString())
                                      .toList(),
                                  selectedValue: manageListingCtrl.selectedCountry,
                                  onChanged: manageListingCtrl.onChangedCountry,
                                  hint: storedLanguage['Select Country'] ??
                                      "Select Country",
                                  searchEditingCtrl: manageListingCtrl.countryEditingCtrlr,
                                  searchHintext:
                                      storedLanguage['Search Country'] ??
                                          "Search Country",
                                  fontSize: 14.sp,
                                  hintStyle: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.textFieldHintColor),
                                ),
                              ),
                              VSpace(20.h),
                              if (manageListingCtrl.selectedCountry != null)
                                Container(
                                  height: 46.h,
                                  decoration: BoxDecoration(
                                    color: manageListingCtrl.selectedState == null &&
                                            manageListingCtrl.isSubmitBtnTapped
                                        ? Colors.transparent
                                        : AppThemes.getDarkBgColor(),
                                    border: Border.all(
                                        color: manageListingCtrl.selectedState == null &&
                                                manageListingCtrl.isSubmitBtnTapped
                                            ? AppColors.redColor
                                            : Colors.transparent,
                                        width: manageListingCtrl.selectedState == null &&
                                                manageListingCtrl.isSubmitBtnTapped
                                            ? 1.h
                                            : 0),
                                    borderRadius: Dimensions.kBorderRadius,
                                  ),
                                  child: AppCustomDropDown(
                                    bgColor: AppThemes.getDarkCardColor(),
                                    height: 46.h,
                                    width: double.infinity,
                                    items: manageListingCtrl.stateList
                                        .map((e) => e.name.toString())
                                        .toList(),
                                    selectedValue: manageListingCtrl.selectedState,
                                    onChanged: manageListingCtrl.onChangedState,
                                    hint: storedLanguage['Select State'] ??
                                        "Select State",
                                    fontSize: 14.sp,
                                    hintStyle: TextStyle(
                                        fontSize: 14.sp,
                                        color: AppColors.textFieldHintColor),
                                    searchEditingCtrl: manageListingCtrl.stateEditingCtrlr,
                                    searchHintext:
                                        storedLanguage['Search State'] ??
                                            "Search State",
                                  ),
                                ),
                              if (manageListingCtrl.selectedState != null) VSpace(20.h),
                              if (manageListingCtrl.selectedState != null)
                                Container(
                                  height: 46.h,
                                  decoration: BoxDecoration(
                                    color: manageListingCtrl.selectedCity == null &&
                                            manageListingCtrl.isSubmitBtnTapped
                                        ? Colors.transparent
                                        : AppThemes.getDarkBgColor(),
                                    border: Border.all(
                                        color: manageListingCtrl.selectedCity == null &&
                                                manageListingCtrl.isSubmitBtnTapped
                                            ? AppColors.redColor
                                            : Colors.transparent,
                                        width: manageListingCtrl.selectedCity == null &&
                                                manageListingCtrl.isSubmitBtnTapped
                                            ? 1.h
                                            : 0),
                                    borderRadius: Dimensions.kBorderRadius,
                                  ),
                                  child: AppCustomDropDown(
                                    bgColor: AppThemes.getDarkCardColor(),
                                    height: 46.h,
                                    width: double.infinity,
                                    items: manageListingCtrl.cityList
                                        .map((e) => e.name.toString())
                                        .toList(),
                                    selectedValue: manageListingCtrl.selectedCity,
                                    onChanged: manageListingCtrl.onChangedCity,
                                    hint: storedLanguage['Select City'] ??
                                        "Select City",
                                    searchHintext:
                                        storedLanguage['Search City'] ??
                                            "Search City",
                                    searchEditingCtrl: manageListingCtrl.cityEditingCtrlr,
                                    fontSize: 14.sp,
                                    hintStyle: TextStyle(
                                        fontSize: 14.sp,
                                        color: AppColors.textFieldHintColor),
                                  ),
                                ),
                              if (manageListingCtrl.selectedCity != null &&
                                  ProfileController.to.isLeafLetMap != true)
                                VSpace(20.h),
                              if (manageListingCtrl.selectedCity != null &&
                                  ProfileController.to.isLeafLetMap != true)
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PlacePicker(
                                          apiKey:
                                              dotenv.env['GOOGLE_API_KEY'] ??
                                                  'DEFAULT_KEY',
                                          useCurrentLocation: true,
                                          hintText: "Find a place ...",
                                          searchingText: "Please wait ...",
                                          selectText: "Select place",
                                          outsideOfPickAreaText:
                                              "Place not in area",
                                          onPlacePicked: (PickResult result) {
                                            if (result.formattedAddress != null)
                                              manageListingCtrl.searchedPlaceEditingCtrlr.text =
                                                  result.formattedAddress!;
                                            manageListingCtrl.latEditingCtrlr.text = result
                                                .geometry!.location.lat
                                                .toString();
                                            manageListingCtrl.lngEditingCtrlr.text = result
                                                .geometry!.location.lng
                                                .toString();
                                            Navigator.of(context).pop();
                                          },
                                          initialPosition: LatLng(
                                              manageListingCtrl.latEditingCtrlr.text.isEmpty
                                                  ? 25.629454793647078
                                                  : double.parse(
                                                      manageListingCtrl.latEditingCtrlr.text),
                                              manageListingCtrl.latEditingCtrlr.text.isEmpty
                                                  ? 92.24121093750001
                                                  : double.parse(
                                                      manageListingCtrl.latEditingCtrlr.text)),
                                          resizeToAvoidBottomInset: false,
                                        ),
                                      ),
                                    );
                                  },
                                  child: IgnorePointer(
                                    ignoring: true,
                                    child: CustomTextField(
                                      isReverseColor: true,
                                      borderColor: manageListingCtrl.addrColor,
                                      errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColors.redColor)),
                                      isBorderColor:
                                          manageListingCtrl.addrColor == Colors.transparent
                                              ? false
                                              : true,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "This field cannot be empty";
                                        }
                                        return null;
                                      },
                                      controller: manageListingCtrl.searchedPlaceEditingCtrlr,
                                      hintext:
                                          storedLanguage['Search Location'] ??
                                              "Search Loaction",
                                    ),
                                  ),
                                ), // if you bad, I am your dad.
                              if (ProfileController.to.isLeafLetMap == true)
                                if (manageListingCtrl.selectedCityId != null) VSpace(20.h),
                              if (ProfileController.to.isLeafLetMap == true)
                                if (manageListingCtrl.selectedCityId != null)
                                  ClipRRect(
                                    borderRadius: Dimensions.kBorderRadius,
                                    child: SearchField<Map<String, dynamic>>(
                                      onSearchTextChanged: (v) {
                                        manageListingCtrl.handleSearch(v);
                                        return [];
                                      },
                                      suggestions: manageListingCtrl.suggestions
                                          .map(
                                            (e) => SearchFieldListItem<
                                                Map<String, dynamic>>(
                                              e['name'],
                                              item: e,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(e['name'],
                                                    style: t.displayMedium),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      suggestionState: Suggestion.expand,
                                      onSuggestionTap: (SearchFieldListItem<
                                              Map<String, dynamic>>
                                          v) {
                                        manageListingCtrl.selectSuggestion(v.item ?? {});
                                        manageListingCtrl.update();
                                      },
                                      controller: manageListingCtrl.leafLetSearchEditingCtrl,
                                      hint: storedLanguage['Search Place'] ??
                                          "Search Place",
                                      searchInputDecoration:
                                          SearchInputDecoration(
                                        cursorColor: AppColors.mainColor,
                                        filled: true,
                                        fillColor: AppThemes.getDarkBgColor(),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                              if (manageListingCtrl.latEditingCtrlr.text.isNotEmpty &&
                                  manageListingCtrl.latEditingCtrlr.text != "${manageListingCtrl.defaultLat}")
                                VSpace(20.h),
                              if (manageListingCtrl.latEditingCtrlr.text.isNotEmpty &&
                                  manageListingCtrl.latEditingCtrlr.text != "${manageListingCtrl.defaultLat}")
                                CustomTextField(
                                  isReverseColor: true,
                                  borderColor: manageListingCtrl.latColor,
                                  errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.redColor)),
                                  isBorderColor:
                                      manageListingCtrl.latColor == Colors.transparent
                                          ? false
                                          : true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "This field cannot be empty";
                                    }
                                    return null;
                                  },
                                  controller: manageListingCtrl.latEditingCtrlr,
                                  hintext: storedLanguage['Lat'] ?? "Lat",
                                ),
                              if (manageListingCtrl.lngEditingCtrlr.text.isNotEmpty &&
                                  manageListingCtrl.lngEditingCtrlr.text != "${manageListingCtrl.defaultLng}")
                                VSpace(20.h),
                              if (manageListingCtrl.lngEditingCtrlr.text.isNotEmpty &&
                                  manageListingCtrl.lngEditingCtrlr.text != "${manageListingCtrl.defaultLng}")
                                CustomTextField(
                                  isReverseColor: true,
                                  borderColor: manageListingCtrl.lngColor,
                                  errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.redColor)),
                                  isBorderColor:
                                      manageListingCtrl.lngColor == Colors.transparent
                                          ? false
                                          : true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "This field cannot be empty";
                                    }
                                    return null;
                                  },
                                  controller: manageListingCtrl.lngEditingCtrlr,
                                  hintext: storedLanguage['Lng'] ?? "Lng",
                                ),
                              if (manageListingCtrl.lngEditingCtrlr.text.isNotEmpty &&
                                  manageListingCtrl.lngEditingCtrlr.text != "${manageListingCtrl.defaultLng}")
                                VSpace(20.h),
                              if (ProfileController.to.isLeafLetMap != true)
                                VSpace(20.h),
                              if (ProfileController.to.isLeafLetMap != true)
                                Container(
                                    width: double.maxFinite,
                                    height: 226.h,
                                    decoration: BoxDecoration(
                                      color: AppColors.greyColor,
                                      border: Border.all(
                                          color: Get.isDarkMode
                                              ? AppColors.darkCardColorDeep
                                              : AppColors.whiteColor,
                                          width: 5.h),
                                    ),
                                    child: Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        GoogleMapScreen(
                                            latLng: LatLng(
                                                manageListingCtrl.latEditingCtrlr.text.isEmpty
                                                    ? manageListingCtrl.defaultLat
                                                    : double.parse(
                                                        manageListingCtrl.latEditingCtrlr.text),
                                                manageListingCtrl.lngEditingCtrlr.text.isEmpty
                                                    ? manageListingCtrl.defaultLng
                                                    : double.parse(manageListingCtrl
                                                        .lngEditingCtrlr
                                                        .text))),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: IconButton(
                                              onPressed: () {
                                                Get.to(() => GoogleMapScreen(
                                                      isFullView: true,
                                                      latLng: LatLng(
                                                        manageListingCtrl.latEditingCtrlr.text
                                                                .isEmpty
                                                            ? manageListingCtrl.defaultLat
                                                            : double.parse(manageListingCtrl
                                                                .latEditingCtrlr
                                                                .text),
                                                        manageListingCtrl.lngEditingCtrlr.text
                                                                .isEmpty
                                                            ? manageListingCtrl.defaultLng
                                                            : double.parse(manageListingCtrl
                                                                .lngEditingCtrlr
                                                                .text),
                                                      ),
                                                    ));
                                              },
                                              icon: Container(
                                                padding: EdgeInsets.all(5.h),
                                                decoration: BoxDecoration(
                                                    color: AppColors.mainColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.r)),
                                                child: Icon(
                                                  Icons.zoom_out_map,
                                                  size: 24.h,
                                                  color: AppColors.blackColor,
                                                ),
                                              )),
                                        ),
                                        Material(
                                          color: Colors.transparent,
                                          child: AppButton(
                                            buttonHeight: 30.h,
                                            buttonWidth: 110.w,
                                            style: t.bodyMedium?.copyWith(
                                                color: AppColors.blackColor),
                                            onTap: () {
                                              Get.to(
                                                () => PlacePicker(
                                                  apiKey: dotenv.env[
                                                          'GOOGLE_API_KEY'] ??
                                                      'DEFAULT_KEY',
                                                  useCurrentLocation: true,
                                                  hintText: "Find a place ...",
                                                  searchingText:
                                                      "Please wait ...",
                                                  selectText: "Select place",
                                                  outsideOfPickAreaText:
                                                      "Place not in area",
                                                  onPlacePicked:
                                                      (PickResult result) {
                                                    if (result
                                                            .formattedAddress !=
                                                        null)
                                                      manageListingCtrl.searchedPlaceEditingCtrlr
                                                              .text =
                                                          result
                                                              .formattedAddress!;
                                                    manageListingCtrl.latEditingCtrlr.text =
                                                        result.geometry!
                                                            .location.lat
                                                            .toString();
                                                    manageListingCtrl.lngEditingCtrlr.text =
                                                        result.geometry!
                                                            .location.lng
                                                            .toString();
                                                    Navigator.of(context).pop();
                                                  },
                                                  initialPosition: LatLng(
                                                    manageListingCtrl.latEditingCtrlr.text
                                                            .isEmpty
                                                        ? 25.629454793647078
                                                        : double.parse(manageListingCtrl
                                                            .latEditingCtrlr
                                                            .text),
                                                    manageListingCtrl.lngEditingCtrlr.text
                                                            .isEmpty
                                                        ? 92.24121093750001
                                                        : double.parse(manageListingCtrl
                                                            .lngEditingCtrlr
                                                            .text),
                                                  ),
                                                  resizeToAvoidBottomInset:
                                                      false,
                                                ),
                                              );
                                            },
                                            text:
                                                storedLanguage['Pick Place'] ??
                                                    "Pick Place",
                                          ),
                                        )
                                      ],
                                    )),
                              if (ProfileController.to.isLeafLetMap == true)
                                VSpace(20.h),
                              if (ProfileController.to.isLeafLetMap == true)
                                Container(
                                    width: double.maxFinite,
                                    height: 226.h,
                                    decoration: BoxDecoration(
                                      color: AppColors.greyColor,
                                      border: Border.all(
                                          color: Get.isDarkMode
                                              ? AppColors.darkCardColorDeep
                                              : AppColors.whiteColor,
                                          width: 5.h),
                                    ),
                                    child: Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        InteractiveMapScreen(
                                          isFromEditListing: isFromEditListing,
                                          latLng: latlng.LatLng(
                                              double.parse(manageListingCtrl.selectedLat),
                                              double.parse(manageListingCtrl.selectedLng)),
                                        ),
                                
                                      ],
                                    )),
                              if (ProfileController.to.isLeafLetMap == true)
                                VSpace(50.h),
                            ],
                          ),
                        ),
                        if (manageListingCtrl.selectedSinglePackage.isBusinessHour == 1)
                          VSpace(32.h),
                        if (manageListingCtrl.selectedSinglePackage.isBusinessHour == 1)
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 20.h),
                            decoration: BoxDecoration(
                              borderRadius: Dimensions.kBorderRadius,
                              color: AppThemes.getFillColor(),
                            ),
                            child: Column(
                              children: [
                                Text(
                                    storedLanguage['Business Hours'] ??
                                        "Business Hours",
                                    style: t.bodyLarge),
                                VSpace(12.h),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: manageListingCtrl.businessHours.length,
                                  itemBuilder: (context, index) {
                                    return BusinessHourCard(
                                      businessHour: manageListingCtrl.businessHours[index],
                                      onAdd: manageListingCtrl.addBusinessHour,
                                      onRemove: () =>
                                          manageListingCtrl.removeBusinessHour(index),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        VSpace(32.h),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 20.h),
                          decoration: BoxDecoration(
                            borderRadius: Dimensions.kBorderRadius,
                            color: AppThemes.getFillColor(),
                          ),
                          child: Column(
                            children: [
                              Text(
                                  storedLanguage['Websites And Social Links'] ??
                                      "Websites And Social Links",
                                  style: t.bodyLarge),
                              VSpace(12.h),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: manageListingCtrl.socialList.length,
                                itemBuilder: (context, index) {
                                  return WebAndSocialCard(
                                    ctrl: manageListingCtrl.urlCtrlList[index],
                                    social: manageListingCtrl.socialList[index],
                                    onAdd: manageListingCtrl.addSocial,
                                    onRemove: () => manageListingCtrl.removeSocial(index),
                                  );
                                },
                              ),
                            ],
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
                        VSpace(60.h),
                      ],
                    ))),
          ),
        ),
      );
    });
  }
}

class BusinessHourCard extends StatelessWidget {
  final BusinessHourModel businessHour;
  final VoidCallback onRemove;
  final VoidCallback onAdd;

  const BusinessHourCard({
    required this.businessHour,
    required this.onRemove,
    required this.onAdd,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<ManageListingController>(builder: (manageListingCtrl) {
      return Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          border: Border.all(color: AppThemes.getDarkBgColor(), width: 5),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.h),
          child: Column(
            children: [
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
                  items: manageListingCtrl.weekdays,
                  selectedValue: businessHour.selectedWeek.isEmpty
                      ? null
                      : businessHour.selectedWeek,
                  onChanged: (v) {
                    businessHour.selectedWeek = v ?? "";
                    manageListingCtrl.update();
                  },
                  hint: storedLanguage['Select day'] ?? "Select day",
                  searchHintext: storedLanguage['Search day'] ?? "Search day",
                  fontSize: 14.sp,
                  hintStyle: TextStyle(
                      fontSize: 14.sp, color: AppColors.textFieldHintColor),
                ),
              ),
              VSpace(8.h),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        Navigator.of(context).push(
                          showPicker(
                            context: context,
                            value: manageListingCtrl.startTime,
                            backgroundColor: AppThemes.getDarkBgColor(),
                            cancelStyle: TextStyle(color: AppColors.redColor),
                            okStyle: TextStyle(color: Colors.blue),
                            accentColor: AppColors.mainColor,
                            okText: storedLanguage['OK'] ?? 'OK',
                            sunrise: TimeOfDay(hour: 6, minute: 0),
                            sunset: TimeOfDay(hour: 18, minute: 0),
                            duskSpanInMinutes: 120,
                            onChange: (Time v) {
                              businessHour.startTime =
                                  "${v.hourOfPeriod}:${v.minute} ${v.period.name}";
                              manageListingCtrl.update();
                            },
                          ),
                        );
                      },
                      child: Container(
                        height: 46.h,
                        decoration: BoxDecoration(
                          color: AppThemes.getDarkBgColor(),
                          borderRadius: Dimensions.kBorderRadius,
                        ),
                        child: Row(
                          mainAxisAlignment: businessHour.startTime.isNotEmpty
                              ? MainAxisAlignment.spaceEvenly
                              : MainAxisAlignment.center,
                          children: [
                            Text(
                                businessHour.startTime.isEmpty
                                    ? storedLanguage['Start Time'] ??
                                        "Start Time"
                                    : businessHour.startTime,
                                style: context.t.displayMedium?.copyWith(
                                    color: businessHour.startTime.isEmpty
                                        ? AppColors.textFieldHintColor
                                        : AppThemes.getIconBlackColor())),
                            if (businessHour.startTime.isNotEmpty)
                              Image.asset(
                                "$rootImageDir/pending.png",
                                width: 20.h,
                                height: 20.h,
                                color: AppThemes.getIconBlackColor(),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  HSpace(8.w),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        Navigator.of(context).push(
                          showPicker(
                            context: context,
                            value: manageListingCtrl.endTime,
                            backgroundColor: AppThemes.getDarkBgColor(),
                            cancelStyle: TextStyle(color: AppColors.redColor),
                            okStyle: TextStyle(color: Colors.blue),
                            accentColor: AppColors.mainColor,
                            okText: storedLanguage['OK'] ?? 'OK',
                            sunrise: TimeOfDay(hour: 6, minute: 0),
                            sunset: TimeOfDay(hour: 18, minute: 0),
                            duskSpanInMinutes: 120,
                            onChange: (Time v) {
                              businessHour.endTime =
                                  "${v.hourOfPeriod}:${v.minute} ${v.period.name}";
                              manageListingCtrl.update();
                            },
                          ),
                        );
                      },
                      child: Container(
                        height: 46.h,
                        decoration: BoxDecoration(
                          color: AppThemes.getDarkBgColor(),
                          borderRadius: Dimensions.kBorderRadius,
                        ),
                        child: Row(
                          mainAxisAlignment: businessHour.endTime.isNotEmpty
                              ? MainAxisAlignment.spaceEvenly
                              : MainAxisAlignment.center,
                          children: [
                            Text(
                                businessHour.endTime.isEmpty
                                    ? storedLanguage['End Time'] ?? "End Time"
                                    : businessHour.endTime,
                                style: context.t.displayMedium?.copyWith(
                                    color: businessHour.endTime.isEmpty
                                        ? AppColors.textFieldHintColor
                                        : AppThemes.getIconBlackColor())),
                            if (businessHour.endTime.isNotEmpty)
                              Image.asset(
                                "$rootImageDir/pending.png",
                                width: 20.h,
                                height: 20.h,
                                color: AppThemes.getIconBlackColor(),
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
    });
  }
}

class WebAndSocialCard extends StatelessWidget {
  final SocialModel social;
  final TextEditingController ctrl;
  final VoidCallback onRemove;
  final VoidCallback onAdd;

  const WebAndSocialCard({
    required this.ctrl,
    required this.social,
    required this.onRemove,
    required this.onAdd,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    void showIconSelectionDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    storedLanguage['Select Social Icon'] ??
                        'Select Social Icon',
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
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: ManageListingController.to.socialIcons.length,
                itemBuilder: (context, index) {
                  String iconName = ManageListingController.to.socialIcons.keys
                      .elementAt(index);
                  IconData iconData =
                      ManageListingController.to.socialIcons[iconName]!;

                  return ListTile(
                    leading: Icon(iconData),
                    title: Text(iconName),
                    onTap: () {
                      social.icon = "bi bi-" + iconName;
                      ManageListingController.to.update();
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          );
        },
      );
    }

    return GetBuilder<ManageListingController>(builder: (manageListingCtrl) {
      return Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          border: Border.all(color: AppThemes.getDarkBgColor(), width: 5),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.h),
          child: Column(
            children: [
              InkWell(
                onTap: showIconSelectionDialog,
                child: Container(
                  height: 46.h,
                  padding: EdgeInsets.only(left: 15.w),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppThemes.getDarkBgColor(),
                    borderRadius: Dimensions.kBorderRadius,
                  ),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        social.icon.isEmpty
                            ? storedLanguage['Pick a icon'] ?? "Pick a icon"
                            : social.icon.toString(),
                        style: context.t.displayMedium?.copyWith(
                            color: social.icon.isEmpty
                                ? AppColors.textFieldHintColor
                                : AppThemes.getIconBlackColor()),
                      )),
                ),
              ),
              VSpace(12.h),
              CustomTextField(
                isBorderColor: false,
                isReverseColor: true,
                controller: ctrl,
                onChanged: (v) {
                  social.url = v;
                  manageListingCtrl.update();
                },
                hintext: storedLanguage['URL'] ?? "URL",
              ),
              VSpace(12.h),
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
    });
  }
}
