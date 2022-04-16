import 'package:dragcon/databases/users.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//note klasa nie mylic klasy Databeses z klasa Database wbudowana w sqflite

class Databases {
  static final Databases instance = Databases._init();
  static Database? _database;

  Databases._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final key_idType =
        'INTEGER PRIMARY KEY AUTOINCREMENT'; //inkrementacyjny typ
    final boolType = 'BOOLEAN NOT NULL'; //definiujemy boola
    final textype = 'TEXT NOT NULL'; // no i stringa
    await db.execute('''CREATE TABLE $userNotes(
      ${UsersFields.key_id} $key_idType,
      ${UsersFields.admin} $boolType,
      ${UsersFields.id} $textype,
      ${UsersFields.password} $textype
    )''');
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
