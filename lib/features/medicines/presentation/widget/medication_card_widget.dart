import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pasti_track/core/config.dart';
import 'package:pasti_track/features/medicines/domain/entities/medicament.dart';
import 'package:pasti_track/features/medicines/presentation/bloc/medicament_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasti_track/widgets/confirm_dialog.dart';
import 'package:pasti_track/widgets/custom_paddings.dart';

class MedicationCardWidget extends StatelessWidget {
  final Medicament medicament;

  const MedicationCardWidget({super.key, required this.medicament});

  @override
  Widget build(BuildContext context) {
    const styleOne = TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
    const styleTwo = TextStyle(fontSize: 22, fontWeight: FontWeight.w400);

    return Card(
      margin: CustomPaddings.getVertical10(),
      child: Padding(
        padding: CustomPaddings.getVertical10(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              medicament.name,
              style: styleOne,
            ),
            Text(
              AppString.dosageWithQuantityAndUnitMesuared(medicament.dose),
              style: styleTwo,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    onPressed: () {
                      context.push(
                        AppUrls.addEditMedicinesPath,
                        extra: medicament,
                      );
                    },
                    icon: const Icon(Icons.edit)),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => ConfirmDialog(
                      title: AppString.deleteMedication,
                      content: AppString.deleteConfirmation,
                      onConfirm: () => context
                          .read<MedicamentBloc>()
                          .add(RemoveMedicamentEvent(medicament.medicineId)),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
