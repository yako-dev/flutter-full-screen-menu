import 'package:flutter/widgets.dart';
import 'package:full_screen_menu/src/models/gradients.dart';

/// A round gradient icon with a label below it, for use as a
/// `FullScreenMenu` item.
class FSMenuItem extends StatelessWidget {
  /// Text that will be displayed on the item.
  final Text? text;

  /// Icon that will be displayed on the item.
  final Icon? icon;

  /// The function that will be called when you click on item.
  final VoidCallback onTap;

  /// А gradient that will fill the background of your [icon].
  final Gradient? gradient;

  /// Creates a menu item. Only [onTap] is required.
  const FSMenuItem({
    super.key,
    this.text,
    this.icon,
    required this.onTap,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // The whole item is tappable, including the gap between icon and label.
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        children: <Widget>[
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: gradient ?? blueGreyGradient,
            ),
            child: icon,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: text,
          ),
        ],
      ),
    );
  }

  /// Returns a copy of this item with the given fields replaced.
  FSMenuItem copyWith({
    Text? text,
    Icon? icon,
    VoidCallback? onTap,
    Gradient? gradient,
  }) {
    return FSMenuItem(
      text: text ?? this.text,
      icon: icon ?? this.icon,
      onTap: onTap ?? this.onTap,
      gradient: gradient ?? this.gradient,
    );
  }
}
