import 'package:flutter/material.dart';
import 'package:pasti_track/core/config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasti_track/core/helper/app_logger.dart';
import 'package:pasti_track/features/medicines/domain/entities/medicament.dart';
import 'package:pasti_track/features/medicines/presentation/bloc/medicament_bloc.dart';
import 'package:pasti_track/widgets/custom_paddings.dart';
import 'package:pasti_track/widgets/custom_sizes_box.dart';

class AddEditMedicamentScreen extends StatefulWidget {
  final Medicament? medicament;
  const AddEditMedicamentScreen({super.key, this.medicament});

  @override
  State<AddEditMedicamentScreen> createState() =>
      _AddEditMedicamentScreenState();
}

class _AddEditMedicamentScreenState extends State<AddEditMedicamentScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final dosageController = TextEditingController();
  final descriptionController = TextEditingController();
  late Medicament? _medicament;

  @override
  void dispose() {
    super.dispose();
    nameController.clear();
    dosageController.clear();
    descriptionController.clear();
  }

  @override
  void initState() {
    super.initState();
    _medicament = widget.medicament;

    AppLogger.p("AddEditMedication", "medicament: ${_medicament?.name}");
    nameController.text = _medicament?.name ?? '';
    dosageController.text = _medicament?.dose ?? '';
    descriptionController.text = _medicament?.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final titleScreen = (_medicament == null)
        ? AppString.addMedication
        : AppString.editMedication;
    final buttonText =
        (_medicament == null) ? AppString.save : AppString.update;

    return Scaffold(
      appBar: AppBar(
        title: Text(titleScreen),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: CustomPaddings.getAll15(),
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
                  labelText: AppString.descriptionOptional,
                ),
              ),
              CustomSizedBoxes.get15(),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState != null &&
                      _formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    try {
                      String message = '';
                      if (_medicament != null) {
                        final medicamentUpdated = _medicament!.copyWith(
                          medicineId: _medicament!.medicineId,
                          name: nameController.text,
                          dose: dosageController.text,
                          dateUpdated: DateTime.now().toString(),
                          description: descriptionController.text,
                        );
                        context
                            .read<MedicamentBloc>()
                            .add(UpdateMedicamentEvent(medicamentUpdated));

                        message = AppString.successUpdated;
                      } else {
                        final medicamento = Medicament(
                          medicineId: DateTime.now().toString(),
                          name: nameController.text,
                          dose: dosageController.text,
                          dateUpdated: DateTime.now().toString(),
                          description: descriptionController.text,
                        );
                        context
                            .read<MedicamentBloc>()
                            .add(CreateMedicamentEvent(medicamento));
                        message = AppString.successAdded;
                      }
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(message)));
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppString.errorWhenUpdate(AppString.medicament),
                          ),
                        ),
                      );
                    }
                  }
                },
                child: Text(buttonText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
