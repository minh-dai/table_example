import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'model/employee.dart';
import 'model/work_schedule.dart';
import 'model/work_site.dart';

class WorkScheduleTable extends StatefulWidget {
  final List<Employee> employees;
  final List<WorkSite> workSites;
  final List<WorkSchedule> workSchedules;

  const WorkScheduleTable({
    required this.employees,
    required this.workSites,
    required this.workSchedules,
    Key? key,
  }) : super(key: key);

  @override
  State<WorkScheduleTable> createState() => _WorkScheduleTableState();
}

class _WorkScheduleTableState extends State<WorkScheduleTable> {
  final int daysInMonth = 31;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Work Schedule Table'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            // Header row
            Row(
              children: [
                _buildCell('', isHeader: true),
                ...List.generate(
                  daysInMonth,
                      (index) {
                    final date = DateTime(2025, 1, index + 1);
                    final dayOfWeek = DateFormat('EEEE').format(date);
                    final isWeekend = date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
                    return _buildCell(
                      '${index + 1}\n$dayOfWeek',
                      isHeader: true,
                      color: isWeekend ? Colors.yellow[200] : null,
                    );
                  },
                ),
                _buildCell('Tổng', isHeader: true),
              ],
            ),
            // Employee rows
            ...widget.employees.asMap().entries.map((entry) {
              const border = Border(
                top: BorderSide(color: Colors.black, width: 0.5),
                left: BorderSide(color: Colors.black, width: 0.5),
                right: BorderSide(color: Colors.black, width: 0.5),
                bottom: BorderSide(color: Colors.black, width: 0.5),
              );
              return Row(
                children: [
                  _buildCell(entry.value.name, isHeader: false, border: border),
                  ...List.generate(
                    daysInMonth,
                    (dayIndex) => _buildMultiLineCell(
                      _getWorkSchedules(entry.value.id, dayIndex + 1),
                    ),
                  ),
                  _buildCell(_getEmployeeTotal(entry.value.id),
                      isHeader: false, border: border),
                ],
              );
            }).toList(),

            const SizedBox(height: 30),
            // WorkSite rows
            ...widget.workSites.map((workSite) {
              const border = Border(
                top: BorderSide(color: Colors.transparent, width: 0),
                right: BorderSide(color: Colors.transparent, width: 0.5),
              );
              return Row(
                children: [
                  _buildCell(workSite.name,
                      isHeader: false, color: workSite.color, border: border),
                  ...List.generate(
                    daysInMonth,
                    (dayIndex) => _buildCell(
                      _getWorkSiteDailyTotal(workSite.id, dayIndex + 1),
                      isHeader: false,
                    ),
                  ),
                  _buildCell(_getWorkSiteTotalById(workSite.id),
                      isHeader: false),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  // Lấy danh sách WorkSchedule của nhân viên theo ngày
  List<WorkSchedule> _getWorkSchedules(int employeeId, int day) {
    return widget.workSchedules
        .where((schedule) =>
            schedule.employeeId == employeeId && schedule.day == day)
        .toList();
  }

  // Tính tổng số lần làm việc của nhân viên
  String _getEmployeeTotal(int employeeId) {
    final totalHours = widget.workSchedules
        .where((schedule) => schedule.employeeId == employeeId)
        .fold<int>(0, (sum, schedule) => sum + schedule.hoursWorked);
    final days = totalHours ~/ 24;
    final remainingHours = totalHours % 24;

    return '$days day, $remainingHours hour';
  }


  // Tính tổng số lần làm việc tại WorkSite trong ngày
  String _getWorkSiteDailyTotal(int workSiteId, int day) {
    final totalShifts = widget.workSchedules
        .where((schedule) =>
            schedule.workSiteId == workSiteId && schedule.day == day)
        .length;

    return totalShifts > 0 ? totalShifts.toString() : '0';
  }

  // Tính tổng số lần làm việc tại WorkSite trong tháng
  String _getWorkSiteTotalById(int workSiteId) {
    final totalShifts = widget.workSchedules
        .where((schedule) => schedule.workSiteId == workSiteId)
        .length;

    return '$totalShifts';
  }

  // Tạo ô trong bảng cho nhiều dòng
  Widget _buildMultiLineCell(List<WorkSchedule> schedules) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        color: Colors.white,
      ),
      width: 120,
      child: schedules.isEmpty
          ? _buildCell("", border: Border.all(color: Colors.transparent))
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ..._buildShiftCells(schedules, Shift.first),
                ..._buildShiftCells(schedules, Shift.second),
              ],
            ),
    );
  }

  List<Widget> _buildShiftCells(List<WorkSchedule> schedules, Shift shift) {
    final shiftSchedules =
        schedules.where((schedule) => schedule.shift == shift).toList();

    if (shiftSchedules.isEmpty) {
      return [
        Container(
          height: 30,
          width: 120,
          color: Colors.transparent,
          alignment: Alignment.center,
          child: const Text(
            "",
            style: TextStyle(fontSize: 12),
          ),
        ),
      ];
    }

    return shiftSchedules.map((schedule) {
      final workSite = widget.workSites.firstWhere(
          (site) => site.id == schedule.workSiteId,
          orElse: () => WorkSite(id: 0, name: '', color: Colors.transparent));

      return Container(
        height: 30,
        width: 120,
        color: workSite.color,
        alignment: Alignment.center,
        child: Text(
          workSite.name,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12),
        ),
      );
    }).toList();
  }

  // Tạo ô trong bảng
  Widget _buildCell(String text,
      {bool isHeader = false, Color? color, BoxBorder? border}) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: border ?? Border.all(color: Colors.grey),
        color: color ?? (isHeader ? Colors.grey[300] : Colors.white),
      ),
      width: 120,
      height: 60,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }
}
