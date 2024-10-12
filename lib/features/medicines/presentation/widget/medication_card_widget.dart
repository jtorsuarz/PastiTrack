import 'package:flutter/material.dart';

class MedicationCardWidget extends StatelessWidget {
  final String name;
  final String dose;

  const MedicationCardWidget(
      {super.key, required this.name, required this.dose});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(name,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text('Dosis: $dose',
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.w400)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
            ],
          ),
        ],
      ),
    );
  }
}
