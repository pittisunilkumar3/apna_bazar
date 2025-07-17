import 'package:flutter/material.dart';

import '../../config/dimensions.dart';
import '../../themes/themes.dart';

appDialog({
  required BuildContext context,
  Widget? title,
  Widget? content,

}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: AppThemes.getDarkBgColor(),
        shape: RoundedRectangleBorder(borderRadius: Dimensions.kBorderRadius),
        title: title ?? const SizedBox(),
        content: content ?? const SizedBox(),
      );
    },
  );
}
