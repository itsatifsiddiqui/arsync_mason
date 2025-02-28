import 'package:flutter/material.dart';

///
/// Extension to provide [Padding] to any widget.
///
extension VxPaddingExtensions on Widget {
  /// Gives 0 padding from all sides.
  Padding p0({Key? key}) => Padding(
        key: key,
        padding: const EdgeInsets.all(0),
        child: this,
      );

  /// Gives 1dp padding from all sides.
  Padding p1({Key? key}) => Padding(
        key: key,
        padding: const EdgeInsets.all(1),
        child: this,
      );

  /// Gives 2dp padding from all sides.
  Padding p2({Key? key}) => Padding(
        key: key,
        padding: const EdgeInsets.all(2),
        child: this,
      );

  /// Gives 4dp padding from all sides.
  Padding p4({Key? key}) => Padding(
        key: key,
        padding: const EdgeInsets.all(4),
        child: this,
      );

  /// Gives 8dp padding from all sides.
  Padding p8({Key? key}) => Padding(
        key: key,
        padding: const EdgeInsets.all(8),
        child: this,
      );

  /// Gives 12dp padding from all sides.
  Padding p12({Key? key}) => Padding(
        key: key,
        padding: const EdgeInsets.all(12),
        child: this,
      );

  /// Gives 16dp padding from all sides.
  Padding p16({Key? key}) => Padding(
        key: key,
        padding: const EdgeInsets.all(16),
        child: this,
      );

  /// Gives 20dp padding from all sides.
  Padding p20({Key? key}) => Padding(
        key: key,
        padding: const EdgeInsets.all(20),
        child: this,
      );

  /// Gives 24dp padding from all sides.
  Padding p24({Key? key}) => Padding(
        key: key,
        padding: const EdgeInsets.all(24),
        child: this,
      );

  /// Gives 32dp padding from all sides.
  Padding p32({Key? key}) => Padding(
        key: key,
        padding: const EdgeInsets.all(32),
        child: this,
      );

  /// Gives 64dp padding from all sides.
  Padding p64({Key? key}) => Padding(
        key: key,
        padding: const EdgeInsets.all(64),
        child: this,
      );

  /// Gives 0 padding vertically.
  Padding py0({Key? key}) => Padding(
        key: key,
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: this,
      );

  /// Gives 1dp padding vertically.
  Padding py1({Key? key}) => Padding(
        key: key,
        padding: const EdgeInsets.symmetric(vertical: 1),
        child: this,
      );

  /// Gives 2dp padding vertically.
  Padding py2({Key? key}) => Padding(
        key: key,
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: this,
      );

  /// Gives 4dp padding vertically.
  Padding py4({Key? key}) => Padding(
        key: key,
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: this,
      );

  /// Gives 8dp padding vertically.
  Padding py8({Key? key}) => Padding(
        key: key,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: this,
      );

  /// Gives 12dp padding vertically.
  Padding py12({Key? key}) => Padding(
        key: key,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: this,
      );

  /// Gives 16dp padding vertically.
  Padding py16({Key? key}) => Padding(
        key: key,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: this,
      );

  /// Gives 20dp padding vertically.
  Padding py20({Key? key}) => Padding(
        key: key,
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: this,
      );

  /// Gives 24dp padding vertically.
  Padding py24({Key? key}) => Padding(
        key: key,
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: this,
      );

  /// Gives 32dp padding vertically.
  Padding py32({Key? key}) => Padding(
        key: key,
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: this,
      );

  /// Gives 64dp padding vertically.
  Padding py64({Key? key}) => Padding(
        key: key,
        padding: const EdgeInsets.symmetric(vertical: 64),
        child: this,
      );

  /// Gives custom padding vertically.
  Padding py(
    double value, {
    Key? key,
  }) =>
      Padding(
        key: key,
        padding: EdgeInsets.symmetric(vertical: value),
        child: this,
      );

  /// Gives 0 padding horizontally.
  Padding px0({Key? key}) => Padding(
        key: key,
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: this,
      );

  /// Gives 1dp padding horizontally.
  Padding px1({Key? key}) => Padding(
        key: key,
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: this,
      );

  /// Gives 2dp padding horizontally.
  Padding px2({Key? key}) => Padding(
        key: key,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: this,
      );

  /// Gives 4dp padding horizontally.
  Padding px4({Key? key}) => Padding(
        key: key,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: this,
      );

  /// Gives 8dp padding horizontally.
  Padding px8({Key? key}) => Padding(
        key: key,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: this,
      );

  /// Gives 12dp padding horizontally.
  Padding px12({Key? key}) => Padding(
        key: key,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: this,
      );

  /// Gives 16dp padding horizontally.
  Padding px16({Key? key}) => Padding(
        key: key,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: this,
      );

  /// Gives 20dp padding horizontally.
  Padding px20({Key? key}) => Padding(
        key: key,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: this,
      );

  /// Gives 24dp padding horizontally.
  Padding px24({Key? key}) => Padding(
        key: key,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: this,
      );

  /// Gives 32dp padding horizontally.
  Padding px32({Key? key}) => Padding(
        key: key,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: this,
      );

  /// Gives 64dp padding horizontally.
  Padding px64({Key? key}) => Padding(
        key: key,
        padding: const EdgeInsets.symmetric(horizontal: 64),
        child: this,
      );

  /// Gives custom padding horizontally.
  Padding px(
    double value, {
    Key? key,
  }) =>
      Padding(
        key: key,
        padding: EdgeInsets.symmetric(horizontal: value),
        child: this,
      );

  /// Gives custom padding from all sides by [value].
  Padding p(double value, {Key? key}) {
    return Padding(
      key: key,
      padding: EdgeInsets.all(value),
      child: this,
    );
  }

  /// Gives custom padding symmetrically by [v] [h].
  Padding pSymmetric({Key? key, double v = 0.0, double h = 0.0}) => Padding(
        key: key,
        padding: EdgeInsets.symmetric(
          vertical: v,
          horizontal: h,
        ),
        child: this,
      );

  /// Gives custom padding by only [left] [top] [right] [bottom].
  Padding pOnly(
          {Key? key,
          double left = 0.0,
          double right = 0.0,
          double top = 0.0,
          double bottom = 0.0}) =>
      Padding(
        key: key,
        padding:
            EdgeInsets.only(left: left, right: right, top: top, bottom: bottom),
        child: this,
      );
}
