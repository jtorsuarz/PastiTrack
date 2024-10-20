import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasti_track/core/config.dart';
import 'package:pasti_track/features/medicines/presentation/bloc/medicament_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pasti_track/features/medicines/presentation/widget/medication_card_widget.dart';

class MedicationScreen extends StatelessWidget {
  const MedicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppString.medicationManagement),
        centerTitle: true,
      ),
      body: BlocListener<MedicamentBloc, MedicamentState>(
        listener: (context, state) {
          if (state is MedicamentErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<MedicamentBloc, MedicamentState>(
          builder: (context, state) {
            if (state is MedicamentInitialState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MedicamentLoadedState) {
              if (state.medicamentos.isEmpty) {
                return const Center(child: Text(AppString.noMedicines));
              }
              return ListView.builder(
                itemCount: state.medicamentos.length,
                itemBuilder: (context, index) {
                  return MedicationCardWidget(
                      medicament: state.medicamentos[index]);
                },
              );
            } else {
              return const Center(child: Text(AppString.noMedicines));
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(AppUrls.addEditMedicinesPath);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
