import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late final db;
  // Inicializa FFI antes de cualquier test
  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    db = await databaseFactory.openDatabase(inMemoryDatabasePath);
  });

  tearDown(() async {
    await db.close();
  });

  test('Mock Test Example', () async {});
}
