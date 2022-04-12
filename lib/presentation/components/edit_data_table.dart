import 'package:datatable/presentation/components/cell.dart';
import 'package:datatable/presentation/components/edit_data_table_controller.dart';
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
                backgroundColor: Colors.white,
                actions: [
                  if (editDataTableController.selectedCell != null)
                    Row(
                      children: [
                        TextButton(
                            onPressed: editDataTableController.mergeRow,
                            child: const Text("Merge Row")),
                        TextButton(
                            onPressed: editDataTableController.mergeColumn,
                            child: const Text("Merge Column")),
                      ],
                    ),
                  TextButton.icon(
                      onPressed: editDataTableController.addRow,
                      icon: const Icon(Icons.add),
                      label: const Text("Add Row")),
                  TextButton.icon(
                      onPressed: editDataTableController.addColumn,
                      icon: const Icon(Icons.add),
                      label: const Text("Add Column")),
                ],
              ),
              body: Center(
                child: SizedBox(
                  width: editDataTableController.tableWidth + 5,
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
}
