import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pasti_track/core/config.dart';
import 'package:pasti_track/features/medicines/presentation/pages/medication_screen.dart';
import 'package:pasti_track/features/routines/presentation/pages/routines.dart';
import 'package:pasti_track/features/settings/presentation/pages/settings_screen.dart';
import 'package:pasti_track/widgets/custom_appbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String subTextAppBar = "";

  final List<Widget> _pages = [
    Routines(showAppBar: false),
    MedicationScreen(showAppBar: false),
    SettingsScreen(showAppBar: false),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (_selectedIndex) {
        case 0:
          subTextAppBar = AppString.routines;
          break;
        case 1:
          subTextAppBar = AppString.medicaments;
          break;
        case 2:
          subTextAppBar = AppString.settings;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        subtitle: subTextAppBar,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home), label: AppString.home),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.bandage_fill),
              label: AppString.medicines),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.alarm), label: AppString.routines),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
