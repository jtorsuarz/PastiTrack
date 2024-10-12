import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pasti_track/core/config.dart';
import 'package:pasti_track/features/home/presentation/home_content.dart';
import 'package:pasti_track/features/medicines/presentation/pages/medication_screen.dart';
import 'package:pasti_track/widgets/custom_appbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const MedicationScreen(),
    const Center(
      child: Text(
        AppUrls.routinesPath,
        style: TextStyle(color: Colors.amber),
      ),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
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
