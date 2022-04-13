import 'package:datatable/presentation/dialogs/create_table_dialog/create_table_controller.dart';
import 'package:datatable/presentation/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateTableDialog extends StatelessWidget {
  const CreateTableDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CreateTableController createTableController = CreateTableController();
    return AnimatedBuilder(
        animation: createTableController,
        builder: (context, child) {
          return AlertDialog(
            title: const Text("Table Selection"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Select the number of rows and columns"),
                defaultSpacer,
                Row(
                  children: [
                    SizedBox(
                        height: 400,
                        child: Column(
                          children: List.generate(
                              10,
                              (index) => Expanded(
                                      child: Center(
                                    child: Text(
                                      (index + 1).toString(),
                                    ),
                                  ))),
                        )),
                    SizedBox(
                      width: 800,
                      child: Column(
                        children: [
                          Row(
                            children: List.generate(
                                10,
                                (index) => Expanded(
                                        child: Text(
                                      (index + 1).toString(),
                                      textAlign: TextAlign.center,
                                    ))),
                          ),
                          SizedBox(
                            height: 400,
                            child: GridView(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 10,
                                        childAspectRatio: 2),
                                children: List.generate(
                                    100,
                                    (index) => GestureDetector(
                                          onTap: () => createTableController
                                              .changeCellSelection(index),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(),
                                                color: createTableController
                                                    .getColor(index)),
                                          ),
                                        ))),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: createTableController.selectedColumn != null &&
                        createTableController.selectedRow != null
                    ? () => createTableController.createTable()
                    : null,
                child: const Text("Create"),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text("Cancel"),
              ),
            ],
          );
        });
  }
}
