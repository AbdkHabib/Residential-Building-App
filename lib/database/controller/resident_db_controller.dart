import 'package:qatar_data_app/database/db_controller.dart';
import 'package:qatar_data_app/database/db_operations.dart';
import 'package:qatar_data_app/models/resident_detail.dart';
import 'package:qatar_data_app/preferences/shared_pref_controller.dart';
import 'package:sqflite/sqflite.dart';

class ResidentDbController implements DbOperations<ResidentDetail > {
  final Database _database = DbController().database;

  @override
  Future<int> create(ResidentDetail model) async {

    // int newRowId = await _database.rawInsert(
    //     'INSERT INTO notes (amount, payment_year, payment_date,payment_details) VALUES (?, ?, ?,?)',
    //     [model.amount, model.paymentYear, model.paymentDate,model.paymentDetails]);
    return _database.insert(ResidentDetail.tableName, model.toMap());
  }

  @override
  Future<bool> delete(int id) async {
    // int countOfDeletedRows = await _database.rawDelete('DELETE FROM notes WHERE id = ?',[id]);
    int countOfDeletedRows = await _database
        .delete(ResidentDetail.tableName, where: 'id = ?', whereArgs: [id]);
    return countOfDeletedRows > 0;
  }

  @override
  Future<List<ResidentDetail>> read() async {
    // List<Map<String, dynamic>> rowsMap = await _database.rawQuery('SELECT * FROM notes');

    int apartmentId =
        SharedPrefController().getValueFor<int>(key: PrefKeys.id.name) ?? -1;
    List<Map<String, dynamic>> rowsMap = await _database
        .query(ResidentDetail.tableName, where: 'apartment_id = ?', whereArgs: [apartmentId]);
    return rowsMap.map((rowMap) => ResidentDetail.fromMap(rowMap)).toList();
  }

  @override
  Future<ResidentDetail?> show(int id) async {
    // List<Map<String, dynamic>> rowsMap = await _database.rawQuery('SELECT * FROM notes WHERE id = ?', [id]);
    List<Map<String, dynamic>> rowsMap =
    await _database.query(ResidentDetail.tableName, where: 'id = ?', whereArgs: [id]);
    return rowsMap.isNotEmpty ? ResidentDetail.fromMap(rowsMap.first) : null;
  }

  @override
  Future<bool> update(ResidentDetail model) async {
    // int countOfUpdatedRows = await _database.rawUpdate(
    //     'UPDATE notes SET title = ?, info = ? WHERE id = ?',
    //     [model.title, model.info, model.id]);
    int countOfUpdatedRows = await _database.update(
        ResidentDetail.tableName, model.toMap(),
        where: 'id = ?', whereArgs: [model.id]);
    return countOfUpdatedRows > 0;
  }
}
