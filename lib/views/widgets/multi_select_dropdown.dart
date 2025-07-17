library multiselect;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:listplace/config/styles.dart';
import 'package:listplace/themes/themes.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import '../../config/app_colors.dart';

class _TheState {}

var _theState = RM.inject(() => _TheState());

class RowWrapper extends InheritedWidget {
  final dynamic data;
  final bool Function() shouldNotify;
  RowWrapper({
    required Widget child,
    this.data,
    required this.shouldNotify,
  }) : super(child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}

class _SelectRow extends StatelessWidget {
  final Function(bool) onChange;
  final bool selected;
  final String text;

  const _SelectRow(
      {Key? key,
      required this.onChange,
      required this.selected,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChange(!selected);
        _theState.notify();
      },
      child: Container(
        height: kMinInteractiveDimension,
        child: Row(
          children: [
            Checkbox(
                checkColor: AppColors.whiteColor,
                activeColor: AppColors.mainColor,
                value: selected,
                onChanged: (x) {
                  onChange(x!);
                  _theState.notify();
                }),
            Text(
              text,
              style: Styles.baseStyle
                  .copyWith(color: AppThemes.getIconBlackColor()),
            )
          ],
        ),
      ),
    );
  }
}

class DropDownMultiSelect<T> extends StatefulWidget {
  final List<T> options;

  final List<T> selectedValues;

  final Function(List<T>) onChanged;

  final bool isDense;

  final bool enabled;

  final InputDecoration? decoration;

  final String? whenEmpty;

  final Widget Function(List<T> selectedValues)? childBuilder;

  final Widget Function(T option)? menuItembuilder;

  final String Function(T? selectedOptions)? validator;

  final bool readOnly;

  final Widget? icon;

  final TextStyle? hintStyle;

  final Widget? hint;

  final T? separator;

  final TextStyle? selectedValuesStyle;

  const DropDownMultiSelect({
    Key? key,
    required this.options,
    required this.selectedValues,
    required this.onChanged,
    this.whenEmpty,
    this.icon,
    this.hint,
    this.hintStyle,
    this.childBuilder,
    this.selectedValuesStyle,
    this.menuItembuilder,
    this.isDense = true,
    this.enabled = true,
    this.decoration,
    this.validator,
    this.readOnly = false,
    this.separator,
  }) : super(key: key);

  @override
  _DropDownMultiSelectState createState() => _DropDownMultiSelectState<T>();
}

class _DropDownMultiSelectState<TState>
    extends State<DropDownMultiSelect<TState>> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          _theState.rebuild(() => widget.childBuilder != null
              ? widget.childBuilder!(widget.selectedValues)
              : Padding(
                  padding: widget.decoration != null
                      ? widget.decoration!.contentPadding != null
                          ? widget.decoration!.contentPadding!
                          : EdgeInsets.symmetric(horizontal: 10)
                      : EdgeInsets.symmetric(horizontal: 10),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text(
                      widget.selectedValues.length > 0
                          ? widget.selectedValues
                              .map((e) => e.toString())
                              .reduce((a, b) =>
                                  a +
                                  (widget.separator != null
                                      ? widget.separator.toString()
                                      : ',') +
                                  b)
                          : widget.whenEmpty ?? '',
                    ),
                  ))),
          Container(
            child: DropdownButtonFormField<TState>(
              hint: widget.hint,
              style: widget.hintStyle,
              icon: widget.icon,
              validator: widget.validator != null ? widget.validator : null,
              decoration: widget.decoration != null
                  ? widget.decoration
                  : InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 10,
                      ),
                    ),
              isDense: widget.isDense,
              onChanged: widget.enabled ? (x) {} : null,
              isExpanded: false,
              value: widget.selectedValues.length > 0
                  ? widget.selectedValues[0]
                  : null,
              selectedItemBuilder: (context) {
                return widget.options
                    .map((e) => DropdownMenuItem(
                          child: Container(),
                        ))
                    .toList();
              },
              items: widget.options
                  .map(
                    (x) => DropdownMenuItem<TState>(
                      child: _theState.rebuild(() {
                        return widget.menuItembuilder != null
                            ? widget.menuItembuilder!(x)
                            : _SelectRow(
                                selected: widget.selectedValues.contains(x),
                                text: x.toString(),
                                onChange: (isSelected) {
                                  if (isSelected) {
                                    var ns = widget.selectedValues;
                                    ns.add(x);
                                    widget.onChanged(ns);
                                  } else {
                                    var ns = widget.selectedValues;
                                    ns.remove(x);
                                    widget.onChanged(ns);
                                  }
                                },
                              );
                      }),
                      value: x,
                      onTap: !widget.readOnly
                          ? () {
                              if (widget.selectedValues.contains(x)) {
                                var ns = widget.selectedValues;
                                ns.remove(x);
                                widget.onChanged(ns);
                              } else {
                                var ns = widget.selectedValues;
                                ns.add(x);
                                widget.onChanged(ns);
                              }
                            }
                          : null,
                    ),
                  )
                  .toList(),
            ),
          ),
          _theState.rebuild(() => widget.childBuilder != null
              ? widget.childBuilder!(widget.selectedValues)
              : Padding(
                  padding: widget.decoration != null
                      ? widget.decoration!.contentPadding != null
                          ? widget.decoration!.contentPadding!
                          : EdgeInsets.symmetric(horizontal: 10)
                      : EdgeInsets.symmetric(horizontal: 20),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text(
                      widget.selectedValues.length > 0
                          ? widget.selectedValues
                              .map((e) => e.toString())
                              .reduce((a, b) =>
                                  a.toString() +
                                  (widget.separator != null
                                      ? widget.separator.toString()
                                      : ',') +
                                  b.toString())
                          : widget.whenEmpty ?? '',
                      style: widget.selectedValuesStyle ??
                          TextStyle(
                              color: widget.selectedValues.length < 1
                                  ? AppColors.textFieldHintColor
                                  : AppThemes.getIconBlackColor(),
                              fontSize: 16.sp,
                              fontFamily: Styles.appFontFamily),
                    ),
                  ))),
        ],
      ),
    );
  }
}
