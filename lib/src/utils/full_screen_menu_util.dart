import 'package:flutter/material.dart';

class FullScreenMenuUtil {
  static OverlayState? state;
  static OverlayEntry? entry;

  static bool _isVisible = false;

  /// Whether a menu is in the overlay. False once the overlay that held the
  /// menu is disposed (for example when the app or its navigator is replaced),
  /// even if [dismiss] was never called.
  static bool get isVisible => _isVisible && (state?.mounted ?? false);
  static set isVisible(bool value) => _isVisible = value;

  static void createView({
    required BuildContext context,
    required Widget child,
  }) {
    if (isVisible) return;
    state = Overlay.of(context);
    entry = OverlayEntry(builder: (_) => child);
    _isVisible = true;
    state!.insert(entry!);
  }

  static void dismiss() {
    if (!isVisible) return;
    _isVisible = false;
    entry?.remove();
  }
}
