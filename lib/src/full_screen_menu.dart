import 'package:flutter/material.dart';
import 'package:full_screen_menu/src/utils/full_screen_menu_util.dart';
import 'package:full_screen_menu/src/widgets/full_screen_menu_base_widget.dart';

class FullScreenMenu {
  static void show(
    BuildContext context, {
    List<Widget> items,
    Color backgroundColor,
  }) {
    FullScreenMenuUtil.createView(
      context: context,
      child: FullScreenMenuBaseWidget(
        onHide: FullScreenMenuUtil.dismiss,
        backgroundColor: backgroundColor,
        items: items,
        context: context,
      ),
    );
  }

  static void hide() => FullScreenMenuUtil.dismiss();

  static get isVisible => FullScreenMenuUtil.isVisible;
}
