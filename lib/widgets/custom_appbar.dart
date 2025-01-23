import 'package:flutter/material.dart';
import 'package:pasti_track/core/config.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  String subtitle;

  CustomAppBar({super.key, this.subtitle = ""});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    String completeText = "${AppString.appTitle} ";
    if (subtitle.isNotEmpty) {
      completeText += " $subtitle";
    }

    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text(completeText),
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 0,
    );
  }
}
