import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For JSON encoding/decoding
import 'package:suprobhat_driving_app/app/data/models/student_model.dart';
import 'package:suprobhat_driving_app/app/data/models/attendance_model.dart';

class StudentProvider with ChangeNotifier {
  static const String _studentsKey = 'students';
  static const String _attendanceKey = 'attendance';

  late SharedPreferences _prefs;

  List<Student> _students = [];
  List<Attendance> _attendanceRecords = [];

  List<Student> get students => _students;
  List<Attendance> get attendanceRecords => _attendanceRecords;

  StudentProvider() {
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _loadStudents();
    _loadAttendanceRecords();
  }

  void _loadStudents() {
    final studentsJson = _prefs.getStringList(_studentsKey);
    if (studentsJson != null) {
      _students = studentsJson.map((jsonString) => Student.fromJson(json.decode(jsonString))).toList();
    } else {
      _students = [];
    }
    notifyListeners();
  }

  void _saveStudents() {
    final studentsJson = _students.map((student) => json.encode(student.toJson())).toList();
    _prefs.setStringList(_studentsKey, studentsJson);
  }

  void _loadAttendanceRecords() {
    final attendanceJson = _prefs.getStringList(_attendanceKey);
    if (attendanceJson != null) {
      _attendanceRecords = attendanceJson.map((jsonString) => Attendance.fromJson(json.decode(jsonString))).toList();
    } else {
      _attendanceRecords = [];
    }
    notifyListeners();
  }

  void _saveAttendanceRecords() {
    final attendanceJson = _attendanceRecords.map((attendance) => json.encode(attendance.toJson())).toList();
    _prefs.setStringList(_attendanceKey, attendanceJson);
  }

  Future<void> addStudent(Student student) async {
    _students.add(student);
    _saveStudents();
    notifyListeners();
  }

  Future<void> updateStudent(Student student) async {
    final index = _students.indexWhere((s) => s.id == student.id);
    if (index != -1) {
      _students[index] = student;
      _saveStudents();
      notifyListeners();
    }
  }

  Future<void> deleteStudent(String studentId) async {
    _students.removeWhere((student) => student.id == studentId);
    _attendanceRecords.removeWhere((record) => record.studentId == studentId);
    _saveStudents();
    _saveAttendanceRecords();
    notifyListeners();
  }

  Student? getStudentById(String id) {
    try {
      return _students.firstWhere((student) => student.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Student> searchStudents(String query) {
    if (query.isEmpty) {
      return _students;
    }
    return _students.where((student) =>
        student.name.toLowerCase().contains(query.toLowerCase()) ||
        student.phone.contains(query)).toList();
  }

  // Attendance methods
  Future<void> addOrUpdateAttendance(Attendance attendance) async {
    final index = _attendanceRecords.indexWhere(
      (record) => record.studentId == attendance.studentId && record.date.day == attendance.date.day && record.date.month == attendance.date.month && record.date.year == attendance.date.year,
    );

    if (index != -1) {
      _attendanceRecords[index] = attendance;
    } else {
      _attendanceRecords.add(attendance);
    }
    _saveAttendanceRecords();
    notifyListeners();
  }

  List<Attendance> getAttendanceForStudent(String studentId) {
    return _attendanceRecords.where((record) => record.studentId == studentId).toList();
  }

  List<Attendance> getAttendanceForDate(DateTime date) {
    return _attendanceRecords.where((record) =>
        record.date.day == date.day &&
        record.date.month == date.month &&
        record.date.year == date.year).toList();
  }

  int getAttendanceCount(String studentId) {
    return getAttendanceForStudent(studentId).where((record) => record.isPresent).length;
  }

  List<Student> getUpcomingCourseEndStudents() {
    final now = DateTime.now();
    return _students.where((student) {
      final endDate = student.endDate;
      final difference = endDate.difference(now).inDays;
      return difference >= 0 && difference <= 7; // Courses ending in the next 7 days
    }).toList();
  }
}
