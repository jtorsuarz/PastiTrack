import 'package:cloud_firestore/cloud_firestore.dart';

class DBRemote {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId;

  DBRemote({required this.userId});

  // Get user reference
  DocumentReference get _userRef => _firestore.collection('Users').doc(userId);

  // Add or update a user
  Future<void> addOrUpdateUser(Map<String, dynamic> user) async {
    await _userRef.set(user, SetOptions(merge: true));
  }

  // CRUD Operations for Medications
  Future<void> addMedicamento(
      String medicamentoId, Map<String, dynamic> medicamento) async {
    await _userRef.collection('Medicines').doc(medicamentoId).set(medicamento);
  }

  Future<void> updateMedicamento(
      String medicamentoId, Map<String, dynamic> medicamento) async {
    await _userRef
        .collection('Medicines')
        .doc(medicamentoId)
        .update(medicamento);
  }

  Future<void> deleteMedicamento(String medicamentoId) async {
    await _userRef.collection('Medicines').doc(medicamentoId).delete();
  }

  Future<DocumentSnapshot> getMedicamentoById(String medicamentoId) async {
    return await _userRef.collection('Medicines').doc(medicamentoId).get();
  }

  Future<QuerySnapshot> getmedicines() async {
    return await _userRef.collection('Medicines').get();
  }

  // CRUD Operations for Routines
  Future<void> addRutina(String rutinaId, Map<String, dynamic> rutina) async {
    await _userRef.collection('Routines').doc(rutinaId).set(rutina);
  }

  Future<void> updateRutina(
      String rutinaId, Map<String, dynamic> rutina) async {
    await _userRef.collection('Routines').doc(rutinaId).update(rutina);
  }

  Future<void> deleteRutina(String rutinaId) async {
    await _userRef.collection('Routines').doc(rutinaId).delete();
  }

  Future<QuerySnapshot> getRutinas() async {
    return await _userRef.collection('Routines').get();
  }

  // CRUD Operations for History
  Future<void> addHistorial(
      String historialId, Map<String, dynamic> history) async {
    await _userRef.collection('History').doc(historialId).set(history);
  }

  Future<void> updateHistorial(
      String historialId, Map<String, dynamic> history) async {
    await _userRef.collection('History').doc(historialId).update(history);
  }

  Future<void> deleteHistorial(String historialId) async {
    await _userRef.collection('History').doc(historialId).delete();
  }

  Future<QuerySnapshot> getHistorial() async {
    return await _userRef.collection('History').get();
  }
}
