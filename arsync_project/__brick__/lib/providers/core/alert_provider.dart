import 'dart:async' show FutureOr;

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../utils/utils.dart';
import 'router_provider.dart';

final alertProvider = Provider.autoDispose((ref) {
  return _AlertProvider(ref);
});

class _AlertProvider {
  final Ref ref;

  _AlertProvider(this.ref);

  void showCustomSnackbar(SnackBar snackbar) {
    final context = ref.read(routerProvider).navigatorKey.currentContext;
    if (context == null) return;
    context.showCustomSnackbar(snackbar);
  }

  void showSuccessSnackBar(
    String text, {
    int? milliseconds,
    SnackBarAction? action,
  }) {
    final context = ref.read(routerProvider).navigatorKey.currentContext;
    if (context == null) return;
    context.showSuccessSnackBar(
      text,
      milliseconds: milliseconds,
      action: action,
    );
  }

  void showErrorSnackBar(
    String text, {
    int? milliseconds,
    SnackBarAction? action,
  }) {
    final context = ref.read(routerProvider).navigatorKey.currentContext;
    if (context == null) return;
    context.showErrorSnackBar(text, milliseconds: milliseconds, action: action);
  }

  void showExceptionSnackBar(
    Object error, {
    int? milliseconds,
    SnackBarAction? action,
  }) {
    final context = ref.read(routerProvider).navigatorKey.currentContext;
    if (context == null) return;

    context.showExceptionSnackBar(
      error,
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
    final context = ref.read(routerProvider).navigatorKey.currentContext;
    if (context == null) return;
    context.showPrimarySnackbar(
      text,
      textColor: textColor,
      backgroundColor: backgroundColor,
      milliseconds: milliseconds,
      action: action,
      borderColor: borderColor,
      borderWidth: borderWidth,
      borderRadius: borderRadius,
    );
  }

  Future<void> showMessageDialog({
    required String title,
    String? message,
    Widget? content,
  }) {
    final context = ref.read(routerProvider).navigatorKey.currentContext;
    if (context == null) return Future.value();

    return context.showMessageDialog(title, message: message, content: content);
  }

  Future<void> showExceptionDialog<T>(
    Object exception, {
    String buttonText = 'OK',
    T? popResult,
  }) {
    final context = ref.read(routerProvider).navigatorKey.currentContext;
    if (context == null) return Future.value();
    return context.showExceptionDialog(
      exception,
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
    final context = ref.read(routerProvider).navigatorKey.currentContext;
    if (context == null) return Future.value();

    return context.showConfirmationDialog(
      title,
      message: message,
      content: content,
      actionText: actionText,
      actionTextNegative: actionTextNegative,
      onActionPressed: onActionPressed,
      onActionPressedNegative: onActionPressedNegative,
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
    final context = ref.read(routerProvider).navigatorKey.currentContext;
    if (context == null) return Future.value();
    return context.showConfirmationSheet(
      title: title,
      message: message,
      circleColor: circleColor,
      iconColor: iconColor,
      positiveButtonText: positiveButtonText,
      negativeButtonText: negativeButtonText,
      onPositiveAction: onPositiveAction,
      onNegativeAction: onNegativeAction,
      positiveButtonColor: positiveButtonColor,
      icon: icon,
      iconWidget: iconWidget,
      negativeButtonColor: negativeButtonColor,
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
    final context = ref.read(routerProvider).navigatorKey.currentContext;
    if (context == null) return Future.value();
    return context.showSuccessSheet(
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
      positiveButtonColor: positiveButtonColor,
      negativeButtonColor: negativeButtonColor,
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
    final context = ref.read(routerProvider).navigatorKey.currentContext;
    if (context == null) return Future.value();
    return context.showErrorSheet(
      title: title,
      message: message,
      iconWidget: iconWidget,
      icon: icon,
      circleColor: circleColor,
      iconColor: iconColor,
      positiveButtonText: positiveButtonText,
      negativeButtonText: negativeButtonText,
      onNegativeAction: onNegativeAction,
      onPositiveAction: onPositiveAction,
      popOnAction: popOnAction,
      positiveButtonColor: positiveButtonColor,
      negativeButtonColor: negativeButtonColor,
      isDismissible: isDismissible,
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
    final context = ref.read(routerProvider).navigatorKey.currentContext;
    if (context == null) return Future.value();
    return context.showExceptionSheet(
      exception,
      iconWidget: iconWidget,
      positiveButtonText: positiveButtonText,
      iconColor: iconColor,
      circleColor: circleColor,
      isDismissible: isDismissible,
    );
  }
}

extension AlertRef on Ref {
  _AlertProvider get alert => read(alertProvider);

  void showSuccessSnackBar(String text) => alert.showSuccessSnackBar(text);
  void showErrorSnackBar(String text) => alert.showErrorSnackBar(text);

  Future<void> showErrorSheet({
    required String title,
    required String message,
    Widget? iconWidget,
    IconData icon = Icons.error_outline,
  }) {
    return alert.showErrorSheet(
      title: title,
      message: message,
      iconWidget: iconWidget,
      icon: icon,
    );
  }

  void showSuccessSheet({
    required String title,
    required String message,
    Widget? iconWidget,
    IconData icon = Icons.check_circle_outline_rounded,
  }) {
    alert.showSuccessSheet(
      title: title,
      message: message,
      iconWidget: iconWidget,
      icon: icon,
    );
  }

  void showExceptionSnackBar(Object exception) =>
      alert.showExceptionSnackBar(exception);

  void showExceptionDialog(Object exception) =>
      alert.showExceptionDialog(exception);

  void showExceptionSheet(Object exception) =>
      alert.showExceptionSheet(exception);
}
