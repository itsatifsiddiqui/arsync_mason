import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// A callback triggered when the keyboard visibility changes.
typedef KeyboardVisibilityCallback = FutureOr<void> Function(
  bool isVisible,
);

/// Returns a [bool] indicating if the keyboard is visible and rebuilds the widget when it changes.
bool useIsKeyboardVisible() {
  return use(const _KeyboardVisibilityHook(rebuildOnChange: true));
}

/// Listens to the keyboard visibility changes.
void useOnKeyboardVisibilityChange(KeyboardVisibilityCallback onVisibilityChange) {
  return use(_KeyboardVisibilityHook(onVisibilityChange: onVisibilityChange));
}

class _KeyboardVisibilityHook extends Hook<bool> {
  const _KeyboardVisibilityHook({
    this.rebuildOnChange = false,
    this.onVisibilityChange,
  }) : super();

  final bool rebuildOnChange;
  final KeyboardVisibilityCallback? onVisibilityChange;

  @override
  _KeyboardVisibilityHookState createState() => _KeyboardVisibilityHookState();
}

class _KeyboardVisibilityHookState extends HookState<bool, _KeyboardVisibilityHook>
    with WidgetsBindingObserver {
  late bool _isKeyboardVisible;

  @override
  String? get debugLabel => 'useIsKeyboardVisible';

  @override
  void initHook() {
    super.initHook();
    _isKeyboardVisible = _checkKeyboardVisibility();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  bool build(BuildContext context) => _isKeyboardVisible;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final isVisibleNow = _checkKeyboardVisibility();
    if (isVisibleNow != _isKeyboardVisible) {
      _isKeyboardVisible = isVisibleNow;
      hook.onVisibilityChange?.call(isVisibleNow);

      if (hook.rebuildOnChange) {
        setState(() {});
      }
    }
  }

  bool _checkKeyboardVisibility() {
    final viewInsetsBottom =
        WidgetsBinding.instance.platformDispatcher.views.first.viewInsets.bottom;
    return viewInsetsBottom > 100;
  }
}
