import 'package:flutter/material.dart';

import 'data_test.dart';

class DeleteEmployeeScreen extends StatefulWidget {

  const DeleteEmployeeScreen({Key? key}) : super(key: key);

  @override
  _DeleteEmployeeScreenState createState() => _DeleteEmployeeScreenState();
}

class _DeleteEmployeeScreenState extends State<DeleteEmployeeScreen> {
  // A set to hold selected employee IDs
  final Set<int> _selectedEmployeeIds = {};

  void _confirmDeletion() {
    if (_selectedEmployeeIds.isEmpty) {
      // Show a message if no employee is selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No employees selected to delete.")),
      );
      return;
    }

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text(
            "Are you sure you want to delete?"
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Perform deletion logic here
                setState(() {
                  employees.removeWhere((e) => _selectedEmployeeIds.contains(e.id));
                });
                Navigator.pop(context); // Close the dialog
                Navigator.pop(context); // Return to HomeScreen
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
              onPressed: _confirmDeletion,
              child: const Text("OK"),
            ),
          ),
        ],
      ),
    );
  }
}
