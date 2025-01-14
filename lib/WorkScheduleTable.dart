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
      body: Row(
        children: [
          // Cột cố định (tên nhân viên và work site)
          Column(
            children: [
              _buildCell('', isHeader: true),
              // Header cột đầu tiên
              ...widget.employees.asMap().entries.map((entry) {
                final index = entry.key;
                final employee = entry.value;
                final isOdd = index % 2 != 0; // Kiểm tra hàng lẻ
                return _buildCell(
                  employee.name,
                  isHeader: false,
                  color: isOdd ? Colors.grey[200] : Colors.white,
                );
              }).toList(),
              const SizedBox(height: 30),
              // Khoảng cách giữa phần nhân viên và work site
              ...widget.workSites.map((workSite) {
                return _buildCell(workSite.name,
                    isHeader: false, color: workSite.color);
              }).toList(),
            ],
          ),
          // Bảng cuộn ngang
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  // Header row (không chứa cột đầu tiên)
                  Row(
                    children: [
                      ...List.generate(
                        daysInMonth,
                        (index) {
                          final date = DateTime(2025, 1, index + 1);
                          final dayOfWeek = DateFormat('EEEE').format(date);
                          final isWeekend = date.weekday == DateTime.saturday ||
                              date.weekday == DateTime.sunday;
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
                  // Employee rows (không chứa cột đầu tiên)
                  ...widget.employees.asMap().entries.map((entry) {
                    final index = entry.key;
                    final employee = entry.value;
                    final isOdd = index % 2 != 0; // Kiểm tra hàng lẻ
                    final rowColor = isOdd ? Colors.grey[200] : Colors.white;
                    return Row(
                      children: [
                        ...List.generate(
                          daysInMonth,
                          (dayIndex) => _buildMultiLineCell(
                            _getWorkSchedules(employee.id, dayIndex + 1),
                          ),
                        ).map(
                            (cell) => Container(color: rowColor, child: cell)),
                        _buildCell(
                          _getEmployeeTotal(employee.id),
                          isHeader: false,
                          color: rowColor,
                        ),
                      ],
                    );
                  }).toList(),
                  const SizedBox(height: 30),
                  // Khoảng cách giữa nhân viên và work site
                  // WorkSite rows (không chứa cột đầu tiên)
                  ...widget.workSites.map((workSite) {
                    return Row(
                      children: [
                        ...List.generate(
                          daysInMonth,
                          (dayIndex) => _buildCell(
                            _getWorkSiteDailyTotal(workSite.id, dayIndex + 1),
                            isHeader: false,
                          ),
                        ),
                        _buildCell(
                          _getWorkSiteTotalById(workSite.id),
                          isHeader: false,
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
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
        color: Colors.cyanAccent,
      ),
      width: 120,
      height: 60, // Đặt chiều cao cố định cho toàn ô
      child: schedules.isEmpty
          ? _buildCell("", border: Border.all(color: Colors.transparent))
          : Column(
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

    // Nếu không có ca nào, trả về một hàng trống
    if (shiftSchedules.isEmpty) {
      return [
        Expanded(
          child: Container(
            width: 120,
            color: Colors.transparent,
            alignment: Alignment.center,
            child: const Text(
              "", // Hiển thị ô trống
              style: TextStyle(fontSize: 12),
            ),
          ),
        ),
      ];
    }

    // Nếu có lịch làm việc trong ca
    return shiftSchedules.map((schedule) {
      final workSite = widget.workSites.firstWhere(
        (site) => site.id == schedule.workSiteId,
        orElse: () => WorkSite(id: 0, name: '', color: Colors.transparent),
      );

      return Expanded(
        child: Container(
          width: 120,
          color: workSite.color, // Màu nền từ WorkSite
          alignment: Alignment.center,
          child: Text(
            workSite.name, // Tên địa điểm làm việc
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
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
