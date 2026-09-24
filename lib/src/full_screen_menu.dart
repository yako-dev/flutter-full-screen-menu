import 'package:flutter/material.dart';
import 'package:full_screen_menu/src/utils/full_screen_menu_util.dart';
import 'package:full_screen_menu/src/widgets/full_screen_menu_base_widget.dart';

/// Controller of the visible menu. Null until the menu's first build.
AnimationController? _animationController;

/// The overlay entry that [FullScreenMenu.hide] is animating out.
OverlayEntry? _hidingEntry;

const Duration _animationDuration = Duration(milliseconds: 200);

/// Shows and hides the full-screen menu. Only one menu is visible at a time.
class FullScreenMenu {
  /// Shows a menu with [items] over the whole screen, in the [Overlay] of
  /// [context]. Does nothing if a menu is already visible.
  ///
  /// [backgroundColor] is drawn at 85% opacity. When it is null the background
  /// is black in a dark theme and white otherwise. With
  /// [closeMenuOnBackgroundTap] a tap outside the items closes the menu.
  static void show(
    BuildContext context, {
    List<Widget>? items,
    Color? backgroundColor,
    bool closeMenuOnBackgroundTap = true,
  }) {
    if (isVisible &&
        _hidingEntry != null &&
        FullScreenMenuUtil.entry == _hidingEntry) {
      // hide() is still animating the previous menu out. Remove it now so this
      // menu can open.
      FullScreenMenuUtil.dismiss();
    }
    if (isVisible) return;

    // The previous menu's controller is disposed with that menu.
    _animationController = null;
    final child = FullScreenMenuBaseWidget(
      animationController: (animation) {
        _animationController = animation;
      },
      onHide: FullScreenMenuUtil.dismiss,
      backgroundColor: backgroundColor,
      items: items,
    );

    FullScreenMenuUtil.createView(
      context: context,
      child: closeMenuOnBackgroundTap
          ? GestureDetector(
              onTap: () {
                if (FullScreenMenu.isVisible) {
                  FullScreenMenu.hide();
                }
              },
              child: child,
            )
          : child,
    );
  }

  /// Hides the visible menu with the closing animation.
  static void hide() async {
    final entry = FullScreenMenuUtil.entry;
    // Nothing to hide, or this menu is already closing.
    if (!isVisible || entry == null || entry == _hidingEntry) return;
    _hidingEntry = entry;
    _animationController?.reverse();
    await Future.delayed(_animationDuration);
    // Only remove the menu this call started to hide, not one opened since.
    if (FullScreenMenuUtil.entry == entry) FullScreenMenuUtil.dismiss();
  }

  /// Is the menu currently visible.
  static bool get isVisible => FullScreenMenuUtil.isVisible;
}
