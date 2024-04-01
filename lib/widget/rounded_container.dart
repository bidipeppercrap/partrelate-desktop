import 'package:flutter/material.dart';

class RoundedContainer extends StatelessWidget {
  const RoundedContainer(
      {super.key,
      this.child,
      this.backgroundColor = Colors.grey,
      this.borderColor = Colors.black45,
      this.padding = 9,
      this.radius = 12,
      this.borderWidth = 3});

  final Widget? child;
  final Color backgroundColor;
  final Color borderColor;
  final double padding;
  final double radius;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          border: Border.all(color: borderColor, width: borderWidth)),
      padding: EdgeInsets.all(padding),
      child: child,
    );
  }
}
