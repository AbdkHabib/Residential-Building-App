import 'package:qatar_data_app/database/db_controller.dart';
import 'package:qatar_data_app/database/db_operations.dart';
import 'package:qatar_data_app/models/note.dart';
import 'package:qatar_data_app/preferences/shared_pref_controller.dart';
import 'package:sqflite/sqflite.dart';

class NoteDbController implements DbOperations<Note> {
  final Database _database = DbController().database;

  @override
  Future<int> create(Note model) {
    // int newRowId = await _database.rawInsert(
    //     'INSERT INTO notes (title, info, user_id) VALUES (?, ?, ?)',
    //     [model.title, model.info, model.userId]);
    return _database.insert(Note.tableName, model.toMap());
  }

  @override
  Future<bool> delete(int id) async {
    // int countOfDeletedRows = await _database.rawDelete('DELETE FROM notes WHERE id = ?',[id]);
    int countOfDeletedRows = await _database
        .delete(Note.tableName, where: 'id = ?', whereArgs: [id]);
    return countOfDeletedRows > 0;
  }

  @override
  Future<List<Note>> read() async {
    // List<Map<String, dynamic>> rowsMap = await _database.rawQuery('SELECT * FROM notes');

    int userId =
        SharedPrefController().getValueFor<int>(key: PrefKeys.id.name) ?? -1;
    List<Map<String, dynamic>> rowsMap = await _database
        .query(Note.tableName, where: 'user_id = ?', whereArgs: [userId]);
    return rowsMap.map((rowMap) => Note.fromMap(rowMap)).toList();
  }

  @override
  Future<Note?> show(int id) async {
    // List<Map<String, dynamic>> rowsMap = await _database.rawQuery('SELECT * FROM notes WHERE id = ?', [id]);
    List<Map<String, dynamic>> rowsMap =
        await _database.query(Note.tableName, where: 'id = ?', whereArgs: [id]);
    return rowsMap.isNotEmpty ? Note.fromMap(rowsMap.first) : null;
  }

  @override
  Future<bool> update(Note model) async {
    // int countOfUpdatedRows = await _database.rawUpdate(
    //     'UPDATE notes SET title = ?, info = ? WHERE id = ?',
    //     [model.title, model.info, model.id]);
    int countOfUpdatedRows = await _database.update(
        Note.tableName, model.toMap(),
        where: 'id = ?', whereArgs: [model.id]);
    return countOfUpdatedRows > 0;
  }
}
