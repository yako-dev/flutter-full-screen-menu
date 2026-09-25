import 'package:flutter/widgets.dart';
import 'package:full_screen_menu/src/utils/full_screen_menu_util.dart';
import 'package:full_screen_menu/src/utils/menu_back_handler.dart';
import 'package:full_screen_menu/src/widgets/full_screen_menu_base_widget.dart';

/// Controller of the visible menu. Null until the menu's first build.
AnimationController? _animationController;

/// The overlay entry that [FullScreenMenu.hide] is animating out.
OverlayEntry? _hidingEntry;

/// Closes the visible menu on the system back button, if it was asked to.
MenuBackHandler? _backHandler;

const Duration _animationDuration = Duration(milliseconds: 200);

/// Shows and hides the full-screen menu. Only one menu is visible at a time.
class FullScreenMenu {
  /// Shows a menu with [items] over the whole screen, in the [Overlay] of
  /// [context]. Does nothing if a menu is already visible.
  ///
  /// [backgroundColor] is drawn at 85% opacity. When it is null the background
  /// is black in a dark theme and white otherwise. With
  /// [closeMenuOnBackgroundTap] a tap outside the items closes the menu.
  ///
  /// With [closeMenuOnBackButton] the system back (the Android back button or
  /// back gesture) closes the menu instead of leaving the route of [context]
  /// or closing the app. A `PopScope` with `canPop: false` on that route still
  /// gets the back first. Pass false to handle back yourself.
  static void show(
    BuildContext context, {
    List<Widget>? items,
    Color? backgroundColor,
    bool closeMenuOnBackgroundTap = true,
    bool closeMenuOnBackButton = true,
  }) {
    if (isVisible &&
        _hidingEntry != null &&
        FullScreenMenuUtil.entry == _hidingEntry) {
      // hide() is still animating the previous menu out. Remove it now so this
      // menu can open.
      _dismiss();
    }
    if (isVisible) return;

    // The previous menu's controller is disposed with that menu.
    _animationController = null;
    final child = FullScreenMenuBaseWidget(
      animationController: (animation) {
        _animationController = animation;
      },
      onHide: _dismiss,
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

    // Left over if the app that held the previous menu was replaced.
    _backHandler?.remove();
    _backHandler = closeMenuOnBackButton
        ? MenuBackHandler.register(context, hide)
        : null;
  }

  /// Hides the visible menu with the closing animation.
  static void hide() async {
    final entry = FullScreenMenuUtil.entry;
    // Nothing to hide, or this menu is already closing.
    if (!isVisible || entry == null || entry == _hidingEntry) return;
    _hidingEntry = entry;
    // Back is no longer for the menu once it starts closing.
    _backHandler?.remove();
    _animationController?.reverse();
    await Future.delayed(_animationDuration);
    // Only remove the menu this call started to hide, not one opened since.
    if (FullScreenMenuUtil.entry == entry) _dismiss();
  }

  /// Is the menu currently visible.
  static bool get isVisible => FullScreenMenuUtil.isVisible;

  static void _dismiss() {
    _backHandler?.remove();
    FullScreenMenuUtil.dismiss();
  }
}
