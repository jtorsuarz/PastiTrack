import 'package:flutter/material.dart';
import 'package:pasti_track/core/config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasti_track/features/medicines/domain/entities/medicament.dart';
import 'package:pasti_track/features/medicines/presentation/bloc/medicament_bloc.dart';
import 'package:pasti_track/widgets/custom_sizes_box.dart';

class AddEditMedicamentScreen extends StatefulWidget {
  const AddEditMedicamentScreen({super.key});

  @override
  State<AddEditMedicamentScreen> createState() =>
      _AddEditMedicamentScreenState();
}

class _AddEditMedicamentScreenState extends State<AddEditMedicamentScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final dosageController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.clear();
    dosageController.clear();
    descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppString.addMedication),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration:
                    const InputDecoration(labelText: AppString.nameMedication),
                validator: (value) =>
                    value!.isEmpty ? AppString.entryName : null,
              ),
              CustomSizedBoxes.get15(),
              TextFormField(
                controller: dosageController,
                decoration: const InputDecoration(labelText: AppString.dosage),
                validator: (value) =>
                    value!.isEmpty ? AppString.entryDosage : null,
              ),
              CustomSizedBoxes.get15(),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                    labelText: AppString.descriptionOptional),
              ),
              CustomSizedBoxes.get15(),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState != null &&
                      _formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final medicamento = Medicament(
                      medicineId: DateTime.now().toString(),
                      name: nameController.text,
                      dose: dosageController.text,
                      description: descriptionController.text,
                    );
                    context
                        .read<MedicamentBloc>()
                        .add(CreateMedicamentEvent(medicamento));
                    Navigator.pop(context);
                  }
                },
                child: const Text(AppString.save),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
