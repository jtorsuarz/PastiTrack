import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pasti_track/core/constants/app_urls.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavigationBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'Historial',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Ajustes',
        ),
      ],
      currentIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            context.go(AppUrls.homePath);
            break;
          case 1:
            context.go(AppUrls.historyPath);
            break;
          case 2:
            context.go(AppUrls.routinesPath);
            break;
        }
      },
    );
  }
}
