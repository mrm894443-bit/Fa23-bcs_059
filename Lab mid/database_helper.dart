import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/doctor.dart';
import '../models/patient.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'doctor_app.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE doctors(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        specialization TEXT,
        phone TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE patients(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        age INTEGER,
        address TEXT,
        phone TEXT
      )
    ''');
  }

  // Doctor CRUD
  Future<int> insertDoctor(Doctor doctor) async {
    final dbClient = await db;
    return await dbClient.insert('doctors', doctor.toMap());
  }

  Future<List<Doctor>> getDoctors() async {
    final dbClient = await db;
    final maps = await dbClient.query('doctors', orderBy: 'id DESC');
    return maps.map((m) => Doctor.fromMap(m)).toList();
  }

  Future<int> updateDoctor(Doctor doctor) async {
    final dbClient = await db;
    return await dbClient.update(
      'doctors',
      doctor.toMap(),
      where: 'id = ?',
      whereArgs: [doctor.id],
    );
  }

  Future<int> deleteDoctor(int id) async {
    final dbClient = await db;
    return await dbClient.delete('doctors', where: 'id = ?', whereArgs: [id]);
  }

  // Patient CRUD
  Future<int> insertPatient(Patient patient) async {
    final dbClient = await db;
    return await dbClient.insert('patients', patient.toMap());
  }

  Future<List<Patient>> getPatients() async {
    final dbClient = await db;
    final maps = await dbClient.query('patients', orderBy: 'id DESC');
    return maps.map((m) => Patient.fromMap(m)).toList();
  }

  Future<int> updatePatient(Patient patient) async {
    final dbClient = await db;
    return await dbClient.update(
      'patients',
      patient.toMap(),
      where: 'id = ?',
      whereArgs: [patient.id],
    );
  }

  Future<int> deletePatient(int id) async {
    final dbClient = await db;
    return await dbClient.delete('patients', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final dbClient = await db;
    return dbClient.close();
  }
}
