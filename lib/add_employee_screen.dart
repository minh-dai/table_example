import 'package:flutter/material.dart';

import 'data_test.dart';

class AddEmployeeScreen extends StatefulWidget {

  const AddEmployeeScreen({Key? key}) : super(key: key);

  @override
  _AddEmployeeScreenState createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final Set<int> _selectedEmployeeIds = {};

  void _confirmAddition() {
    if (_selectedEmployeeIds.isEmpty) {
      // Show a message if no employee is selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No employees selected to add.")),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('作業員編集'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: employees.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final employee = employees[index];
                final isSelected = _selectedEmployeeIds.contains(employee.id);

                return ListTile(
                  leading: Checkbox(
                    value: isSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedEmployeeIds.add(employee.id);
                        } else {
                          _selectedEmployeeIds.remove(employee.id);
                        }
                      });
                    },
                  ),
                  title: Text(employee.name),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _confirmAddition,
              child: const Text("Add"),
            ),
          ),
        ],
      ),
    );
  }
}