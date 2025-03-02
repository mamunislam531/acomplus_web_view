import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget child;
  final double? height;
  const CustomAppBar({super.key, this.height, required this.child});

  @override
  Size get preferredSize => Size.fromHeight(height ?? 90);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 5),
      height: preferredSize.height,
      color: const Color(0xff406878),
      alignment: Alignment.bottomCenter,
      child: child,
    );
  }
}
