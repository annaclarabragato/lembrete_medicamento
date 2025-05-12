import 'package:sqflite/sqflite.dart';
import '../model/lembrete.dart';

class DataBaseProvider {
  static const _dbNome = 'cadastro_lembretes.db';
  static const _dbVersion = 1;

  DataBaseProvider._init();

  static final DataBaseProvider instance = DataBaseProvider._init();

  Database? _database;

  Future<Database> get database async {
    if (_database == null) {
      _database = await _initDataBase();
    }
    return _database!;
  }

  Future<Database> _initDataBase() async {
    String databasePath = await getDatabasesPath();
    String dbPath = '$databasePath/$_dbNome';
    return await openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE lembrete (
        ${Lembrete.CAMPO_ID} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Lembrete.CAMPO_DESCRICAO} TEXT NOT NULL,
        ${Lembrete.CAMPO_DATAHORA} TEXT
      );
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Sem upgrades definidos no momento.
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
    }
  }
}
