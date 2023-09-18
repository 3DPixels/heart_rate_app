import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DatabaseHelper {
  static Database? database;
  Future createDatabase() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = path.join(databasesPath, 'my.db');

    database = await openDatabase(dbPath, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE Users (id INTEGER PRIMARY KEY,userModel TEXT)");
    });
  }
}
