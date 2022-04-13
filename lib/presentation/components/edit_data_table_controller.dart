import 'package:flutter/material.dart';

class EditDataTableController extends ChangeNotifier {
  List<Map<String, dynamic>> cells = [];
  List<Map<String, dynamic>> columns = [];
  List<Map<String, dynamic>> rows = [];

  Map<String, dynamic>? selectedCell;

  double get tableWidth =>
      columns.fold(0.0, (a, b) => a + b["width"].toDouble());

  double get tableHeight =>
      rows.fold(0.0, (a, b) => a + b["height"].toDouble());

  void addRow() {
    rows.add({
      "height": 50,
    });
    int totalNumberOfCells = columns.length * rows.length;
    int numberOfCellsToAdd = totalNumberOfCells - cells.length;
    for (int i = 0; i < numberOfCellsToAdd; i++) {
      cells.add({
        'value': '',
      });
    }
    notifyListeners();
  }

  void addColumn() {
    // int totalNumberOfCells = columns.length * rows.length;
    // int numberOfCellsToAdd = totalNumberOfCells - cells.length;
    List<int> newColumnCellIndexes = [];
    for (int i = 1; i != cells.length + 1; i++) {
      if (i % columns.length == 0) {
        newColumnCellIndexes.add(i);
      }
    }
    int index = 0;
    for (int i = 0; i < newColumnCellIndexes.length; i++) {
      cells.insert(newColumnCellIndexes[i] + index, {
        'value': '',
      });
      index++;
    }
    columns.add({
      'width': 100,
    });
    notifyListeners();
  }

  int findRow(Map<String, dynamic> cell) {
    int rowIndex = (cells.indexOf(cell) + 1) % columns.length == 0
        ? (cells.indexOf(cell) + 1) ~/ columns.length
        : ((cells.indexOf(cell) + 1) ~/ columns.length) + 1;
    return rowIndex - 1;
  }

  int findColumn(Map<String, dynamic> cell) {
    int columnIndex = (cells.indexOf(cell) + 1) % columns.length == 0
        ? columns.length
        : (cells.indexOf(cell) + 1) % columns.length;
    return columnIndex - 1;
  }

  void changeHeight(DragUpdateDetails details, Map<String, dynamic> cell) {
    List<Map<String, dynamic>> mergedCells = findMergerCellsColumn(cell);
    int rowIndex = findRow(cell);
    final double height = details.delta.dy;
    if (mergedCells.isNotEmpty) {
      rowIndex = findRow(mergedCells.last);
    }
    if ((rows[rowIndex]["height"] + height) > 50) {
      rows[rowIndex]["height"] += height;
    }
    notifyListeners();
  }

  void changeWidth(DragUpdateDetails details, Map<String, dynamic> cell) {
    List<Map<String, dynamic>> mergedCells = findMergerCellsRow(cell);
    int columnIndex = findColumn(cell);
    final double width = details.delta.dx;
    if (mergedCells.isNotEmpty) {
      columnIndex = findColumn(mergedCells.last);
    }
    if ((columns[columnIndex]["width"] + width) > 50) {
      columns[columnIndex]["width"] += width;
    }
    notifyListeners();
  }

  selectCell(Map<String, dynamic>? cell) {
    selectedCell = cell;
    notifyListeners();
  }

  void mergeRow() {
    int nextCell = cells.indexOf(selectedCell!) + 1;
    int rowEnding = findRowEnding(selectedCell!);

    List<Map<String, dynamic>> mergedCells = findMergerCellsRow(selectedCell!);
    List<Map<String, dynamic>> mergedCollums =
        findMergerCellsColumn(selectedCell!);

    double height = findHeight(selectedCell!);

    if (mergedCells.isNotEmpty) {
      nextCell = cells.indexOf(mergedCells.last) + 1;
    }
    if (rowEnding == nextCell - 1) {
      return;
    }

    double nextCellheight = findHeight(cells[nextCell]);
    if (height != nextCellheight || cells[nextCell]["column_merged"] == true) {
      return;
    }

    undoStack.add({
      "type": "merge",
      "cells": cells.map((e) => Map<String, dynamic>.from(e)).toList(),
    });

    if (mergedCollums.isNotEmpty) {
      for (int i = 1; i < mergedCollums.length + 1; i++) {
        cells[(nextCell) + i * (columns.length)]["column_merged"] = true;
      }
    }

    cells[nextCell]["row_merged"] = true;

    notifyListeners();
  }

  void mergeColumn() {
    int nextCell = cells.indexOf(selectedCell!) + columns.length;
    int columnEnding = findColumnEnding(selectedCell!);

    List<Map<String, dynamic>> mergedCells =
        findMergerCellsColumn(selectedCell!);
    List<Map<String, dynamic>> mergedRows = findMergerCellsRow(selectedCell!);

    double width = findWidth(selectedCell!);

    if (mergedCells.isNotEmpty) {
      nextCell = cells.indexOf(mergedCells.last) + columns.length;
    }
    if (columnEnding == nextCell - columns.length) {
      return;
    }

    double nextCellWidth = findWidth(cells[nextCell]);

    if (width != nextCellWidth || cells[nextCell]["row_merged"] == true) {
      return;
    }

    undoStack.add({
      "type": "merge",
      "cells": cells.map((e) => Map<String, dynamic>.from(e)).toList(),
    });

    if (mergedRows.isNotEmpty) {
      for (int i = 1; i < mergedRows.length + 1; i++) {
        cells[(nextCell) + i]["row_merged"] = true;
      }
    }

    cells[nextCell]["column_merged"] = true;
    notifyListeners();
  }

