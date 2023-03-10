import 'package:qatar_data_app/database/db_controller.dart';
import 'package:qatar_data_app/models/process_response.dart';
import 'package:qatar_data_app/models/user.dart';
import 'package:qatar_data_app/preferences/shared_pref_controller.dart';
import 'package:sqflite/sqflite.dart';

class UserDbController {
  final Database _database = DbController().database;

  Future<ProcessResponse> login(
      {required String email, required String password}) async {
    List<Map<String, dynamic>> rowsMap = await _database.query(User.tableName,
        where: 'email = ? AND password = ?', whereArgs: [email, password]);

    if (rowsMap.isNotEmpty) {

      User user = User.fromMap(rowsMap.first);
      await SharedPrefController().save(user: user);
    }
    String message = rowsMap.isNotEmpty
        ? 'Logged in successfully'
        : 'Login failed!, check credentials';
    return ProcessResponse(message: message, success: rowsMap.isNotEmpty);
  }

  Future<ProcessResponse> register({required User user}) async {
    if (!await _isRegisteredEmail(email: user.email)) {
      int newRowId = await _database.insert(User.tableName, user.toMap());
      // user.id = newRowId;
      // await SharedPrefController().save(user: user);
      return ProcessResponse(
          message: newRowId != 0
              ? 'Account created successfully'
              : 'Failed to create account, try again',
          success: newRowId != 0);
    }
    return const ProcessResponse(
        message: 'Email exists, use another', success: false);
  }

  Future<bool> _isRegisteredEmail({required String email}) async {
    List<Map<String, dynamic>> rowsMap = await _database
        .query(User.tableName, where: 'email = ?', whereArgs: [email]);
    return rowsMap.isNotEmpty;
  }
}
