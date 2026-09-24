import 'dart:ui';

import 'package:material_ui/material_ui.dart';

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
    super.key,
    required this.backgroundColor,
    this.onHide,
    this.items,
    @Deprecated('No longer needed. The widget resolves its own context.')
    // ignore: deprecated_member_use_from_same_package
    this.context,
    required this.animationController,
  });

  @override
  State<FullScreenMenuBaseWidget> createState() =>
      _FullScreenMenuBaseWidgetState();
}

class _FullScreenMenuBaseWidgetState extends State<FullScreenMenuBaseWidget>
    with SingleTickerProviderStateMixin {
  static const Duration _animationDuration = Duration(milliseconds: 200);

  /// 85% opacity. `withAlpha` rather than `withValues(alpha: 0.85)` keeps the
  /// color exactly 217/255, as in earlier versions.
  static const int _backgroundAlpha = 217;

  late AnimationController animationController;
  late Animation<double> scaleAnimation;
  late Animation<double> fadeAnimation;
  bool _closing = false;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );
    widget.animationController(animationController);
    scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(animationController);
    fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(animationController);
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ScaleTransition(
        scale: scaleAnimation,
        child: FadeTransition(
          opacity: fadeAnimation,
          child: _buildContent(context),
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
        decoration: BoxDecoration(color: _getBackgroundColor(context)),
        // The background covers the whole screen, including the status bar and
        // home indicator areas; the items and close button stay inside them.
        child: SafeArea(
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
                    onPressed: _close,
                    child: const Icon(Icons.close, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _close() async {
    if (_closing) return;
    _closing = true;
    animationController.reverse();
    await Future.delayed(_animationDuration);
    // Skip if the menu was already removed, so a menu opened since stays.
    if (mounted) widget.onHide?.call();
  }

  Color _getBackgroundColor(BuildContext context) {
    if (widget.backgroundColor == null) {
      if (Theme.of(context).brightness == Brightness.dark) {
        return Colors.black;
      } else {
        return Colors.white.withAlpha(_backgroundAlpha);
      }
    } else {
      return widget.backgroundColor!.withAlpha(_backgroundAlpha);
    }
  }
}
