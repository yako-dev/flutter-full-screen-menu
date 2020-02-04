import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FSMenuItem extends StatelessWidget {
  final Text text;
  final Icon icon;
  final Function onTap;
  final Gradient gradient;

  const FSMenuItem({
    Key key,
    this.text,
    this.icon,
    this.onTap,
    this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: <Widget>[
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: gradient,
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
    Text text,
    Icon icon,
    Function onTap,
    Gradient gradient,
  }) {
    return FSMenuItem(
      text: text ?? this.text,
      icon: icon ?? this.icon,
      onTap: onTap ?? this.onTap,
      gradient: gradient ?? this.gradient,
    );
  }
}
