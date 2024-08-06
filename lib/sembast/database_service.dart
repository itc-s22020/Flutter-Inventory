import 'package:sembast/sembast.dart';
import 'package:sembast_web/sembast_web.dart';

class DatabaseService {
  static final DatabaseService _singleton = DatabaseService._internal();
  factory DatabaseService() => _singleton;
  DatabaseService._internal();

  late Database _db;

  Future<void> init() async {
    _db = await databaseFactoryWeb.openDatabase('inventory.db');
  }

  Database get db => _db;
}