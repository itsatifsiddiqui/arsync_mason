import 'package:flutter/material.dart';

import '../utils/utils.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    this.isLoading = false,
    this.isDisabled = false,
    this.isOutline = false,
    this.text,
    this.textStyle,
    required this.onTap,
    this.elevation = 0,
    this.verticalPadding = 16,
    this.width,
    this.child,
    this.color,
    this.textColor,
    this.disabledColor = Colors.black26,
    this.loadingColor = Colors.white,
    this.fontWeight,
    this.fontSize,
    this.fontFamily,
    this.borderRadius = kBorderRadius,
  });

  final bool isDisabled;
  final bool isLoading;
  final bool isOutline;
  final String? text;
  final TextStyle? textStyle;
  final GestureTapCallback onTap;
  final double elevation;
  final double? width;
  final double verticalPadding;
  final Widget? child;
  final Color? color;
  final Color? textColor;
  final Color? disabledColor;
  final Color loadingColor;
  final FontWeight? fontWeight;
  final double? fontSize;
  final String? fontFamily;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isDisabled || isLoading,
      child: MaterialButton(
        splashColor: () {
          if (isOutline) {
            return (color ?? context.primaryColor).withValues(alpha: 0.26);
          }
          return null;
        }.call(),
        highlightColor: context.primaryColor,
        elevation: elevation,
        highlightElevation: elevation,
        disabledColor: disabledColor,
        minWidth: width ?? double.infinity,
        color: () {
          if (isOutline) return Colors.transparent;
          if (color != null) return color;
          return context.primaryColor;
        }.call(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: () {
            if (isOutline) {
              return BorderSide(color: color ?? context.primaryColor, width: 2);
            }
            return BorderSide.none;
          }.call(),
        ),
        onPressed: isDisabled ? null : onTap,
        child: (() {
          if (isLoading) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: verticalPadding),
              child: SizedBox(
                height: 23,
                width: 23,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(loadingColor),
                ),
              ),
            );
          }
          if (child != null) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: verticalPadding),
              child: child!,
            );
          }

          //Text

          return Padding(
            padding: EdgeInsets.symmetric(vertical: verticalPadding),
            child: Text(
              text ?? '',
              textAlign: TextAlign.center,
              style:
                  textStyle ??
                  TextStyle(
                    fontFamily: fontFamily,
                    fontWeight: () {
                      if (fontWeight != null) return fontWeight;
                      if (isOutline) return FontWeight.w500;
                      return FontWeight.w600;
                    }.call(),
                    color: () {
                      if (textColor != null) return textColor;
                      if (isDisabled) return context.adaptive75;
                      if (isOutline) return color ?? context.primaryColor;
                      return Colors.white;
                    }.call(),
                    fontSize: fontSize ?? 16,
                  ),
            ),
          );
        }).call(),
      ),
    );
  }
}
