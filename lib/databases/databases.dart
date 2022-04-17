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

  Future<Users> create(Users users) async {
    //tworzenie
    final db = await instance.database;
    final key_id = await db.insert(userNotes, users.toJson());

    return users.copy(key_id: key_id);
  }

//czytanie jednego elementu
  Future<Users> readNote(int key_id) async {
    final db = await instance.database;

    final maps = await db.query(
      userNotes,
      columns: UsersFields.values,
      where: '${UsersFields.key_id} = ?',
      whereArgs: [key_id],
    );

    if (maps.isNotEmpty) {
      return Users.fromJson(maps.first);
    } else {
      throw Exception('ID $key_id not found');
    }
  }

//wczytaj wszystkie
  Future<List<Users>> readAllNotes() async {
    final db = await instance.database;
    ///////////////////////////////////////////////////
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');
    //tak mozna tworzyc polecenia takie jak z SQL
    /////////////////////////////////////////
    final result = await db.query(userNotes);

    return result.map((json) => Users.fromJson(json)).toList();
  }

//aktualizacja danego elementu po numerze
  Future<int> update(Users users) async {
    final db = await instance.database;

    return db.update(
      userNotes,
      users.toJson(),
      where: '${UsersFields.key_id} = ?',
      whereArgs: [users.key_id],
    );
  }

//usuwanie danego wpisu po jego numerze
  Future<int> delete(int key_id) async {
    final db = await instance.database;

    return await db.delete(
      userNotes,
      where: '${UsersFields.key_id} = ?',
      whereArgs: [key_id],
    );
  }

  Future close() async {
    //zamykanie
    final db = await instance.database;

    db.close();
  }
}
