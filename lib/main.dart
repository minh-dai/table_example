import 'package:flutter/material.dart';
import 'package:table_test/reorder_employee_screen.dart';

import 'add_employee_screen.dart';
import 'delete_employee_screen.dart';
import 'WorkScheduleTable.dart';
import 'data_test.dart';
import 'model/employee.dart';
import 'model/work_schedule.dart';
import 'model/work_site.dart';

void main() => runApp(
      MaterialApp(
        home: HomeScreen(
          employees: employees,
          workSites: workSites,
          workSchedules: workSchedules,
        ),
      ),
    );

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.employees,
    required this.workSites,
    required this.workSchedules,
  });

  final List<Employee> employees;
  final List<WorkSite> workSites;
  final List<WorkSchedule> workSchedules;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('10月シフト'),
        actions: [
          PopupMenuButton<int>(
            onSelected: (value) {
              switch (value) {
                case 0:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEmployeeScreen(),
                    ),
                  );
                  break;
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReorderEmployeeScreen(),
                    ),
                  );
                  break;
                case 2:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeleteEmployeeScreen(),
                    ),
                  );
                  break;
                case 3:
                  print("画像出力 selected");
                  break;
                case 4:
                  print("PDF出力 selected");
                  break;
                case 5:
                  print("作業員別シフト表出力 selected");
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("作業員追加"),
                    SizedBox(width: 8),
                    Icon(Icons.person_add, color: Colors.black),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 1,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("作業員並び替え"),
                    SizedBox(width: 8),
                    Icon(Icons.sort, color: Colors.black),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 2,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("作業員削除"),
                    SizedBox(width: 8),
                    Icon(Icons.delete, color: Colors.black),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 3,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("画像出力"),
                    SizedBox(width: 8),
                    Icon(Icons.image, color: Colors.black),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 4,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("PDF出力"),
                    SizedBox(width: 8),
                    Icon(Icons.picture_as_pdf, color: Colors.black),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 5,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("作業員別シフト表出力"),
                    SizedBox(width: 8),
                    Icon(Icons.table_chart, color: Colors.black),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: WorkScheduleTable(
        employees: employees,
        workSites: workSites,
        workSchedules: workSchedules,
      ),
    );
  }
}
