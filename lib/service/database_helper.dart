import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// database table and column names
final String columnId = '_id';

// database table and column names
final String tableUserProfile = 'user_profile';
final String columnUserId = '_id';
final String columnFirebaseUid = 'firebase_uid';
final String columnFacebookId = 'facebook_id';
final String columnName = 'name';
final String columnEmail = 'email';
final String columnTimezone = 'time_zone';

// database table and column names
final String tableUserPreferences = 'user_preference';
final String columnPreferenceId = '_id';
final String columnValue = 'value';

// data model class
class UserProfileDbModel {
  int? id;
  String? firebaseUid;
  String? facebookId;
  String? name;
  String? email;
  String? timezone;

  UserProfileDbModel();

  // convenience constructor to create a Word object
  UserProfileDbModel.fromMap(Map<String, dynamic> map) {
    id = map[columnUserId];
    firebaseUid = map[columnFirebaseUid];
    facebookId = map[columnFacebookId];
    name = map[columnName];
    email = map[columnEmail];
    timezone = map[columnTimezone];
  }

  // convenience method to create a Map from this Word object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnId: id,
      columnFirebaseUid: firebaseUid,
      columnFacebookId: facebookId,
      columnName: name,
      columnEmail: email,
      columnTimezone: timezone,
    };

    return map;
  }
}

// singleton class to manage the database
class DatabaseHelper {
  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "dosomething.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
        onDowngrade: onDatabaseDowngradeDelete);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableUserProfile (
                $columnUserId INTEGER PRIMARY KEY,
                $columnFirebaseUid TEXT NOT NULL,
                $columnFacebookId TEXT DEFAULT NULL,
                $columnName TEXT DEFAULT NULL,
                $columnEmail TEXT DEFAULT NULL,
                $columnTimezone TEXT NOT NULL
              )
              ''');
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Database version is updated, alter the table
    await db.execute('''
          CREATE TABLE $tableUserProfile (
                $columnUserId INTEGER PRIMARY KEY,
                $columnFirebaseUid TEXT NOT NULL,
                $columnFacebookId TEXT DEFAULT NULL,
                $columnName TEXT DEFAULT NULL,
                $columnEmail TEXT DEFAULT NULL,
                $columnTimezone TEXT NOT NULL
              )
              ''');

    await db.execute('''
              CREATE TABLE $tableUserProfile (
                $columnUserId INTEGER PRIMARY KEY,
                $columnFirebaseUid TEXT NOT NULL,
                $columnFacebookId TEXT DEFAULT NULL,
                $columnName TEXT DEFAULT NULL,
                $columnEmail TEXT DEFAULT NULL,
                $columnTimezone TEXT NOT NULL
              )
              ''');
  }

  // Database helper methods:

  Future<int> insertUser(UserProfileDbModel user) async {
    Database db = await database;
    int id = await db.insert(tableUserProfile, user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  Future<UserProfileDbModel?> queryUserProfile(String firebaseUid) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(tableUserProfile,
        columns: [columnUserId, columnFirebaseUid, columnFacebookId, columnName, columnEmail],
        where: '$columnFirebaseUid = ?',
        whereArgs: [firebaseUid]);
    if (maps.length > 0) {
      return UserProfileDbModel.fromMap(maps.first);
    }
    return null;
  }


// TODO: queryAllWords()
// TODO: delete(int id)
// TODO: update(Word word)
}