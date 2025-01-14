import 'package:flutter/material.dart';

import 'model/employee.dart';
import 'model/work_schedule.dart';
import 'model/work_site.dart';

final List<Employee> employees = [
  Employee(id: 1, name: 'nv 1'),
  Employee(id: 2, name: 'nv 2'),
  Employee(id: 3, name: 'nv 3'),
];

final List<WorkSite> workSites = [
  WorkSite(id: 1, name: 'Construct 1', color: Colors.green),
  WorkSite(id: 2, name: 'Construct 2', color: Colors.blue),
  WorkSite(id: 3, name: 'Construct 3', color: Colors.orange),
  WorkSite(id: 4, name: 'Day Off', color: Colors.red),
];

final List<WorkSchedule> workSchedules = [
  for (int day = 1; day <= 31; day++) ...[
    WorkSchedule(
        employeeId: 1,
        day: day,
        shift: Shift.first,
        workSiteId: day % 2 == 0 ? 1 : 4,
        hoursWorked: day % 2 == 0 ? 8 : 0),
    WorkSchedule(
        employeeId: 1,
        day: day,
        shift: Shift.second,
        workSiteId: day % 3 == 0 ? 4 : 2,
        hoursWorked: day % 3 == 0 ? 8 : 4),
    WorkSchedule(
        employeeId: 2,
        day: day,
        shift: Shift.first,
        workSiteId: day % 2 == 0 ? 2 : 3,
        hoursWorked: day % 2 == 0 ? 8 : 0),
    WorkSchedule(
        employeeId: 2,
        day: day,
        shift: Shift.second,
        workSiteId: day % 3 == 0 ? 4 : 1,
        hoursWorked: day % 3 == 0 ? 8 : 6),
    WorkSchedule(
        employeeId: 3,
        day: day,
        shift: Shift.first,
        workSiteId: day % 4 == 0 ? 4 : 1,
        hoursWorked: day % 4 == 0 ? 8 : 0),
    WorkSchedule(
        employeeId: 3,
        day: day,
        shift: Shift.second,
        workSiteId: day % 5 == 0 ? 3 : 2,
        hoursWorked: day % 5 == 0 ? 8 : 7),
  ]
];
