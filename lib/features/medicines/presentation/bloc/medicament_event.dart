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

class UpdateMedicament extends MedicamentEvent {
  final Medicament medicamento;

  UpdateMedicament(this.medicamento);
}
