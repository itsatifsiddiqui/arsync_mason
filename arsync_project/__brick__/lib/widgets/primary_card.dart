import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../utils/utils.dart';

class PrimaryCard extends ConsumerWidget {
  final VoidCallback? onTap;
  final bool showChevron;
  final Widget child;
  final Color? color;
  final Color? borderColor;
  final double? borderWidth;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final bool isLoading;
  final double borderRadius;
  final String? backgrounImage;
  final double? backgrounImageWidth;
  final double? backgrounImageHeight;
  final Gradient? gradient;
  final double? width;
  final double? height;
  const PrimaryCard({
    super.key,
    this.onTap,
    this.showChevron = false,
    required this.child,
    this.margin,
    this.padding,
    this.color,
    this.borderColor,
    this.isLoading = false,
    this.borderRadius = kBorderRadius,
    this.backgrounImage,
    this.backgrounImageHeight,
    this.backgrounImageWidth,
    this.gradient,
    this.borderWidth,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardContnet = InkWell(
      borderRadius: BorderRadius.circular(borderRadius),
      onTap: onTap,
      child: Padding(
        padding:
            padding ?? EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: () {
          late Widget containerChild;
          if (showChevron) {
            containerChild = Row(
              children: [
                child.expand(),
                if (isLoading)
                  const CupertinoActivityIndicator().p2()
                else
                  Icon(Icons.chevron_right, color: context.adaptive60),
              ],
            );
          } else {
            containerChild = child;
          }

          return containerChild;
        }.call(),
      ),
    );

    late Widget card;

    if (backgrounImage != null) {
      card = Stack(
        children: [
          Image.asset(
            backgrounImage!,
            width: backgrounImageWidth ?? double.infinity,
            height: backgrounImageHeight ?? double.infinity,
            fit: BoxFit.cover,
          ).cornerRadius(borderRadius),
          cardContnet,
        ],
      );
    } else if (gradient != null) {
      card = Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            width: borderWidth ?? 0.2,
            color: borderColor ?? Colors.red,
          ),
        ),
        child: cardContnet,
      );
    } else {
      card = Material(
        color: color ?? Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: BorderSide(
            width: borderWidth ?? 1,
            color: borderColor ?? context.adaptive12,
          ),
        ),
        child: cardContnet,
      );
    }

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: SizedBox(
        width: width,
        height: height,
        child: card.cornerRadius(borderRadius),
      ),
    );
  }
}
