import 'package:datatable/presentation/components/cell.dart';
import 'package:datatable/presentation/components/edit_data_table_controller.dart';
import 'package:datatable/presentation/dialogs/create_table_dialog/create_table_dialog.dart';
import 'package:datatable/presentation/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditDataTable extends StatelessWidget {
  const EditDataTable({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => EditDataTableController());
    EditDataTableController editDataTableController = Get.find();
    return AnimatedBuilder(
        animation: editDataTableController,
        builder: (context, child) {
          return Scaffold(
              appBar: AppBar(
                actions: [
                  if (editDataTableController.columns.isNotEmpty &&
                      editDataTableController.rows.isNotEmpty)
                    Row(
                      children: [
                        // if (editDataTableController.undoStack.isNotEmpty)
                        IconButton(
                            onPressed: editDataTableController.undo,
                            icon: const Icon(Icons.undo)),
                        // if (editDataTableController.redoStack.isNotEmpty)
                        IconButton(
                            onPressed: editDataTableController.redo,
                            icon: const Icon(Icons.redo)),
                        defaultSpacerHorizontalLarge,
                      ],
                    ),
                  if (editDataTableController.selectedCell != null)
                    Row(
                      children: [
                        TextButton(
                            onPressed: () => editDataTableController.mergeRow(
                                editDataTableController.selectedCell!),
                            child: const Text("Merge Row")),
                        TextButton(
                            onPressed: () =>
                                editDataTableController.mergeColumn(
                                    editDataTableController.selectedCell!),
                            child: const Text("Merge Column")),
                        defaultSpacerHorizontalLarge,
                        TextButton(
                            onPressed: editDataTableController.splitRow,
                            child: const Text("Split Row")),
                        TextButton(
                            onPressed: editDataTableController.splitColumn,
                            child: const Text("Split Column")),
                        defaultSpacerHorizontalLarge,
                      ],
                    ),
                  if (editDataTableController.columns.isNotEmpty &&
                      editDataTableController.rows.isNotEmpty)
                    Row(
                      children: [
                        TextButton.icon(
                            onPressed: editDataTableController.addRow,
                            icon: const Icon(Icons.add),
                            label: const Text("Add Row")),
                        TextButton.icon(
                            onPressed: editDataTableController.addColumn,
                            icon: const Icon(Icons.add),
                            label: const Text("Add Column")),
                        defaultSpacerHorizontalLarge,
                      ],
                    ),
                  IconButton(
                      onPressed: showTableSelectionDialog,
                      icon: const Icon(Icons.table_chart_outlined)),
                  defaultSpacerHorizontalLarge,
                ],
              ),
              body: Center(
                child: SizedBox(
                  width: editDataTableController.tableWidth,
                  height: editDataTableController.tableHeight,
                  child: Stack(
                    children: editDataTableController.cells
                        .where((element) => (element["row_merged"] != true))
                        .where((element) => element["column_merged"] != true)
                        .map((e) => Cell(cell: e))
                        .toList(),
                  ),
                ),
              ));
        });
  }

  void showTableSelectionDialog() {
    Get.dialog(const CreateTableDialog());
  }
}
