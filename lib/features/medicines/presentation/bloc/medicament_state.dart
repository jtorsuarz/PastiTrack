part of 'medicament_bloc.dart';

sealed class MedicamentState {}

class MedicamentInitialState extends MedicamentState {}

class MedicamentLoadedState extends MedicamentState {
  final List<Medicament> medicamentos;

  MedicamentLoadedState(this.medicamentos);
}

class MedicamentErrorState extends MedicamentState {
  final String message;

  MedicamentErrorState(this.message);
}
