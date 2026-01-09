import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../utils/extensions.dart';
import '../utils/widget_utility_extensions.dart';
import 'primary_button.dart';

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
        if (widget.popOnAction && mounted) context.pop(result);
      } finally {
        setState(() => isPositiveActionLoading = false);
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
        if (widget.popOnAction && mounted) context.pop(result);
      } finally {
        setState(() => isNegativeActionLoading = false);
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
