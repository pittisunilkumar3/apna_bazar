import 'package:flutter/material.dart';

extension CustomThemeContext on BuildContext {
  TextTheme get t => Theme.of(this).textTheme;
}
