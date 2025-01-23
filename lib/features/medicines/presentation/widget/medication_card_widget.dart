import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pasti_track/core/config.dart';
import 'package:pasti_track/features/medicines/domain/entities/medicament.dart';
import 'package:pasti_track/features/medicines/presentation/bloc/medicament_bloc.dart';
import 'package:pasti_track/widgets/confirm_dialog.dart';
import 'package:pasti_track/widgets/custom_paddings.dart';
import 'package:pasti_track/widgets/custom_sizes_box.dart';

class MedicationCardWidget extends StatelessWidget {
  final Medicament medicament;

  const MedicationCardWidget({super.key, required this.medicament});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: CustomPaddings.getAll15(),
      child: ListTile(
        title: Text(medicament.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomSizedBoxes.get10(),
            Text(
              AppString.dosageWithQuantityAndUnitMesuared(medicament.dose),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => context.push(
                AppUrls.addEditMedicinesPath,
                extra: medicament,
              ),
              icon: const Icon(
                Icons.edit,
                color: Colors.blue,
              ),
            ),
            CustomSizedBoxes.get10(),
            IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.red,
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
            ),
          ],
        ),
      ),
    );
  }
}
