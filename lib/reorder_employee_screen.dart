import 'package:flutter/material.dart';
import 'package:table_test/colors.dart';

import 'data_test.dart';
import 'model/employee.dart';

class ReorderEmployeeScreen extends StatefulWidget {
  const ReorderEmployeeScreen({Key? key}) : super(key: key);

  @override
  _ReorderEmployeeScreenState createState() => _ReorderEmployeeScreenState();
}

class _ReorderEmployeeScreenState extends State<ReorderEmployeeScreen> {
  late List<Employee> _employees;

  @override
  void initState() {
    super.initState();
    _employees = List.from(employees); // Create a mutable copy of the list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('作業員並び替え'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, _employees); // Return the updated list
          },
        ),
      ),
      body: ReorderableListView(
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) {
              newIndex -= 1; // Adjust for index shift during reorder
            }
            final item = _employees.removeAt(oldIndex);
            _employees.insert(newIndex, item);
          });
        },
        children: [
          for (int i = 0; i < _employees.length; i++)
            Padding(
              key: ValueKey(_employees[i].id),
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.borderColor,
                      width: i == _employees.length - 1 ? 1 : 0.5,
                    ),
                    top: BorderSide(
                      color: AppColors.borderColor,
                      width: i == 0 ? 1 : 0.5,
                    ),
                  ),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(_employees[i].name),
                  trailing: const Icon(Icons.drag_handle),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
