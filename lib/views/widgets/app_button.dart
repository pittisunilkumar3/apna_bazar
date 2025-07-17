import 'package:flutter/material.dart';
import 'package:listplace/utils/services/helpers.dart';
import '../../config/app_colors.dart';
import '../../config/dimensions.dart';

class AppButton extends StatelessWidget {
  final void Function()? onTap;
  final String? text;
  final TextStyle? style;
  final double? buttonWidth;
  final double? buttonHeight;
  final Color? bgColor;
  final BorderRadius? borderRadius;
  final bool? isLoading;
  final Widget? child;

  const AppButton(
      {super.key,
      this.onTap,
      this.text,
      this.style,
      this.buttonWidth,
      this.buttonHeight,
      this.bgColor,
      this.isLoading = false,
      this.child,
      this.borderRadius});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? Dimensions.kBorderRadius,
        child: Ink(
          width: buttonWidth ?? double.maxFinite,
          height: buttonHeight ?? Dimensions.buttonHeight,
          decoration: BoxDecoration(
            color: bgColor ?? AppColors.mainColor,
            borderRadius: borderRadius ?? Dimensions.kBorderRadius,
          ),
          child: child ??
              Center(
                child: isLoading == true
                    ? Helpers.appLoader(color: AppColors.whiteColor)
                    : Text(
                        text ?? "Continue",
                        style: style ??
                            t.bodyLarge?.copyWith(color: AppColors.blackColor),
                      ),
              ),
        ),
      ),
    );
  }
}
