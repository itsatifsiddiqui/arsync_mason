import 'package:flutter/material.dart';

extension WidgetSizedBoxFromNumExtension on num {
  Widget get heightBox => SizedBox(height: toDouble());
  Widget get widthBox => SizedBox(width: toDouble());
}

extension GeneralUtilityExtensions on Widget {
  ///
  /// Extension method to directly access [Center] with any widget without wrapping or with dot operator.
  ///
  Widget centered({Key? key}) => Center(key: key, child: this);

  /// Extension method for [SafeArea] Widget
  Widget safeArea(
          {Key? key,
          EdgeInsets minimum = EdgeInsets.zero,
          bool maintainBottomViewPadding = false,
          bool top = true,
          bool bottom = true,
          bool left = true,
          bool right = true}) =>
      SafeArea(
        key: key,
        minimum: minimum,
        maintainBottomViewPadding: maintainBottomViewPadding,
        top: top,
        bottom: bottom,
        left: left,
        right: right,
        child: this,
      );

  /// Extension for [Expanded]
  Expanded expand({Key? key, int flex = 1}) {
    return Expanded(
      key: key,
      flex: flex,
      child: this,
    );
  }

  /// Extension for [Flexible]
  Flexible flexible({Key? key, int flex = 1}) {
    return Flexible(
      key: key,
      flex: flex,
      child: this,
    );
  }

  /// Extension for aspectRatio with [AspectRatio]
  AspectRatio aspectRatio(double aspectRatio) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: this,
    );
  }

  /// Extension for adding a corner radius a widget with [ClipRRect]
  ClipRRect cornerRadius(double radius) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: this,
    );
  }

  ///
  /// Extension method to directly access [SingleChildScrollView] vertically with any widget without wrapping or with dot operator.
  ///
  Widget scrollVertical({
    Key? key,
    ScrollController? controller,
    ScrollPhysics? physics,
    EdgeInsetsGeometry? padding,
  }) {
    return SingleChildScrollView(
      key: key,
      scrollDirection: Axis.vertical,
      controller: controller,
      physics: physics,
      padding: padding,
      child: this,
    );
  }

  ///
  /// Extension method to directly access [SingleChildScrollView] horizontally with any widget without wrapping or with dot operator.
  ///
  Widget scrollHorizontal({
    Key? key,
    ScrollController? controller,
    ScrollPhysics? physics,
    EdgeInsetsGeometry? padding,
  }) {
    return SingleChildScrollView(
      key: key,
      scrollDirection: Axis.horizontal,
      controller: controller,
      physics: physics,
      padding: padding,
      child: this,
    );
  }

  /// Extension method to set an offset of any widget
  Widget offset({
    Key? key,
    required Offset offset,
    bool transformHitTests = true,
  }) {
    return Transform.translate(
      key: key,
      transformHitTests: transformHitTests,
      offset: offset,
      child: this,
    );
  }

  ///
  /// Extension method to scale any widget by specified [scalevalue] without wrapping or with dot operator.
  ///
  Widget scale(
          {Key? key,
          double? scaleValue,
          Offset? origin,
          Alignment alignment = Alignment.center}) =>
      Transform.scale(
        key: key,
        scale: scaleValue ?? 0,
        alignment: alignment,
        origin: origin,
        child: this,
      );

  SliverToBoxAdapter toBoxAdapter() {
    return SliverToBoxAdapter(child: this);
  }
}
