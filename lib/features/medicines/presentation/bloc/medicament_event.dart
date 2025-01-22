part of 'medicament_bloc.dart';

abstract class MedicamentEvent {}

class LoadMedicationsEvent extends MedicamentEvent {}

class CreateMedicamentEvent extends MedicamentEvent {
  final Medicament medicament;

  CreateMedicamentEvent(this.medicament);
}

class RemoveMedicamentEvent extends MedicamentEvent {
  final String id;

  RemoveMedicamentEvent(this.id);
}

class UpdateMedicamentEvent extends MedicamentEvent {
  final Medicament medicamento;

  UpdateMedicamentEvent(this.medicamento);
}