  findWidth(Map<String, dynamic> cell) {
    int columnIndex = findColumn(cell);
    double width = columns[columnIndex]['width'].toDouble();
    List<Map<String, dynamic>> mergedCells = findMergerCellsRow(cell);
    for (Map<String, dynamic> mergedCell in mergedCells) {
      int mergedCellColumIndex = findColumn(mergedCell);
      width += columns[mergedCellColumIndex]['width'].toDouble();
    }
    return width;
  }

  findHeight(Map<String, dynamic> cell) {
    int rowIndex = findRow(cell);
    double height = rows[rowIndex]['height'].toDouble();
    List<Map<String, dynamic>> mergedCells = findMergerCellsColumn(cell);
    for (Map<String, dynamic> mergedCell in mergedCells) {
      int mergedCellRowIndex = findRow(mergedCell);
      height += rows[mergedCellRowIndex]['height'].toDouble();
    }
    return height;
  }

  int findNextCell(Map<String, dynamic> cell) {
    int currentIndex = cells.indexOf(cell);
    for (int i = currentIndex + 1; i < cells.length; i++) {
      if (cells[i]["row_merged"] == false) {
        return i;
      }
    }
    return currentIndex;
  }

  int findRowEnding(Map<String, dynamic> cell) {
    int rowIndex = findRow(cell) + 1;
    int rowEnding = rowIndex * columns.length;
    return rowEnding - 1;
  }

  int findColumnEnding(Map<String, dynamic> cell) {
    int columnIndex = findColumn(cell) + 1;
    int columnEnding = ((rows.length - 1) * columns.length) + columnIndex;
    return columnEnding - 1;
  }

  List<Map<String, dynamic>> findMergerCellsRow(Map<String, dynamic> cell) {
    int rowEnding = findRowEnding(cell);
    List<Map<String, dynamic>> mergedCells = [];
    for (int i = (cells.indexOf(cell) + 1); i < rowEnding + 1; i++) {
      if (cells[i]["row_merged"] == true) {
        mergedCells.add(cells[i]);
      } else {
        break;
      }
    }
    return mergedCells;
  }

  List<Map<String, dynamic>> findMergerCellsColumn(Map<String, dynamic> cell) {
    int columnEnding = findColumnEnding(cell);

    List<Map<String, dynamic>> mergedCells = [];
    for (int i = (cells.indexOf(cell) + columns.length);
        i < (columnEnding + 1);
        i += columns.length) {
      if (cells[i]["column_merged"] == true) {
        mergedCells.add(cells[i]);
        continue;
      } else {
        break;
      }
    }
    return mergedCells;
  }

  findTopPosition(Map<String, dynamic> cell) {
    int rowIndex = findRow(cell);
    double topPosition = 0;
    for (int i = 0; i < rowIndex; i++) {
      topPosition += rows[i]['height'].toDouble();
    }
    return topPosition;
  }

  findLeftPosition(Map<String, dynamic> cell) {
    int columnIndex = findColumn(cell);
    double leftPosition = 0;
    for (int i = 0; i < columnIndex; i++) {
      leftPosition += columns[i]['width'].toDouble();
    }
    return leftPosition;
  }

  void createTable({required int newRows, required int newColumns}) {
    cells.clear();
    columns.clear();
    rows.clear();

    int totalCells = newRows * newColumns;

    for (int i = 0; i < totalCells; i++) {
      cells.add({"value": "cell ${i + 1}"});
    }

    for (int i = 0; i < newColumns; i++) {
      columns.add({"width": 100});
    }

    for (int i = 0; i < newRows; i++) {
      rows.add({"height": 50});
    }
    notifyListeners();
  }

  List<Map<String, dynamic>> undoStack = [];

  List<Map<String, dynamic>> redoStack = [];

  void undo() {
    print(undoStack);
    if (undoStack.isNotEmpty) {
      Map<String, dynamic> lastAction = undoStack.last;
      handleLastAction(lastAction);
      redoStack.add(lastAction);
      undoStack.removeLast();
    }
  }

  void redo() {
    print(redoStack);
    if (redoStack.isNotEmpty) {
      Map<String, dynamic> lastAction = redoStack.last;
      handleLastAction(lastAction);
      undoStack.add(lastAction);
      redoStack.removeLast();
    }
  }

  void handleLastAction(Map<String, dynamic> lastAction) {
    switch (lastAction["type"]) {
      case "merge":
        cells = lastAction["cells"];
        notifyListeners();
    }
  }
}
