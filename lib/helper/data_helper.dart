import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "helper1.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            "CREATE TABLE User (id TEXT PRIMARY KEY, firstName TEXT, lastName TEXT, email TEXT)");
      },
    );
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();

    return _database!;
  }

  Future<int?> insertdata(String fname, String lname, String email) async {
    return await _database?.insert(
      "User",
      {
        "id": const Uuid().v1(),
        "firstName": fname,
        "lastName": lname,
        "email": email
      },
    );
  }

  Future<List<Map<String, Object?>>?> getData() async {
    return await _database?.query("User");
  }

  Future<int?> deleteRecord(String id) async {
    return await _database?.delete(
      "User",
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int?> updateRecord(String fname, String lname, String email,
      {required String id}) async {
    return await _database?.update(
      "User",
      {
        "firstName": fname,
        "lastName": lname,
        "email": email,
      },
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int?> deleteTable() async {
    return await _database?.delete("User");
  }
}
