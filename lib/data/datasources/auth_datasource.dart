import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';

class AuthDataSource {
  static final AuthDataSource _instance = AuthDataSource._internal();
  factory AuthDataSource() => _instance;
  AuthDataSource._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'users.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id TEXT PRIMARY KEY,
        name TEXT,
        email TEXT UNIQUE,
        password TEXT,
        phoneNumber TEXT,
        profileImage TEXT
      )
    ''');
  }

  Future<void> saveUser(UserModel user) async {
    final db = await database;
    await db.insert(
      'users',
      user.toJson(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<void> updateUser(UserModel user) async {
    final db = await database;
    await db.update(
      'users',
      user.toJson(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<UserModel?> getUser(String email, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromJson(maps.first);
    }
    return null;
  }

  Future<bool> userExists(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return maps.isNotEmpty;
  }
}
