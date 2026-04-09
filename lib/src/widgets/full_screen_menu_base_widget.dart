import 'dart:ui';

import 'package:flutter/material.dart';

class FullScreenMenuBaseWidget extends StatefulWidget {
  /// Background color of your FullScreenMenu
  final Color? backgroundColor;

  /// Function which is called by pressing the close button
  final VoidCallback? onHide;

  /// Menu items which you want to display
  final List<Widget>? items;

  /// Deprecated — no longer used. The widget uses its own BuildContext internally.
  @Deprecated('No longer needed. The widget resolves its own context.')
  final BuildContext? context;

  /// The animation with which the FullScreenMenu opens
  final Function(AnimationController) animationController;

  const FullScreenMenuBaseWidget({
    Key? key,
    required this.backgroundColor,
    this.onHide,
    this.items,
    @Deprecated('No longer needed. The widget resolves its own context.')
    // ignore: deprecated_member_use_from_same_package
    this.context,
    required this.animationController,
  }) : super(key: key);

  @override
  State<FullScreenMenuBaseWidget> createState() =>
      _FullScreenMenuBaseWidgetState();
}

class _FullScreenMenuBaseWidgetState extends State<FullScreenMenuBaseWidget>
    with SingleTickerProviderStateMixin {
  static const Duration _animationDuration = Duration(milliseconds: 200);

  late AnimationController animationController;
  late Animation<double> scaleAnimation;
  late Animation<double> fadeAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );
    widget.animationController(animationController);
    scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      animationController,
    );
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      animationController,
    );
    animationController.forward();
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
        child: ScaleTransition(
          scale: scaleAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: _buildContent(context),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
      child: Container(
        width: double.infinity,
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
          color: _getBackgroundColor(context),
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
                    spacing: 50,
                    runSpacing: 40,
                    alignment: WrapAlignment.center,
                    children: widget.items ?? [],
                  ),
                ),
                FloatingActionButton(
                  backgroundColor: Colors.white,
                  mini: true,
                  shape: const CircleBorder(
                    side: BorderSide(color: Colors.grey),
                  ),
                  onPressed: () async {
                    animationController.reverse();
                    await Future.delayed(_animationDuration);
                    widget.onHide?.call();
                  },
                  child: const Icon(Icons.close, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    if (widget.backgroundColor == null) {
      if (Theme.of(context).brightness == Brightness.dark) {
        return Colors.black;
      } else {
        // ignore: deprecated_member_use
        return Colors.white.withOpacity(0.85);
      }
    } else {
      // ignore: deprecated_member_use
      return widget.backgroundColor!.withOpacity(0.85);
    }
  }
}
