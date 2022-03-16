import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // Database
  static const _dbName = 'myDb.db';
  // Database Version
  static const _dbVersion = 1;
  // Table Records
  static const _tblRecords = 'Records';
  // Table User
  static const _tblUser = 'User';
  // Table Contacts
  static const _tblContacts = 'Contacts';
  // Table Pathologies
  static const _tblPathologies = 'Pathologies';

  // Columns for tblUser
  static const colID = 'ID';
  static const colFirstName = 'FirstName';
  static const colLastName = 'LastName';
  static const colBirthDate = 'BirthDate';
  static const colOrganDonnor = 'OrganDonnor';
  static const colAllergy = 'Allergy';
  static const colUsername = 'Username';
  static const colPassword = 'Password';
  static const colEmail = 'Email';
  static const colContactNo = 'ContactNo';

  // Columns for tblRecords
  static const colName = 'Name';
  static const colDate = 'Date';
  static const colTime = 'Time';

  // Columns for tblContacts
  static const colAccountID = 'AccountID';
  static const colContactName = 'ContactName';
  static const colPhoneNumber = 'PhoneNumber';
  static const colRelationship = 'Relationship';

  // Columns for tblPathologies
  static const colSickness = 'Sickness';
  static const colMedicine = 'Medicine';

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
          "$colLastName TEXT NOT NULL,"
          "$colBirthDate DATE NOT NULL,"
          "$colOrganDonnor INT,"
          "$colAllergy TEXT,"
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
      await db.execute("CREATE TABLE $_tblContacts ("
          "$colID INTEGER PRIMARY KEY,"
          "$colAccountID INTEGER NOT NULL,"
          "$colContactName TEXT NOT NULL,"
          "$colPhoneNumber TEXT NOT NULL,"
          "$colRelationship TEXT NOT NULL"
          ")");
      await db.execute("CREATE TABLE $_tblPathologies ("
          "$colID INTEGER PRIMARY KEY,"
          "$colAccountID INTEGER NOT NULL,"
          "$colSickness TEXT,"
          "$colMedicine TEXT"
          ")");
    });
  }

  // ================ Insert Function ==================== //
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

  // Insert data for Contacts
  Future<int> insertContacts(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(_tblContacts, row);
  }

  // Insert data for Pathologies
  Future<int> insertPathologies(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(_tblPathologies, row);
  }

  //================= Select Function =====================//

  Future<List> checkUser(String username, String pass) async {
    Database db = await database;
    return await db.query(_tblUser,
        where: "$colUsername =? AND $colPassword = ?",
        whereArgs: [username, pass]);
  }

  Future<List> getUser(int id) async {
    Database db = await database;
    return await db.query(_tblUser, where: "$colID =?", whereArgs: [id]);
  }

  Future<List> getContacts(int accountID) async {
    Database db = await database;
    return await db
        .query(_tblContacts, where: "$colAccountID =?", whereArgs: [accountID]);
  }

  Future<List> getPatholofies(int accountID) async {
    Database db = await database;
    return await db.query(_tblPathologies,
        where: "$colAccountID =?", whereArgs: [accountID]);
  }

  // ================== Update Function ==================//

  Future<int> updateProfile(Map<String, dynamic> row) async {
    Database db = await database;
    int id = row[colID];
    return await db.update(_tblUser, row, where: '$colID = ?', whereArgs: [id]);
  }

  Future<int> updateMedicine(Map<String, dynamic> row) async {
    Database db = await database;
    int id = row[colID];
    int accID = row[colAccountID];
    return await db.update(_tblPathologies, row,
        where: '$colID = ? AND $colAccountID = ?', whereArgs: [id, accID]);
  }

  Future<int> updatePathologies(Map<String, dynamic> row) async {
    Database db = await database;
    int id = row[colID];
    int accID = row[colAccountID];
    return await db.update(_tblPathologies, row,
        where: '$colID = ? AND $colAccountID = ?', whereArgs: [id, accID]);
  }

  // ================== Delete Function ==================//

  Future<void> deletePathology(int pathologyID, int accID) async {
    Database db = await database;
    await db.delete(_tblPathologies,
        where: '$colID = ? AND $colAccountID = ?',
        whereArgs: [pathologyID, accID]);
  }
}
