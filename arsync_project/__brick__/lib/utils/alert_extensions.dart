import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/confirmation_sheet.dart';
import '../widgets/primary_sheet.dart';
import 'exception_toolkit.dart';

extension AlertExtensions on BuildContext {
  void showCustomSnackbar(SnackBar snackbar) {
    hideSnackBar();
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackbar);
  }

  void hideSnackBar() {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
  }

  void showSuccessSnackBar(
    String text, {
    int? milliseconds,
    SnackBarAction? action,
  }) {
    showPrimarySnackbar(
      text,
      backgroundColor: Colors.green.shade600,
      milliseconds: milliseconds,
      action: action,
    );
  }

  void showErrorSnackBar(
    String text, {
    int? milliseconds,
    SnackBarAction? action,
  }) {
    showPrimarySnackbar(
      text,
      backgroundColor: Colors.red.shade600,
      milliseconds: milliseconds,
      action: action,
    );
  }

  void showExceptionSnackBar(
    Object error, {
    int? milliseconds,
    SnackBarAction? action,
  }) {
    final errorMessage = exceptionToolkit.handleException(error);
    showErrorSnackBar(
      errorMessage.briefTitle,
      milliseconds: milliseconds,
      action: action,
    );
  }

  void showPrimarySnackbar(
    final String text, {
    Color? textColor,
    Color? backgroundColor,
    int? milliseconds,
    SnackBarAction? action,
    Color? borderColor,
    double borderWidth = 1.0,
    double borderRadius = 10,
  }) {
    final snackbar = SnackBar(
      content: Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Text(
          text,
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      duration: Duration(milliseconds: milliseconds ?? 2000),
      backgroundColor: backgroundColor ?? const Color(0XFF28282B),
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(
          color: borderColor ?? Colors.white12,
          width: borderWidth,
        ),
      ),
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      showCloseIcon: action == null,
      closeIconColor: textColor ?? Colors.white,
      action: action,
    );

    showCustomSnackbar(snackbar);
  }

  Future<void> showMessageDialog<T>(
    String title, {
    String? message,
    Widget? content,
    String buttonText = 'OK',
    T? popResult,
  }) {
    return showDialog(
      context: this,
      builder: (context) {
        final titleWidget = Text(title);
        final contentWidget = content ?? (message != null ? Text(message) : null);

        if (Platform.isAndroid) {
          return AlertDialog(
            title: titleWidget,
            content: contentWidget,
            actions: <Widget>[
              TextButton(
                onPressed: () => context.pop(popResult),
                child: Text(buttonText),
              ),
            ],
          );
        }

        return CupertinoAlertDialog(
          title: titleWidget,
          content: contentWidget,
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () => context.pop(popResult),
              child: Text(buttonText),
            ),
          ],
        );
      },
    );
  }

  Future<void> showExceptionDialog<T>(
    Object exception, {
    String buttonText = 'OK',
    T? popResult,
  }) {
    final error = exceptionToolkit.handleException(exception);
    return showMessageDialog(
      error.briefTitle,
      message: error.message,
      buttonText: buttonText,
      popResult: popResult,
    );
  }

  Future<T?> showConfirmationDialog<T>(
    String title, {
    String? message,
    Widget? content,
    String actionText = 'Yes',
    String actionTextNegative = 'No',
    FutureOr<T?> Function()? onActionPressed,
    FutureOr<T?> Function()? onActionPressedNegative,
  }) {
    return showDialog<T?>(
      context: this,
      builder: (dialogContext) {
        return _ConfirmationDialogContent<T>(
          title: title,
          message: message,
          content: content,
          actionText: actionText,
          actionTextNegative: actionTextNegative,
          onActionPressed: onActionPressed,
          onActionPressedNegative: onActionPressedNegative,
        );
      },
    );
  }

  Future<T?> showPrimarySheet<T>({
    required String title,
    required Widget child,
    bool useRootNavigator = true,
    bool isScrollControlled = true,
    bool isDismissible = true,
  }) {
    return PrimarySheet.show<T>(
      this,
      child: child,
      useRootNavigator: useRootNavigator,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
    );
  }

  Future<T?> showConfirmationSheet<T>({
    required String title,
    required String message,
    IconData? icon,
    Widget? iconWidget,
    String positiveButtonText = 'Okay',
    Color? circleColor,
    Color? iconColor,
    String? negativeButtonText,
    FutureOr<dynamic> Function()? onPositiveAction,
    FutureOr<dynamic> Function()? onNegativeAction,
    Color? positiveButtonColor,
    Color? negativeButtonColor,
  }) {
    return PrimarySheet.show(
      this,
      child: ConfirmationSheet(
        title: title,
        message: message,
        icon: icon ?? Icons.info_outline_rounded,
        iconWidget: iconWidget,
        circleColor: circleColor,
        iconColor: iconColor,
        positiveButtonText: positiveButtonText,
        negativeButtonText: negativeButtonText,
        onNegativeAction: onNegativeAction,
        onPositiveAction: onPositiveAction,
        positiveButtonColor: positiveButtonColor,
        negativeButtonColor: negativeButtonColor,
      ),
    );
  }

  Future<T?> showSuccessSheet<T>({
    required String title,
    required String message,
    Widget? iconWidget,
    IconData icon = Icons.check_circle_outline_rounded,
    String positiveButtonText = 'Close',
    Color? iconColor = Colors.green,
    Color? circleColor,
    String? negativeButtonText,
    FutureOr<dynamic> Function()? onPositiveAction,
    FutureOr<dynamic> Function()? onNegativeAction,
    Color? positiveButtonColor,
    Color? negativeButtonColor,
  }) {
    return PrimarySheet.show(
      this,
      child: ConfirmationSheet(
        title: title,
        message: message,
        iconWidget: iconWidget,
        icon: icon,
        circleColor: circleColor ?? Colors.green.withValues(alpha: 0.2),
        iconColor: iconColor,
        positiveButtonText: positiveButtonText,
        negativeButtonText: negativeButtonText,
        onNegativeAction: onNegativeAction,
        onPositiveAction: onPositiveAction,
      ),
    );
  }

  Future<T?> showErrorSheet<T>({
    required String title,
    required String message,
    Widget? iconWidget,
    IconData icon = Icons.error_outline,
    String positiveButtonText = 'Okay',
    Color? iconColor = Colors.red,
    Color? circleColor,
    String? negativeButtonText,
    FutureOr<dynamic> Function()? onPositiveAction,
    FutureOr<dynamic> Function()? onNegativeAction,
    //
    bool isDismissible = true,
    bool popOnAction = true,
    Color? positiveButtonColor,
    Color? negativeButtonColor,
  }) {
    return PrimarySheet.show(
      this,
      isDismissible: isDismissible,
      child: ConfirmationSheet(
        title: title,
        message: message,
        icon: icon,
        circleColor: circleColor,
        iconColor: iconColor,
        iconWidget: iconWidget,
        positiveButtonText: positiveButtonText,
        negativeButtonText: negativeButtonText,
        onNegativeAction: onNegativeAction,
        onPositiveAction: onPositiveAction,
        popOnAction: popOnAction,
        positiveButtonColor: positiveButtonColor,
        negativeButtonColor: negativeButtonColor,
      ),
    );
  }

  Future<T?> showExceptionSheet<T>(
    Object exception, {
    Widget? iconWidget,
    String positiveButtonText = 'Okay',
    Color? iconColor = Colors.red,
    Color? circleColor,
    bool isDismissible = true,
  }) {
    final error = exceptionToolkit.handleException(exception);
    return PrimarySheet.show(
      this,
      isDismissible: isDismissible,
      child: ConfirmationSheet(
        title: error.title,
        message: error.message,
        icon: error.icon,
        circleColor: circleColor,
        iconColor: iconColor,
        iconWidget: iconWidget,
        positiveButtonText: positiveButtonText,
      ),
    );
  }
}



