import 'package:flutter/material.dart';
// ignore: shared_widget_purity
import 'package:hooks_riverpod/hooks_riverpod.dart';
// ignore: shared_widget_purity
import 'package:hooks_riverpod/misc.dart';

import '../utils/utils.dart';

class PrimaryInfoWidget<T> extends ConsumerWidget {
  final IconData? icon;
  final Widget? iconWidget;
  final String text;
  final String? subText;
  final String? buttonText;
  final VoidCallback? onPress;
  final Color? iconColor;
  final double? iconSize;
  final ProviderBase<T>? providerToRefresh;
  final Widget? child;

  const PrimaryInfoWidget({
    super.key,
    this.icon,
    this.iconWidget,
    required this.text,
    this.subText,
    this.onPress,
    this.buttonText,
    this.iconColor,
    this.iconSize,
    this.providerToRefresh,
    this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            iconWidget ??
                Icon(
                  icon ?? Icons.info_outline,
                  color: iconColor ?? context.primaryColor,
                  size: iconSize ?? 75,
                ),
            const SizedBox(height: 12),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.8),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ).px16(),
            if (subText != null) ...[
              const SizedBox(height: 12),
              Text(
                subText!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  color: context.adaptive60,
                  height: 1.35,
                ),
              ),
            ],
            if (buttonText != null) ...[
              const SizedBox(height: 12),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                onPressed: () {
                  if (providerToRefresh != null) {
                    ref.invalidate(providerToRefresh!);
                  }
                  onPress?.call();
                },
                child: Text(
                  buttonText!,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
            child ?? const SizedBox(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
