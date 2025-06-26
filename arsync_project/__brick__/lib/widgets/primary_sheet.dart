import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../utils/utils.dart';
import 'primary_button.dart';

class PrimarySheet extends ConsumerWidget {
  final Widget child;
  const PrimarySheet({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Container(
              width: 64,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            child,
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    bool useRootNavigator = true,
    bool isScrollControlled = true,
    bool isDismissible = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      useRootNavigator: useRootNavigator,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return PrimarySheet(child: child);
      },
    );
  }
}

class DraggablePrimarySheet extends ConsumerWidget {
  final String? title;

  final double maxChildSize;
  final double minChildSize;
  final double initialChildSize;
  final bool expand;
  final bool snap;
  final Widget child;
  final List<double>? snapSizes;

  const DraggablePrimarySheet({
    super.key,
    this.title,
    required this.child,
    required this.maxChildSize,
    required this.minChildSize,
    required this.initialChildSize,
    required this.expand,
    required this.snap,
    this.snapSizes,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DraggableScrollableSheet(
      maxChildSize: maxChildSize,
      minChildSize: minChildSize,
      initialChildSize: initialChildSize,
      expand: expand,
      snap: snap,
      snapSizes: snapSizes ?? [minChildSize, initialChildSize, maxChildSize],
      builder: (context, controller) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 0.1.sw(context),
                    height: 4,
                    decoration: const BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                    ),
                  ).centered(),
                  if (title != null) ...[
                    16.heightBox,
                    Text(
                      title!,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ).p16(),
              Divider(height: 0, color: context.adaptive26),
              ListView(controller: controller, children: [child]).expand(),
            ],
          ).safeArea(),
        );
      },
    );
  }

  static Future<void> show(
    BuildContext context, {
    required Widget child,
    String? title,
    double maxChildSize = 0.9,
    double minChildSize = 0.3,
    double initialChildSize = 0.5,
    bool expand = false,
    bool snap = true,
    List<double>? snapSizes,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      isScrollControlled: true,
      isDismissible: true,
      builder: (context) {
        return DraggablePrimarySheet(
          expand: expand,
          initialChildSize: initialChildSize,
          maxChildSize: maxChildSize,
          minChildSize: minChildSize,
          snap: snap,
          title: title,
          snapSizes: snapSizes,
          child: child,
        );
      },
    );
  }
}

class ConfirmationSheet extends StatefulWidget {
  final String title;
  final String message;
  final Widget? iconWidget;
  final IconData icon;
  final Color? circleColor;
  final Color? iconColor;
  final String positiveButtonText;
  final String? negativeButtonText;
  final FutureOr<dynamic> Function()? onPositiveAction;
  final FutureOr<dynamic> Function()? onNegativeAction;
  final bool popOnAction;
  final Color? positiveButtonColor;
  final Color? negativeButtonColor;

  const ConfirmationSheet({
    super.key,
    required this.title,
    required this.message,
    this.iconWidget,
    required this.icon,
    required this.positiveButtonText,
    this.circleColor,
    this.iconColor,
    this.negativeButtonText,
    this.onPositiveAction,
    this.onNegativeAction,
    this.popOnAction = true,
    this.positiveButtonColor,
    this.negativeButtonColor,
  });

  @override
  _ConfirmationSheetState createState() => _ConfirmationSheetState();
}

class _ConfirmationSheetState extends State<ConfirmationSheet> {
  bool isPositiveActionLoading = false;
  bool isNegativeActionLoading = false;

  void handlePositiveAction() async {
    if (widget.onPositiveAction != null) {
      setState(() {
        isPositiveActionLoading = true;
      });
      try {
        final result = await widget.onPositiveAction!();
        if (widget.popOnAction) context.pop(result);
      } finally {
        setState(() {
          isPositiveActionLoading = false;
        });
      }
    } else {
      context.pop(true);
    }
  }

  void handleNegativeAction() async {
    if (widget.onNegativeAction != null) {
      setState(() {
        isNegativeActionLoading = true;
      });
      try {
        final result = await widget.onNegativeAction!();
        if (widget.popOnAction) context.pop(result);
      } finally {
        setState(() {
          isNegativeActionLoading = false;
        });
      }
    } else {
      context.pop(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];

    actions.add(
      PrimaryButton(
        onTap: handlePositiveAction,
        text: isPositiveActionLoading
            ? 'Loading...'
            : widget.positiveButtonText,
        isOutline: false,
        isLoading: isPositiveActionLoading,
        color: widget.positiveButtonColor,
      ).expand(),
    );

    if (widget.negativeButtonText != null) {
      actions.add(SizedBox(width: 8));
      actions.add(
        PrimaryButton(
          onTap: handleNegativeAction,
          text: isNegativeActionLoading
              ? 'Loading...'
              : widget.negativeButtonText!,
          isOutline: true,
          isLoading: isNegativeActionLoading,
          color: widget.negativeButtonColor,
        ).expand(),
      );
    }

    return Material(
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 24),
            if (widget.iconWidget != null) ...[
              widget.iconWidget!,
            ] else ...[
              // Circular icon
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      widget.circleColor ??
                      widget.iconColor?.withValues(alpha: 0.2) ??
                      context.adaptive12,
                ),
                child: Icon(
                  widget.icon,
                  size: 32,
                  color: widget.iconColor ?? context.primaryColor,
                ),
              ),
              SizedBox(height: 24),
            ],

            // Title and message
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 42.0),
              child: Text(
                widget.message,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.5),
              ),
            ),
            SizedBox(height: 32),
            // Actions
            // ...actions,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(children: actions),
            ),
          ],
        ),
      ),
    );
  }
}
