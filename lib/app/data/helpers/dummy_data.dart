import 'package:suprobhat_driving_app/app/data/models/student_model.dart';
import 'package:suprobhat_driving_app/app/data/models/attendance_model.dart';

List<Student> getDummyStudents() {
  return [
    Student(
      id: 'std-001',
      name: 'Rahim Islam',
      phone: '01700000001',
      address: '123 Mirpur, Dhaka',
      courseType: 'Manual',
      courseDuration: 30,
      startDate: DateTime.now().subtract(const Duration(days: 10)),
      photoPath: null,
    ),
    Student(
      id: 'std-002',
      name: 'Karina Ahmed',
      phone: '01800000002',
      address: '456 Gulshan, Dhaka',
      courseType: 'Auto',
      courseDuration: 15,
      startDate: DateTime.now().subtract(const Duration(days: 5)),
      photoPath: null,
    ),
    Student(
      id: 'std-003',
      name: 'Fahim Khan',
      phone: '01900000003',
      address: '789 Dhanmondi, Dhaka',
      courseType: 'Manual',
      courseDuration: 45,
      startDate: DateTime.now().subtract(const Duration(days: 20)),
      photoPath: null,
    ),
  ];
}

List<Attendance> getDummyAttendance() {
  final now = DateTime.now();
  return [
    Attendance(
      studentId: 'std-001',
      date: now.subtract(const Duration(days: 1)),
      isPresent: true,
    ),
    Attendance(
      studentId: 'std-001',
      date: now.subtract(const Duration(days: 2)),
      isPresent: true,
    ),
    Attendance(
      studentId: 'std-002',
      date: now.subtract(const Duration(days: 1)),
      isPresent: false,
    ),
  ];
}
