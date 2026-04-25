// database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('rise_and_brew.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE soil_results (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        farm_name TEXT NOT NULL,
        prediction TEXT NOT NULL,
        confidence TEXT NOT NULL,
        ph_level TEXT NOT NULL,
        ph_status TEXT NOT NULL,
        date TEXT NOT NULL,
        image_path TEXT NOT NULL,
        is_suitable INTEGER NOT NULL
      )
    ''');
  }

  // ── INSERT ──
  Future<int> insertResult(SoilResult result) async {
    final db = await instance.database;
    return await db.insert('soil_results', result.toMap());
  }

  // ── GET ALL (newest first) ──
  Future<List<SoilResult>> getAllResults() async {
    final db = await instance.database;
    final maps = await db.query(
      'soil_results',
      orderBy: 'id DESC',
    );
    return maps.map((map) => SoilResult.fromMap(map)).toList();
  }

  // ── DELETE ──
  Future<void> deleteResult(int id) async {
    final db = await instance.database;
    await db.delete('soil_results', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

// ── Model ──
class SoilResult {
  final int? id;
  final String farmName;
  final String prediction;
  final String confidence;
  final String phLevel;
  final String phStatus;
  final String date;
  final String imagePath;
  final bool isSuitable;

  SoilResult({
    this.id,
    required this.farmName,
    required this.prediction,
    required this.confidence,
    required this.phLevel,
    required this.phStatus,
    required this.date,
    required this.imagePath,
    required this.isSuitable,
  });

  Map<String, dynamic> toMap() {
    return {
      'farm_name': farmName,
      'prediction': prediction,
      'confidence': confidence,
      'ph_level': phLevel,
      'ph_status': phStatus,
      'date': date,
      'image_path': imagePath,
      'is_suitable': isSuitable ? 1 : 0,
    };
  }

  factory SoilResult.fromMap(Map<String, dynamic> map) {
    return SoilResult(
      id: map['id'],
      farmName: map['farm_name'],
      prediction: map['prediction'],
      confidence: map['confidence'],
      phLevel: map['ph_level'],
      phStatus: map['ph_status'],
      date: map['date'],
      imagePath: map['image_path'],
      isSuitable: map['is_suitable'] == 1,
    );
  }
}