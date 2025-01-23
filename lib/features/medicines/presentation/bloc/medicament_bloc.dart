import 'package:bloc/bloc.dart';
import 'package:pasti_track/core/errors/failures.dart';
import 'package:pasti_track/core/helper/app_logger.dart';
import 'package:pasti_track/features/medicines/domain/entities/medicament.dart';
import 'package:pasti_track/features/medicines/domain/usecases/add_medicament.dart';
import 'package:pasti_track/features/medicines/domain/usecases/delete_medicament.dart';
import 'package:pasti_track/features/medicines/domain/usecases/get_medications.dart';
import 'package:pasti_track/features/medicines/domain/usecases/update_medicament.dart';

part 'medicament_event.dart';
part 'medicament_state.dart';

class MedicamentBloc extends Bloc<MedicamentEvent, MedicamentState> {
  final GetAllMedicaments getAllMedications;
  final AddMedicament addMedication;
  final UpdateMedicament updateMedicament;
  final DeleteMedicament deleteMedicament;

  MedicamentBloc(
    this.getAllMedications,
    this.addMedication,
    this.updateMedicament,
    this.deleteMedicament,
  ) : super(MedicamentInitialState()) {
    on<LoadMedicationsEvent>((event, emit) async {
      AppLogger.p("module", event.toString());
      try {
        final medicamentos = await getAllMedications.call();
        emit(MedicamentLoadedState(medicamentos));
      } on Failure catch (e) {
        emit(MedicamentErrorState(e.message));
      }
    });

    on<CreateMedicamentEvent>((event, emit) async {
      try {
        await addMedication.call(event.medicament);
        add(LoadMedicationsEvent());
      } on Failure catch (e) {
        emit(MedicamentErrorState(e.message));
      }
    });

    on<RemoveMedicamentEvent>((event, emit) async {
      try {
        await deleteMedicament.call(event.id);
        add(LoadMedicationsEvent());
      } on Failure catch (e) {
        emit(MedicamentErrorState(e.message));
        add(LoadMedicationsEvent());
      }
    });

    on<UpdateMedicamentEvent>((event, emit) async {
      try {
        await updateMedicament.call(event.medicamento);
        add(LoadMedicationsEvent());
      } catch (e) {
        emit(MedicamentErrorState(e.toString()));
      }
    });
  }
}
