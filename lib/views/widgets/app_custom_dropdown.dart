import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:listplace/views/widgets/custom_textfield.dart';
import '../../../config/app_colors.dart';
import '../../../config/styles.dart';
import '../../themes/themes.dart';

class AppCustomDropDown extends StatelessWidget {
  final double? height;
  final double? width;
  final bool? advanced;
  final String? hint;
  final Color? hintColor;
  final double? dropDownWidth;
  final double? dropdownMaxHeight;
  final double? itemHeight;
  final List<dynamic> items;
  final BoxDecoration? decoration;
  final BoxDecoration? dropdownDecoration;
  final String? selectedValue;
  final TextStyle? hintStyle;
  final double? fontSize;
  final Color? textColor;
  final Color? boxColor;
  final Color? buttonBackground;
  final Color? dropdownBoxBackground;
  final TextStyle? selectedStyle;
  final double? boxBorderRadius;
  final double? paddingLeft;
  final ValueChanged<dynamic>? onChanged;
  final Color? bgColor;
  final Color? selectedTextColor;
  final TextEditingController? searchEditingCtrl;
  final String? searchHintext;
  const AppCustomDropDown(
      {required this.items,
      required this.onChanged,
      required this.selectedValue,
      this.advanced = false,
      this.selectedStyle,
      this.height,
      this.decoration,
      this.dropdownDecoration,
      this.dropDownWidth,
      this.itemHeight,
      this.buttonBackground,
      this.dropdownBoxBackground,
      this.hint,
      this.width,
      this.textColor,
      this.boxColor,
      this.fontSize,
      this.dropdownMaxHeight,
      this.boxBorderRadius,
      this.paddingLeft,
      this.hintStyle,
      this.bgColor,
      this.selectedTextColor,
      this.searchEditingCtrl,
      this.searchHintext,
      this.hintColor,
      Key? key})
      : super(key: key);

  List<DropdownMenuItem<String>> _addDividersAfterItems(List<dynamic> items) {
    if (items.isEmpty) {
      // Return a single "Not found" item that is disabled
      return [
        DropdownMenuItem<String>(
          value: null,
          enabled: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingLeft ?? 10),
            child: Text(
              'No results found',
              style: selectedStyle ??
                  Styles.baseStyle.copyWith(
                    color: AppColors.textFieldHintColor,
                  ),
            ),
          ),
        ),
      ];
    }

    List<DropdownMenuItem<String>> menuItems = [];
    for (var item in items) {
      menuItems.addAll(
        [
          advanced == false
              ? DropdownMenuItem<String>(
                  value: item,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: paddingLeft ?? 10),
                    child: Text(
                      item,
                      style: selectedStyle ??
                          Styles.baseStyle.copyWith(
                              color: Get.isDarkMode
                                  ? AppColors.whiteColor
                                  : AppColors.blackColor),
                    ),
                  ),
                )
              : DropdownMenuItem<String>(
                  value: item,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: paddingLeft ?? 16),
                    child: Text(
                      item,
                      style: selectedStyle ??
                          Styles.bodyLarge.copyWith(
                              color: Get.isDarkMode
                                  ? AppColors.whiteColor
                                  : AppColors.blackColor),
                    ),
                  ),
                ),
          // Add divider unless it's the last item
          if (item != items.last)
            DropdownMenuItem<String>(
              enabled: false,
              child: Divider(
                thickness: Get.isDarkMode ? 0.5 : 0.05,
                color: Get.isDarkMode
                    ? AppColors.darkCardColorDeep
                    : AppColors.textFieldHintColor,
              ),
            ),
        ],
      );
    }
    return menuItems;
  }

  List<double> _getCustomItemsHeights() {
    if (items.isEmpty) {
      // Return a single height for the "Not found" item
      return [40];
    }

    List<double> itemsHeights = [];
    for (var i = 0; i < (items.length * 2) - 1; i++) {
      if (i.isEven) {
        itemsHeights.add(40); // Item height
      }
      // Dividers indexes will be the odd indexes
      if (i.isOdd) {
        itemsHeights.add(4); // Divider height
      }
    }
    return itemsHeights;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
        child: DropdownButton2(
      dropdownSearchData: DropdownSearchData(
        searchController: searchEditingCtrl,
        searchInnerWidgetHeight: 50,
        searchInnerWidget: searchEditingCtrl == null
            ? SizedBox()
            : Container(
                height: 50,
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 4,
                  right: 8,
                  left: 8,
                ),
                child: CustomTextField(
                  isBorderColor: true,
                  
                  bgColor: AppThemes.getDarkBgColor(),
                  borderColor: AppColors.mainColor,
                  controller: searchEditingCtrl ?? TextEditingController(),
                  hintext: searchHintext ?? "Search State",
                ),
              ),
        searchMatchFn: (item, searchValue) {
          return item.value
              .toString()
              .toLowerCase()
              .contains(searchValue.toLowerCase());
        },
      ),
      iconStyleData: IconStyleData(
          icon: Padding(
        padding: EdgeInsets.only(right: 15.w),
        child: Icon(
          Icons.arrow_drop_down,
          color: Get.isDarkMode ? AppColors.black50 : AppColors.black30,
        ),
      )),
      buttonStyleData: ButtonStyleData(
          height: height ?? 60,
          width: width ?? 200,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: decoration ??
              BoxDecoration(
                borderRadius: BorderRadius.circular(boxBorderRadius ?? 5),
              )),
      dropdownStyleData: DropdownStyleData(
          maxHeight: dropdownMaxHeight ?? 200,
          decoration: dropdownDecoration ??
              BoxDecoration(
                color: bgColor ?? AppThemes.getFillColor(),
                border: Border.all(color: Colors.transparent, width: .2),
                borderRadius: BorderRadius.circular(boxBorderRadius ?? 8.r),
              ),
          elevation: 0),
      isExpanded: true,
      hint: Padding(
        padding: EdgeInsets.symmetric(horizontal: paddingLeft ?? 10.w),
        child: Text(
          hint ?? 'Select Item',
          style: hintStyle ??
              Styles.bodySmall.copyWith(
                color: AppColors.textFieldHintColor,
                fontWeight: FontWeight.w400,
              ),
        ),
      ),
      items: _addDividersAfterItems(items),
      menuItemStyleData: MenuItemStyleData(
        customHeights: _getCustomItemsHeights(), // Dynamically generated
        height: itemHeight ?? 60,
      ),
      value: selectedValue,
      onChanged: onChanged,
    ));
  }
}
