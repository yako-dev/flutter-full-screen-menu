import 'package:flutter/material.dart';
import 'package:full_screen_menu/src/utils/full_screen_menu_util.dart';
import 'package:full_screen_menu/src/widgets/full_screen_menu_base_widget.dart';

AnimationController? _animationController;
Duration _animationDuration = Duration(milliseconds: 200);

class FullScreenMenu {
  static void show(
    BuildContext context, {
    List<Widget>? items,
    Color? backgroundColor,
    bool closeMenuOnBackgroundTap = true,
  }) {
    FullScreenMenuUtil.createView(
      context: context,
      child: closeMenuOnBackgroundTap
          ? GestureDetector(
              onTap: () {
                if (FullScreenMenu.isVisible) {
                  FullScreenMenu.hide();
                }
              },
              child: FullScreenMenuBaseWidget(
                animationController: (animation) {
                  _animationController = animation;
                },
                onHide: FullScreenMenuUtil.dismiss,
                backgroundColor: backgroundColor,
                items: items,
                context: context,
              ),
            )
          : FullScreenMenuBaseWidget(
              animationController: (animation) {
                _animationController = animation;
              },
              onHide: FullScreenMenuUtil.dismiss,
              backgroundColor: backgroundColor,
              items: items,
              context: context,
            ),
    );
  }

  static void hide() async {
    _animationController!.reverse();
    await Future.delayed(_animationDuration);
    FullScreenMenuUtil.dismiss();
  }

  static get isVisible => FullScreenMenuUtil.isVisible;
}
