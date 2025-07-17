import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../themes/themes.dart';
import '../../utils/app_constants.dart';
import 'app_textfield.dart';

class CustomTextField extends StatelessWidget {
  final String hintext;
  final TextEditingController controller;
  final Color? bgColor;
  final Color? suffixIconColor;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final double? height;
  final int? minLines;
  final int? maxLines;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? prefixPadding;
  final String? prefixIcon;
  final double? prefixSize;
  final String? suffixIcon;
  final Widget? suffix;
  final double? minPrefixSize;
  final dynamic Function(String)? onChanged;
  final void Function()? onPreffixPressed;
  final void Function()? onSuffixPressed;
  final AlignmentGeometry? alignment;
  final bool? obsCureText;
  final bool? isPrefixIcon;
  final bool? isSuffixIcon;
  final bool? isSuffixBgColor;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final TextStyle? hintStyle;
  final InputBorder? errorBorder;
  final InputBorder? focusedErrorBorder;
  final InputBorder? focusedBorder;
  final String? errorText;
  final bool? isBorderColor;
  final Color? borderColor;
  final Color? fillColor;
  final bool? isReverseColor;
  final double? borderWidth;
  final BorderRadius? borderRadius;
  final void Function(String)? onFieldSubmitted;
  const CustomTextField(
      {super.key,
      required this.hintext,
      required this.controller,
      this.bgColor,
      this.minPrefixSize,
      this.isSuffixBgColor = false,
      this.isSuffixIcon = false,
      this.isPrefixIcon = false,
      this.prefixSize,
      this.alignment,
      this.borderRadius,
      this.suffixIconColor,
      this.keyboardType = TextInputType.text,
      this.inputFormatters,
      this.height,
      this.minLines,
      this.maxLines,
      this.contentPadding,
      this.prefixPadding,
      this.prefixIcon,
      this.suffixIcon,
      this.suffix,
      this.onChanged,
      this.onPreffixPressed,
      this.onSuffixPressed,
      this.obsCureText = false,
      this.validator,
      this.focusNode,
      this.hintStyle,
      this.errorBorder,
      this.focusedErrorBorder,
      this.focusedBorder,
      this.errorText,
      this.isBorderColor = true,
      this.borderColor,
      this.fillColor,
      this.onFieldSubmitted,
      this.isReverseColor = false,
      this.borderWidth});

  @override
  Widget build(BuildContext context) => height == null
      ? buildTextField()
      : SizedBox(
          height: height,
          child: buildTextField(),
        );

  AppTextField buildTextField() {
    return AppTextField(
      onFieldSubmitted: onFieldSubmitted,
      errorText: errorText,
      errorBorder: errorBorder,
      focusedErrorBorder: focusedErrorBorder,
      controller: controller,
      obscureText: obsCureText ?? false,
      hintStyle: hintStyle,
      minLines: minLines ?? 1,
      maxLines: maxLines ?? 1,
      hinText: hintext,
      onChanged: onChanged,
      fillColor: isBorderColor == false
          ? isReverseColor == true
              ? AppThemes.getDarkBgColor()
              : fillColor ?? AppThemes.getDarkCardColor()
          : fillColor ?? Colors.transparent,
      border: OutlineInputBorder(
          borderRadius: borderRadius ?? Dimensions.kBorderRadius,
          borderSide: BorderSide(
              width: borderWidth ?? 1,
              color: isBorderColor == true
                  ? borderColor ?? AppThemes.getSliderInactiveColor()
                  : Colors.transparent)),
      focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius ?? Dimensions.kBorderRadius,
          borderSide: BorderSide(
              color: isBorderColor == true
                  ? borderColor ?? AppColors.mainColor
                  : Colors.transparent)),
      keyboardType: keyboardType,
      minPrefixSize: minPrefixSize,
      inputFormatters: inputFormatters,
      contentPadding: contentPadding ?? EdgeInsets.only(left: 15.w),
      validator: validator,
      focusNode: focusNode,
      prefixIcon: prefixIcon != null
          ? Padding(
              padding:
                  prefixPadding ?? EdgeInsets.only(left: 20.w, right: 10.w),
              child: InkResponse(
                onTap: onPreffixPressed,
                child: Image.asset(
                  "$rootImageDir/$prefixIcon.png",
                  height: prefixSize ?? 16.h,
                  width: prefixSize ?? 16.h,
                  color: Get.isDarkMode
                      ? AppColors.whiteColor
                      : AppColors.textFieldHintColor,
                  fit: BoxFit.cover,
                ),
              ),
            )
          : null,
      suffixIcon: suffix == null
          ? suffixIcon != null
              ? IconButton(
                  onPressed: onSuffixPressed,
                  icon: Image.asset(
                    "$rootImageDir/$suffixIcon.png",
                    height: 22.h,
                    width: 22.h,
                    color: suffixIconColor ??
                        (Get.isDarkMode
                            ? AppColors.whiteColor
                            : AppColors.textFieldHintColor),
                    fit: BoxFit.cover,
                  ),
                )
              : null
          : this.suffix,
    );
  }
}
