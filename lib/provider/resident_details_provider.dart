import 'package:flutter/material.dart';
import 'package:qatar_data_app/database/controller/note_db_controller.dart';
import 'package:qatar_data_app/models/note.dart';
import 'package:qatar_data_app/models/process_response.dart';
import 'package:qatar_data_app/models/resident_detail.dart';

import '../database/controller/resident_db_controller.dart';

class ResidentDetailsProvider extends ChangeNotifier {
  List<ResidentDetail> residentDetails = <ResidentDetail>[];

  ResidentDbController _dbController = ResidentDbController();

  Future<ProcessResponse> create({required ResidentDetail residentDetail}) async {
    int newRowId = await _dbController.create(residentDetail);
    if (newRowId != 0) {
      residentDetail.id = newRowId;
      residentDetails.add(residentDetail);
      notifyListeners();
    }
    return ProcessResponse(
      message: newRowId != 0 ? 'Created successfully' : 'Create failed!',
      success: newRowId != 0,
    );
  }

  void read() async {
    residentDetails = await _dbController.read();
    notifyListeners();
  }

  Future<ProcessResponse> update({required ResidentDetail updateResidentDetail}) async {
    bool updated = await _dbController.update(updateResidentDetail);
    if (updated) {
      int index = residentDetails.indexWhere((element) => element.id == updateResidentDetail.id);
      if (index != -1) {
        residentDetails[index] = updateResidentDetail;
        notifyListeners();
      }
    }
    return ProcessResponse(
        message: updated ? 'Updated successfully' : 'Update failed!',
        success: updated);
  }

  Future<ProcessResponse> delete({required int index}) async {
    bool deleted = await _dbController.delete(residentDetails[index].id);
    if (deleted) {
      residentDetails.removeAt(index);
      notifyListeners();
    }
    return ProcessResponse(
        message: deleted ? 'Deleted successfully' : 'Delete failed!',
        success: deleted);
  }
}
