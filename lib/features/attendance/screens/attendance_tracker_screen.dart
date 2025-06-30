import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:suprobhat_driving_app/app/config/constants.dart';
import 'package:suprobhat_driving_app/app/data/models/attendance_model.dart';

import 'package:suprobhat_driving_app/app/data/providers/student_provider.dart';
import 'package:suprobhat_driving_app/features/attendance/widgets/attendance_list_item.dart';
import 'package:suprobhat_driving_app/shared_widgets/custom_app_bar.dart';

class AttendanceTrackerScreen extends StatefulWidget {
  const AttendanceTrackerScreen({super.key});

  @override
  State<AttendanceTrackerScreen> createState() =>
      _AttendanceTrackerScreenState();
}

class _AttendanceTrackerScreenState extends State<AttendanceTrackerScreen> {
  DateTime _selectedDate = DateTime.now();

  void _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveAttendance() {
    final studentProvider = Provider.of<StudentProvider>(
      context,
      listen: false,
    );

    for (var student in studentProvider.students) {
      final isPresent = studentProvider
          .getAttendanceForDate(_selectedDate)
          .any((record) => record.studentId == student.id && record.isPresent);

      studentProvider.addOrUpdateAttendance(
        Attendance(
          studentId: student.id,
          date: _selectedDate,
          isPresent:
              isPresent, // This will be updated by the AttendanceListItem
        ),
      );
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Attendance saved!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Attendance Tracker'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(kMediumPadding),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Date: ${DateFormat('dd MMM yyyy').format(_selectedDate)}',
                    style: kSubHeadingTextStyle,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _pickDate,
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<StudentProvider>(
              builder: (context, studentProvider, child) {
                if (studentProvider.students.isEmpty) {
                  return const Center(
                    child: Text('No students to track attendance for.'),
                  );
                }
                return ListView.builder(
                  itemCount: studentProvider.students.length,
                  itemBuilder: (context, index) {
                    final student = studentProvider.students[index];
                    return AttendanceListItem(
                      student: student,
                      selectedDate: _selectedDate,
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(kMediumPadding),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveAttendance,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: kMediumPadding),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kSmallBorderRadius),
                  ),
                ),
                child: const Text(
                  'Save Attendance',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
