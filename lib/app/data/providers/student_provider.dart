import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For JSON encoding/decoding
import 'package:suprobhat_driving_app/app/data/models/student_model.dart';
import 'package:suprobhat_driving_app/app/data/models/attendance_model.dart';
import 'package:flutter/foundation.dart';

class StudentProvider with ChangeNotifier {
  late SharedPreferences _prefs;
  final String _studentsKey = 'students';
  final String _attendanceKey = 'attendance';

  final List<Student> _students = [];
  final Map<String, List<Attendance>> _attendance = {};

  List<Student> get students => [..._students];

  StudentProvider() {
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _loadData();
  }

  void _loadData() {
    // Load students
    final studentsJson = _prefs.getStringList(_studentsKey);
    if (studentsJson != null) {
      _students.clear();
      _students.addAll(
        studentsJson.map((json) => Student.fromJson(jsonDecode(json))),
      );
    }

    // Load attendance
    final attendanceJson = _prefs.getString(_attendanceKey);
    if (attendanceJson != null) {
      final Map<String, dynamic> attendanceMap = jsonDecode(attendanceJson);
      _attendance.clear();
      attendanceMap.forEach((studentId, records) {
        _attendance[studentId] = (records as List)
            .map((record) => Attendance.fromJson(record))
            .toList();
      });
    }

    notifyListeners();
  }

  Future<void> _saveData() async {
    // Save students
    await _prefs.setStringList(
      _studentsKey,
      _students.map((student) => jsonEncode(student.toJson())).toList(),
    );

    // Save attendance
    final Map<String, dynamic> attendanceMap = {};
    _attendance.forEach((studentId, records) {
      attendanceMap[studentId] = records.map((record) => record.toJson()).toList();
    });
    await _prefs.setString(_attendanceKey, jsonEncode(attendanceMap));
  }

  Student? getStudentById(String id) {
    try {
      return _students.firstWhere((student) => student.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> addStudent(Student student) async {
    _students.add(student);
    _attendance[student.id] = [];
    await _saveData();
    notifyListeners();
  }

  Future<void> updateStudent(Student updatedStudent) async {
    final index = _students.indexWhere((student) => student.id == updatedStudent.id);
    if (index >= 0) {
      _students[index] = updatedStudent;
      await _saveData();
      notifyListeners();
    }
  }

  Future<void> deleteStudent(String id) async {
    _students.removeWhere((student) => student.id == id);
    _attendance.remove(id);
    await _saveData();
    notifyListeners();
  }

  // Attendance Methods
  List<Attendance> getStudentAttendance(String studentId) {
    return _attendance[studentId] ?? [];
  }

  Future<void> markAttendance(String studentId, DateTime date, bool isPresent) async {
    if (!_attendance.containsKey(studentId)) {
      _attendance[studentId] = [];
    }

    // Get the normalized date (without time)
    final normalizedDate = DateTime(
      date.year,
      date.month,
      date.day,
    );

    // Check if attendance is already marked as present
    final existingAttendance = _attendance[studentId]!.any((a) => 
      isSameDay(a.date, normalizedDate) && a.isPresent
    );

    // If already marked as present, don't allow changes
    if (existingAttendance) {
      return;
    }

    // Remove existing attendance for the same date if any
    _attendance[studentId]!.removeWhere(
      (attendance) => isSameDay(attendance.date, normalizedDate),
    );

    // Add new attendance (only if marking as present)
    if (isPresent) {
      _attendance[studentId]!.add(
        Attendance(
          studentId: studentId,
          date: normalizedDate,
          isPresent: true,
        ),
      );
    }

    await _saveData();
    notifyListeners();
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  int getAttendanceCount(String studentId) {
    return _attendance[studentId]?.where((a) => a.isPresent).length ?? 0;
  }

  Map<DateTime, bool> getAttendanceMap(String studentId) {
    final attendanceList = _attendance[studentId] ?? [];
    return {
      for (var attendance in attendanceList)
        DateTime(
          attendance.date.year,
          attendance.date.month,
          attendance.date.day,
        ): attendance.isPresent
    };
  }

  List<Attendance> getAttendanceForDate(DateTime date) {
    List<Attendance> result = [];
    _attendance.forEach((studentId, attendanceList) {
      final attendance = attendanceList.where((record) =>
        record.date.year == date.year &&
        record.date.month == date.month &&
        record.date.day == date.day
      );
      result.addAll(attendance);
    });
    return result;
  }

  List<Student> getUpcomingCourseEndStudents() {
    final now = DateTime.now();
    return _students.where((student) {
      final daysLeft = student.endDate.difference(now).inDays;
      return daysLeft >= 0 && daysLeft <= 7;
    }).toList();
  }

  List<Student> searchStudents(String query) {
    if (query.isEmpty) {
      return _students;
    }
    final lowercaseQuery = query.toLowerCase();
    return _students.where((student) =>
      student.name.toLowerCase().contains(lowercaseQuery) ||
      student.phone.contains(query) ||
      student.address.toLowerCase().contains(lowercaseQuery) ||
      student.courseType.toLowerCase().contains(lowercaseQuery)
    ).toList();
  }
}
