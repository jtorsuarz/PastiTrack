import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:pasti_track/core/config.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading:
          false, // Evita el botón de retroceso automático
      centerTitle: true, // Asegura que el título esté centrado
      title: const Text(AppString.appTitle),
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 0, // Quita la sombra del AppBar si no la quieres
      actions: [
        /*
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            context.read<AuthBloc>().add(AuthLoggedOut());
          },
        ),
        */
        IconButton(
          icon: const Icon(
            CupertinoIcons.settings,
            applyTextScaling: true,
          ),
          onPressed: () => context.push(AppUrls.settingsPath),
        ),
      ],
    );
  }
}
