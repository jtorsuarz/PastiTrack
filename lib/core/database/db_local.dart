import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'dart:async';

class DBLocal {
  static final DBLocal _instance = DBLocal._internal();
  static Database? _database;

  factory DBLocal() {
    return _instance;
  }

  DBLocal._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'pastitrack.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Create tables in the database
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Users (
        user_id TEXT PRIMARY KEY,
        email TEXT NOT NULL,
        name TEXT,
        date_created TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE medicines (
        medicine_id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        dose TEXT NOT NULL,
        description TEXT,
        date_updated TEXT,
        user_id TEXT,
        FOREIGN KEY (user_id) REFERENCES Users(user_id)
      )
    ''');

    await db.execute('''
      CREATE TABLE routines (
        routine_id TEXT PRIMARY KEY,
        medicine_id TEXT,
        frequency TEXT NOT NULL,
        dosage_time TEXT NOT NULL,
        user_id TEXT,
        description TEXT,
        date_updated TEXT,
        FOREIGN KEY (medicine_id) REFERENCES medicines(medicine_id),
        FOREIGN KEY (user_id) REFERENCES Users(user_id)
      )
    ''');

    await db.execute('''
      CREATE TABLE history (
        history_id TEXT PRIMARY KEY,
        routine_id TEXT,
        take_status TEXT NOT NULL,
        date TEXT NOT NULL,
        user_id TEXT,
        FOREIGN KEY (routine_id) REFERENCES routines(routine_id),
        FOREIGN KEY (user_id) REFERENCES Users(user_id)
      )
    ''');
  }

  // CRUD functions for tables
  // Insertar un usuario
  Future<int> insertUsuario(Map<String, dynamic> usuario) async {
    Database db = await database;
    return await db.insert('Users', usuario);
  }

  Future<List<Map<String, dynamic>>> getUsuarios() async {
    Database db = await database;
    return await db.query('Users');
  }

  Future<Map<String, dynamic>?> getUsuario(String usuarioId) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'Users',
      where: 'user_id = ?',
      whereArgs: [usuarioId],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<int> insertMedicament(Map<String, dynamic> medicament) async {
    Database db = await database;
    return await db.insert('medicines', medicament);
  }

  Future<List<Map<String, dynamic>>> getmedicines() async {
    Database db = await database;
    return await db.query('medicines');
  }

  Future<Map<String, dynamic>?> getMedicamentById(String medicamentId) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'medicines',
      where: 'medicine_id = ?',
      whereArgs: [medicamentId],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<int> updateMedicament(
      String id, Map<String, dynamic> medicament) async {
    Database db = await database;
    return await db.update(
      'medicines',
      medicament,
      where: 'medicine_id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteMedicament(String medicamentId) async {
    Database db = await database;
    return await db.delete(
      'medicines',
      where: 'medicine_id = ?',
      whereArgs: [medicamentId],
    );
  }

  Future<int> insertRoutine(Map<String, dynamic> rutina) async {
    Database db = await database;
    return await db.insert('routines', rutina);
  }

  Future<List<Map<String, dynamic>>> getRoutines() async {
    Database db = await database;
    return await db.query('routines');
  }

  Future<Map<String, dynamic>?> getRutinaById(String rutinaId) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'routines',
      where: 'routine_id = ?',
      whereArgs: [rutinaId],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<int> updateRoutine(String id, Map<String, dynamic> rutina) async {
    Database db = await database;
    return await db.update(
      'routines',
      rutina,
      where: 'routine_id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteRoutine(String rutinaId) async {
    Database db = await database;
    return await db.delete(
      'routines',
      where: 'routine_id = ?',
      whereArgs: [rutinaId],
    );
  }

  Future<int> insertHistorial(Map<String, dynamic> history) async {
    Database db = await database;
    return await db.insert('history', history);
  }

  Future<List<Map<String, dynamic>>> getHistorial() async {
    Database db = await database;
    return await db.query('history');
  }

  Future<List<Map<String, dynamic>>> getHistorialByRutinaId(
      String rutinaId) async {
    Database db = await database;
    return await db.query(
      'history',
      where: 'routine_id = ?',
      whereArgs: [rutinaId],
    );
  }

  Future<int> updateHistorial(Map<String, dynamic> history) async {
    Database db = await database;
    return await db.update(
      'history',
      history,
      where: 'history_id = ?',
      whereArgs: [history['history_id']],
    );
  }

  Future<int> deleteHistorial(String historialId) async {
    Database db = await database;
    return await db.delete(
      'history',
      where: 'history_id = ?',
      whereArgs: [historialId],
    );
  }
}