class _ConfirmationDialogContent<T> extends StatefulWidget {
  final String title;
  final String? message;
  final Widget? content;
  final String actionText;
  final String actionTextNegative;
  final FutureOr<T?> Function()? onActionPressed;
  final FutureOr<T?> Function()? onActionPressedNegative;

  const _ConfirmationDialogContent({
    required this.title,
    required this.actionText,
    required this.actionTextNegative,
    this.message,
    this.content,
    this.onActionPressed,
    this.onActionPressedNegative,
  });

  @override
  State<_ConfirmationDialogContent<T>> createState() =>
      _ConfirmationDialogContentState<T>();
}

class _ConfirmationDialogContentState<T>
    extends State<_ConfirmationDialogContent<T>> {
  bool _isActionLoading = false;
  bool _isActionNegativeLoading = false;

  bool get _waitForActionResult =>
      widget.onActionPressed.runtimeType.toString().contains('Future');

  bool get _waitForNegativeActionResult =>
      widget.onActionPressedNegative.runtimeType.toString().contains('Future');

  Future<void> _handlePositiveAction() async {
    if (!_waitForActionResult) {
      widget.onActionPressed?.call() ?? context.pop(true);
      return;
    }
    setState(() => _isActionLoading = true);
    try {
      final result = await widget.onActionPressed?.call() ?? true;
      if (!mounted) return;
      context.pop(result);
    } catch (_) {
      if (!mounted) return;
      context.pop();
    } finally {
      if (mounted) setState(() => _isActionLoading = false);
    }
  }

  Future<void> _handleNegativeAction() async {
    if (!_waitForNegativeActionResult) {
      widget.onActionPressedNegative?.call() ?? context.pop(false);
      return;
    }
    setState(() => _isActionNegativeLoading = true);
    try {
      final result = await widget.onActionPressedNegative?.call() ?? true;
      if (!mounted) return;
      context.pop(result);
    } catch (_) {
      if (!mounted) return;
      widget.onActionPressedNegative?.call();
    } finally {
      if (mounted) setState(() => _isActionNegativeLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleWidget = Text(widget.title);
    final contentWidget =
        widget.content ?? (widget.message != null ? Text(widget.message!) : null);

    final actionButtonChild = _isActionLoading
        ? const CupertinoActivityIndicator()
        : Text(widget.actionText);

    final actionButtonNegativeChild = _isActionNegativeLoading
        ? const CupertinoActivityIndicator()
        : Text(widget.actionTextNegative);

    if (Platform.isAndroid) {
      return AlertDialog(
        title: titleWidget,
        content: contentWidget,
        actions: <Widget>[
          TextButton(
            onPressed: _handleNegativeAction,
            child: actionButtonNegativeChild,
          ),
          TextButton(onPressed: _handlePositiveAction, child: actionButtonChild),
        ],
      );
    }

    return CupertinoAlertDialog(
      title: titleWidget,
      content: contentWidget,
      actions: <Widget>[
        CupertinoDialogAction(
          onPressed: _handleNegativeAction,
          child: actionButtonNegativeChild,
        ),
        CupertinoDialogAction(
          onPressed: _handlePositiveAction,
          child: actionButtonChild,
        ),
      ],
    );
  }
}