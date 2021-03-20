import 'package:flutter/material.dart';

class FullScreenMenuUtil {
  static OverlayState? state;
  static OverlayEntry? entry;
  static bool isVisible = false;

  static void createView({
    required BuildContext context,
    required Widget child,
  }) async {
    if (!isVisible) {
      dismiss();
      state = Overlay.of(context);
      entry = OverlayEntry(builder: (_) => child);
      isVisible = true;
      state!.insert(entry!);
    }
  }

  static void dismiss() async {
    if (!isVisible) {
      return;
    }
    isVisible = false;
    entry?.remove();
  }
}
