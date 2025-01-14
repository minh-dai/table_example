import 'package:flutter/material.dart';
enum WorkSiteStatus { active, inactive } // Trạng thái công trường

class WorkSite {
  final int id;
  final String name;
  final Color color; // Màu của công trường
  final WorkSiteStatus status; // Trạng thái của công trường

  WorkSite({
    required this.id,
    required this.name,
    required this.color,
    this.status = WorkSiteStatus.active, // Giá trị mặc định là "active"
  });
}
