import 'package:datatable/presentation/components/edit_data_table_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Cell extends StatelessWidget {
  const Cell({Key? key, required this.cell}) : super(key: key);
  final Map<String, dynamic> cell;

  @override
  Widget build(BuildContext context) {
    EditDataTableController editDataTableController = Get.find();

    return Positioned(
      top: editDataTableController.findTopPosition(cell),
      left: editDataTableController.findLeftPosition(cell),
      child: SizedBox(
        width: editDataTableController.findWidth(cell),
        height: editDataTableController.findHeight(cell),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              child: Builder(builder: (context) {
                return TextField(
                    onTap: () => editDataTableController.selectCell(cell),
                    expands: true,
                    maxLines: null,
                    controller:
                        TextEditingController(text: cell["value"].toString()),
                    onChanged: (value) {
                      cell["value"] = value;
                    });
              }),
            ),
            Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Draggable(
                  axis: Axis.horizontal,
                  feedback: Container(),
                  onDragUpdate: (details) =>
                      editDataTableController.changeWidth(details, cell),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.resizeRight,
                    child: Container(
                      width: 10,
                      color: Colors.transparent,
                    ),
                  ),
                )),
            Positioned(
                left: 0,
                bottom: 0,
                right: 0,
                child: Draggable(
                  axis: Axis.vertical,
                  feedback: Container(),
                  onDragUpdate: (details) =>
                      editDataTableController.changeHeight(details, cell),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.resizeDown,
                    child: Container(
                      height: 10,
                      color: Colors.transparent,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
