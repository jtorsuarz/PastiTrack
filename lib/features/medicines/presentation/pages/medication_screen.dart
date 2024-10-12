import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasti_track/core/config.dart';
import 'package:pasti_track/features/medicines/presentation/bloc/medicament_bloc.dart';
import 'package:go_router/go_router.dart';

class MedicationScreen extends StatelessWidget {
  const MedicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppString.medicationManagement),
        centerTitle: true,
      ),
      body: BlocBuilder<MedicamentBloc, MedicamentState>(
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
                final medicamento = state.medicamentos[index];
                return ListTile(
                  title: Text(medicamento.name),
                  subtitle: Text(medicamento.dose),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      context
                          .read<MedicamentBloc>()
                          .add(RemoveMedicamentEvent(medicamento.medicineId));
                    },
                  ),
                  /**
                   GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Dos columnas
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: medications.length,
                      itemBuilder: (context, index) {
                        return MedicationCardWidget(
                          name: medications[index]["name"]!,
                          dose: medications[index]["dose"]!,
                        );
                      },
                    )
                   */
                );
              },
            );
          } else if (state is MedicamentErrorState) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text(AppString.error));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(AppUrls.addMedicinesPath);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
