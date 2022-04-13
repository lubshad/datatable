import 'package:datatable/presentation/components/edit_data_table_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateTableController extends ChangeNotifier {
  int? selectedColumn;
  int? selectedRow;

  changeCellSelection(int index) {
    selectedColumn = ((index + 1) % 10) == 0 ? 10 : (index + 1) % 10;
    selectedRow =
        selectedColumn == 10 ? ((index + 1) ~/ 10) : ((index + 1) ~/ 10) + 1;
    notifyListeners();
  }

  getColor(int index) {
    if (selectedColumn == null || selectedRow == null) {
      return Colors.white;
    }

    bool cellInsideColumn = (index) % 10 < selectedColumn!;
    bool cellInsideRow = (index) ~/ 10 < selectedRow!;

    if (cellInsideColumn && cellInsideRow) {
      return Colors.blue;
    } else {
      return Colors.white;
    }
  }

  createTable() {
    Get.find<EditDataTableController>()
        .createTable(newRows: selectedRow!, newColumns: selectedColumn!);

    Get.back();
  }
}
