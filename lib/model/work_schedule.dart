
enum Shift { first, second }

class WorkSchedule {
  int employeeId;
  int day;
  Shift shift;
  int? workSiteId; // ID công trường (null nếu là "Day off")
  int hoursWorked;

  WorkSchedule({
    required this.employeeId,
    required this.day,
    required this.shift,
    this.workSiteId,
    this.hoursWorked = 0,
  });
}

