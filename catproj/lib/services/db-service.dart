import 'package:path/path.dart' as pathPackage;
import 'package:sqflite/sqflite.dart' as sqflitePackage;

class SQFliteDbService {
  late sqflitePackage.Database? db;
  late String path;

  Future<void> getOrCreateDb() async {
    try{
      var databasesPath = await sqflitePackage.getDatabasesPath();
      path = pathPackage.join(databasesPath, 'app_database.db');
      db = await sqflitePackage.openDatabase(
        path,
        onCreate: (sqflitePackage.Database db1, int version) async {
          await db1.execute(
            "CREATE TABLE CatFacts(catfacts TEXT PRIMARY KEY, id INTEGER)",
          );
        },
        version: 1,
      );
      print('db = $db');
    }catch (e) {
      print('SQFliteDbService getOrCreateDatabaseHandle CATCH: $e');
    }
  }
  

  Future<void> printAllRecordsInDbToConsole() async {
    try {
      List<Map<String, dynamic>> listOfCatFacts = await getAllFactsFromDb();
      if (listOfCatFacts.isEmpty) {
        print('db empty');
      } else {
        listOfCatFacts.forEach((catfact) {
          print(
            'fact: $catfact'
          );
        });
      }
    } catch (e) {
      print('dbservice printAllRecordsInDbToConsole caught: $e');
    }
  }
  
  Future<List<Map<String, dynamic>>> getAllFactsFromDb() async {
    try {
      final List<Map<String, dynamic>> listOfItems = await db!.query('CatFacts');
      return listOfItems;
    } catch (e) {
      print('dbservice getAllFactsFromDb caught: $e');
      return <Map<String, dynamic>>[];
    }
  }

  Future<void> deleteDb() async {
    try {
      await sqflitePackage.deleteDatabase(path);
      print('db deleted');
      db = null;
    } catch (e) {
      print('dbservice deleteDb caught: $e');
    }
  }
  
  Future<void> insertFact(Map<String, dynamic> fact) async {
    try {
      await db!.insert(
        'CatFacts',
        fact,
        conflictAlgorithm: sqflitePackage.ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('dbservice insertRecord caught: $e');
    }
  }
  
  Future<void> deleteRecord(Map<String, dynamic> fact) async {
    try {
      await db!.delete(
        'CatFacts',
        where: "catfacts = ?",
        // whereArg to prevent SQL injection.
        whereArgs: [fact['catfacts']],
      );
    } catch (e) {
      print('dbservice deleteRecord caught: $e');
    }
  } 






  
}