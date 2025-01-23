import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pasti_track/features/events/domain/entities/event_status.dart';

class DBRemote {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser!.uid;

  /// Get user reference
  DocumentReference get _userRef => _firestore.collection('Users').doc(userId);

  /// Add or update a user
  Future<void> addOrUpdateUser(Map<String, dynamic> user) async {
    await _userRef.set(user, SetOptions(merge: true));
  }

  /// CRUD Operations for Medications
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

  /// CRUD Operations for Routines
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

  /// CRUD Operations for Events
  Future<void> addEvent(String eventId, Map<String, dynamic> event) async {
    await _userRef.collection('Events').doc(eventId).set(event);
  }

  Future<void> updateEvent(String eventId, Map<String, dynamic> event) async {
    await _userRef.collection('Events').doc(eventId).update(event);
  }

  Future<void> updateEventStatus(String eventId, String dateDone) async {
    await _userRef
        .collection('Events')
        .doc(eventId)
        .update({"status": EventStatus.completed.name, "date_done": dateDone});
  }

  Future<void> deleteEvent(String eventId) async {
    await _userRef.collection('Events').doc(eventId).delete();
  }

  Future<void> deleteEventsByRoutineId(String eventId) async {
    final querySnapshot = await _userRef
        .collection('Events')
        .where('routine_id', isEqualTo: eventId)
        .get();

    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<DocumentSnapshot> getEvent(String eventId) async {
    return await _userRef.collection('Events').doc(eventId).get();
  }

  Future<QuerySnapshot> getEvents() async {
    return await _userRef.collection('Events').get();
  }

  Future<QuerySnapshot> getPendingEvents(DateTime currentDate) async {
    return await _userRef
        .collection('Events')
        .where('status', isEqualTo: EventStatus.pending.name)
        .where('date_scheduled',
            isLessThanOrEqualTo: currentDate.toIso8601String())
        .get();
  }
}
