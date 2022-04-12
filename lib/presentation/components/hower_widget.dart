import 'package:flutter/material.dart';

class HowerWidget extends StatefulWidget {
  const HowerWidget({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  State<HowerWidget> createState() => _HowerWidgetState();
}

class _HowerWidgetState extends State<HowerWidget> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: isHovered
              ? Border.all(
                  color: Colors.yellow,
                  width: 1,
                )
              : null),
      child: widget.child,
    );
  }
}
