part of 'medicament_bloc.dart';

sealed class MedicamentEvent {}

class LoadMedicationsEvent extends MedicamentEvent {}

class CreateMedicamentEvent extends MedicamentEvent {
  final Medicament medicament;

  CreateMedicamentEvent(this.medicament);
}

class RemoveMedicamentEvent extends MedicamentEvent {
  final String id;

  RemoveMedicamentEvent(this.id);
}
