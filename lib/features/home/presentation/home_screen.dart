import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pasti_track/core/config.dart';
import 'package:pasti_track/features/events/presentation/pages/events_screen.dart';
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

  final List<Map> _options = [
    {
      "title": AppString.events,
      "screen": EventsScreen(showAppBar: false),
      "navigator": const BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.calendar),
        label: AppString.events,
      ),
    },
    {
      "title": AppString.routines,
      "screen": Routines(showAppBar: false),
      "navigator": const BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.alarm),
        label: AppString.routines,
      ),
    },
    {
      "title": AppString.medicaments,
      "screen": MedicationScreen(showAppBar: false),
      "navigator": const BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.bandage_fill),
        label: AppString.medicines,
      ),
    },
    {
      "title": AppString.settings,
      "screen": SettingsScreen(showAppBar: false),
      "navigator": const BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.settings),
        label: AppString.settings,
      ),
    },
  ];

  final List<Widget> _pages = [];
  final List<BottomNavigationBarItem> _navigators = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      subTextAppBar = _options[index]['title'];
    });
  }

  @override
  void initState() {
    super.initState();
    for (var e in _options) {
      _pages.add(e["screen"]);
      _navigators.add(e["navigator"]);
    }
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
        items: _navigators,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
