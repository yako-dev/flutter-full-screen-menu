import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:full_screen_menu/src/models/gradients.dart';

class FSMenuItem extends StatelessWidget {
  /// Text that will be displayed on the item.
  final Text? text;

  /// Icon that will be displayed on the item.
  final Icon? icon;

  /// The function that will be called when you click on item.
  final Function onTap;

  /// А gradient that will fill the background of your [icon].
  final Gradient? gradient;

  const FSMenuItem({
    Key? key,
    this.text,
    this.icon,
    required this.onTap,
    this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function(),
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

  FSMenuItem copyWith({
    Text? text,
    Icon? icon,
    Function? onTap,
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
