import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DBRemote {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser!.uid;

  // Get user reference
  DocumentReference get _userRef => _firestore.collection('Users').doc(userId);

  // Add or update a user
  Future<void> addOrUpdateUser(Map<String, dynamic> user) async {
    await _userRef.set(user, SetOptions(merge: true));
  }

  // CRUD Operations for Medications
  Future<QuerySnapshot> getmedicines() async {
    return await _userRef.collection('Medicines').get();
  }

  Future<void> addMedicament(
      String medicamentId, Map<String, dynamic> medicament) async {
    await _userRef.collection('Medicines').doc(medicamentId).set(medicament);
  }

  Future<void> updateMedicament(
      String medicamentId, Map<String, dynamic> medicament) async {
    await _userRef.collection('Medicines').doc(medicamentId).update(medicament);
  }

  Future<void> deleteMedicament(String medicamentId) async {
    await _userRef.collection('Medicines').doc(medicamentId).delete();
  }

  Future<DocumentSnapshot> getMedicamentById(String medicamentId) async {
    return await _userRef.collection('Medicines').doc(medicamentId).get();
  }

  // CRUD Operations for Routines
  Future<void> addRoutine(String rutinaId, Map<String, dynamic> rutina) async {
    await _userRef.collection('Routines').doc(rutinaId).set(rutina);
  }

  Future<void> updateRoutine(
      String rutinaId, Map<String, dynamic> rutina) async {
    await _userRef.collection('Routines').doc(rutinaId).update(rutina);
  }

  Future<void> deleteRoutine(String rutinaId) async {
    await _userRef.collection('Routines').doc(rutinaId).delete();
  }

  Future<QuerySnapshot> getRoutines() async {
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
