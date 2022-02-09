import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // Database
  static final _dbName = 'myDb.db';
  // Database Version
  static final _dbVersion = 1;
  // Table Records
  static final _tblRecords = 'Records';
  // Table User
  static final _tblUser = 'User';

  // Columns for tblUser
  static final colID = 'ID';
  static final colFirstName = 'FirstName';
  static final colMiddleName = 'MiddleName';
  static final colLastName = 'LastName';
  static final colUsername = 'Username';
  static final colPassword = 'Password';
  static final colEmail = 'Email';
  static final colContactNo = 'ContactNo';

  // Columns for tblRecords
  static final colName = 'Name';
  static final colDate = 'Date';
  static final colTime = 'Time';

  DatabaseHelper._();
  static final DatabaseHelper db = DatabaseHelper._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null)
      return _database!;
    else

      // if _database is null we instantiate it
      _database = await _initDb();
    return _database!;
  }

  _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE $_tblUser ("
          "$colID INTEGER PRIMARY KEY,"
          "$colFirstName TEXT NOT NULL,"
          "$colMiddleName TEXT NOT NULL,"
          "$colLastName TEXT,"
          "$colUsername TEXT,"
          "$colPassword TEXT NOT NULL,"
          "$colEmail TEXT,"
          "$colContactNo TEXT NOT NULL"
          ")");
      await db.execute("CREATE TABLE $_tblRecords ("
          "$colID INTEGER PRIMARY KEY,"
          "$colName TEXT NOT NULL,"
          "$colContactNo TEXT NOT NULL,"
          "$colDate DATE NOT NULL,"
          "$colTime TIME NOT NULL"
          ")");
    });
  }

  // Insert table for users
  Future<int> insertUser(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(_tblUser, row);
  }

  // Insert record for qr records
  Future<int> insertRecord(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(_tblRecords, row);
  }

  Future<List> checkUser(String username, String pass) async {
    Database db = await database;
    return await db.query(_tblUser,
        where: "$colUsername =? AND $colPassword = ?",
        whereArgs: [username, pass]);
  }
}
