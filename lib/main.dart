import 'package:flutter/material.dart';

import 'WorkScheduleTable.dart';
import 'data_test.dart';

void main() => runApp(
      MaterialApp(
        home: WorkScheduleTable(
          employees: employees,
          workSites: workSites,
          workSchedules: workSchedules,
        ),
      ),
    );
