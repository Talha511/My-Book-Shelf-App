import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FavoritesDataSource {
  static final FavoritesDataSource _instance = FavoritesDataSource._internal();
  factory FavoritesDataSource() => _instance;
  FavoritesDataSource._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'favorites.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorites(
        id TEXT PRIMARY KEY
      )
    ''');
  }

  Future<void> addFavorite(String bookId) async {
    final db = await database;
    await db.insert(
      'favorites',
      {'id': bookId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavorite(String bookId) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'id = ?',
      whereArgs: [bookId],
    );
  }

  Future<List<String>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');
    return List.generate(maps.length, (i) => maps[i]['id']);
  }

  Future<bool> isFavorite(String bookId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'favorites',
      where: 'id = ?',
      whereArgs: [bookId],
    );
    return maps.isNotEmpty;
  }
}
