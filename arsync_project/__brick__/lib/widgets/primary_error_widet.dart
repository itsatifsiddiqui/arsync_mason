import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../utils/utils.dart';

class PrimaryErrorWidget<T> extends ConsumerWidget {
  final Object error;
  final String? tryAgainText;
  final Color? tryAgainTextColor;
  final double? tryAgainTextSize;
  final GestureTapCallback? onTryAgain;
  final Color? iconColor;
  final IconData? icon;
  final double? iconSize;
  final ProviderBase<T>? providerToRefresh;
  final TextStyle? tryAgainTextStyle;
  const PrimaryErrorWidget({
    super.key,
    required this.error,
    this.onTryAgain,
    this.tryAgainText,
    this.tryAgainTextColor,
    this.tryAgainTextSize,
    this.iconColor,
    this.icon,
    this.iconSize,
    this.providerToRefresh,
    this.tryAgainTextStyle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon ?? Icons.error_outline,
              color: iconColor ?? Colors.red,
              size: iconSize ?? 75,
            ),
            const SizedBox(height: 16),
            SelectableText(
              error.toString(),
              minLines: 1,
              maxLines: 4,
              textAlign: TextAlign.center,
              style: TextStyle(color: context.adaptive70, fontSize: 22),
            ).px16(),
            const SizedBox(height: 16),
            SelectableText(
              error.toString().toLowerCase().contains(
                    'SocketException'.toLowerCase(),
                  )
                  ? 'No internet Connection'
                  : error.toString(),
              textAlign: TextAlign.center,
              minLines: 1,
              maxLines: 6,
              style: TextStyle(color: context.adaptive54, fontSize: 18),
            ).px16(),
            const SizedBox(height: 12),
            if (providerToRefresh != null || onTryAgain != null)
              TextButton(
                onPressed: () {
                  if (providerToRefresh != null) {
                    ref.invalidate(providerToRefresh!);
                  }
                  onTryAgain?.call();
                },
                child: Text(
                  tryAgainText ?? 'Try Again',
                  style:
                      tryAgainTextStyle ??
                      TextStyle(
                        color: tryAgainTextColor ?? context.adaptive,
                        fontSize: tryAgainTextSize ?? 24,
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
