import 'package:flutter/material.dart';
import 'package:full_screen_menu/src/utils/full_screen_menu_util.dart';
import 'package:full_screen_menu/src/widgets/full_screen_menu_base_widget.dart';

AnimationController? _animationController;
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
    if (_animationController == null) return;
    _animationController!.reverse();
    await Future.delayed(_animationDuration);
    FullScreenMenuUtil.dismiss();
  }

  /// Is the menu currently visible.
  static bool get isVisible => FullScreenMenuUtil.isVisible;
}
