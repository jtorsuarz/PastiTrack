import 'package:flutter/material.dart';
import 'package:pasti_track/core/config.dart';

// ignore: must_be_immutable
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
      automaticallyImplyLeading:
          false, // Evita el botón de retroceso automático
      centerTitle: true, // Asegura que el título esté centrado
      title: Text(completeText),
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 0, // Quita la sombra del AppBar si no la quieres
      /*  
      actions: [
      IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            context.read<AuthBloc>().add(AuthLoggedOut());
          },
        ),
        IconButton(
          icon: const Icon(
            CupertinoIcons.settings,
            applyTextScaling: true,
          ),
          onPressed: () => context.push(AppUrls.settingsPath),
        ),
      ],
         */
    );
  }
}
