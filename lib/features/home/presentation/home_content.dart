import 'package:flutter/material.dart';
import 'package:pasti_track/core/constants/app_urls.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        AppUrls.homePath,
        style: TextStyle(color: Colors.amber),
      ),
    );
  }
}
