import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:full_screen_menu/src/utils/full_screen_menu_util.dart';

class FullScreenMenuBaseWidget extends StatefulWidget {
  final Color? backgroundColor;
  final VoidCallback? onHide;
  final double? blurPower;
  final List<Widget>? items;
  final BuildContext? context;
  final Function(AnimationController) animationController;

  const FullScreenMenuBaseWidget(
      {Key? key,
      required this.backgroundColor,
      this.onHide,
      this.blurPower,
      this.items,
      this.context,
      required this.animationController})
      : super(key: key);

  @override
  __TDBaseWidgetState createState() => __TDBaseWidgetState();
}

class __TDBaseWidgetState extends State<FullScreenMenuBaseWidget>
    with SingleTickerProviderStateMixin {
  Duration animationDuration = Duration(milliseconds: 200);
  AnimationController? scaleController;

  late AnimationController animationController;

  late Animation<double> scaleAnimation;
  late Animation<double> fadeAnimation;

  final Tween<double> scaleTween = Tween<double>(begin: 0.9, end: 1.0);
  final Tween<double> fadeTween = Tween<double>(begin: 0.0, end: 1.0);

  @override
  void initState() {
    initAnimations();
    if (FullScreenMenuUtil.isVisible == false) {
      closeAnimations();
    }
    super.initState();
  }

  Future<void> initAnimations() async {
    animationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    widget.animationController(animationController);
    scaleAnimation = scaleTween.animate(animationController);
    fadeAnimation = fadeTween.animate(animationController);
    animationController.forward();
    await Future.delayed(animationDuration);
  }

  Future<void> closeAnimations() async {
    animationController.reverse();
    await Future.delayed(animationDuration);
    widget.onHide!();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Colors.transparent,
        child: Container(
          child: buildBody(),
        ),
      ),
    );
  }

  Widget buildBody() {
    return ScaleTransition(
      scale: scaleAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: buildContent(),
      ),
    );
  }

  Widget buildContent() {
    double screenWidth =
        MediaQuery.of(context).orientation == Orientation.portrait
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.height;

    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 2.0,
        sigmaY: 2.0,
      ),
      child: Container(
        width: screenWidth,
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
          color: getBackgroundColor(),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 35),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Wrap(
                    children: widget.items!,
                    spacing: 50,
                    runSpacing: 40,
                    alignment: WrapAlignment.center,
                  ),
                ),
                FloatingActionButton(
                  backgroundColor: Colors.white,
                  mini: true,
                  shape: CircleBorder(side: BorderSide(color: Colors.grey)),
                  child: Icon(Icons.close, color: Colors.grey),
                  onPressed: () async {
                    animationController.reverse();
                    await Future.delayed(animationDuration);
                    widget.onHide!();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color getBackgroundColor() {
    // TODO not working
    if (widget.backgroundColor == null) {
      if (Theme.of(widget.context!).brightness == Brightness.dark) {
        return Colors.black;
      } else {
        return Colors.white.withOpacity(0.85);
      }
    } else {
      return widget.backgroundColor!.withOpacity(0.85);
    }
  }
}
