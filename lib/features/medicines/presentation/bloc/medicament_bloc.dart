import 'package:bloc/bloc.dart';
import 'package:pasti_track/core/errors/failures.dart';
import 'package:pasti_track/features/medicines/data/repositories/medicament_repository_impl.dart';
import 'package:pasti_track/features/medicines/domain/entities/medicament.dart';

part 'medicament_event.dart';
part 'medicament_state.dart';

class MedicamentBloc extends Bloc<MedicamentEvent, MedicamentState> {
  final MedicamentRepositoryImpl repository;

  MedicamentBloc(this.repository) : super(MedicamentInitialState()) {
    on<LoadMedicationsEvent>((event, emit) async {
      try {
        final medicamentos = await repository.getMedications();

        emit(MedicamentLoadedState(medicamentos));
      } on Failure catch (e) {
        emit(MedicamentErrorState(e.message));
      }
    });

    on<CreateMedicamentEvent>((event, emit) async {
      try {
        await repository.addMedicament(event.medicament);
        add(LoadMedicationsEvent());
      } on Failure catch (e) {
        emit(MedicamentErrorState(e.message));
      }
    });

    on<RemoveMedicamentEvent>((event, emit) async {
      try {
        await repository.deleteMedicament(event.id);
        add(LoadMedicationsEvent());
      } on Failure catch (e) {
        emit(MedicamentErrorState(e.message));
      }
    });
  }
}
