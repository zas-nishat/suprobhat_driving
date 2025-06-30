import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suprobhat_driving_app/app/config/constants.dart';
import 'package:suprobhat_driving_app/app/data/models/attendance_model.dart';
import 'package:suprobhat_driving_app/app/data/models/student_model.dart';

import '../../../app/data/providers/student_provider.dart';

class AttendanceListItem extends StatefulWidget {
  final Student student;
  final DateTime selectedDate;

  const AttendanceListItem({
    super.key,
    required this.student,
    required this.selectedDate,
  });

  @override
  State<AttendanceListItem> createState() => _AttendanceListItemState();
}

class _AttendanceListItemState extends State<AttendanceListItem> {
  bool _isPresent = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _updateAttendanceStatus(),
    );
  }

  @override
  void didUpdateWidget(covariant AttendanceListItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate ||
        widget.student.id != oldWidget.student.id) {
      _updateAttendanceStatus();
    }
  }

  void _updateAttendanceStatus() {
    final attendanceProvider = Provider.of<StudentProvider>(
      context,
      listen: false,
    );
    final records = attendanceProvider.getAttendanceForDate(
      widget.selectedDate,
    );
    final existingRecord = records.firstWhere(
      (record) => record.studentId == widget.student.id,
      orElse:
          () => Attendance(
            studentId: widget.student.id,
            date: widget.selectedDate,
            isPresent: false,
          ),
    );
    setState(() {
      _isPresent = existingRecord.isPresent;
    });
  }

  void _toggleAttendance(bool value) {
    setState(() {
      _isPresent = value;
    });

    Provider.of<StudentProvider>(context, listen: false).addOrUpdateAttendance(
      Attendance(
        studentId: widget.student.id,
        date: widget.selectedDate,
        isPresent: value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: kMediumPadding,
        vertical: kSmallPadding / 2,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kSmallBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(kMediumPadding),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              backgroundImage:
                  widget.student.photoPath != null
                      ? NetworkImage(
                        widget.student.photoPath!,
                      ) // or FileImage if from local
                      : null,
              child:
                  widget.student.photoPath == null
                      ? Icon(
                        Icons.person,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      )
                      : null,
            ),
            const SizedBox(width: kMediumPadding),
            Expanded(
              child: Text(
                widget.student.name,
                style: kBodyTextStyle.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Switch(value: _isPresent, onChanged: _toggleAttendance),
            Text(_isPresent ? 'Present' : 'Absent'),
          ],
        ),
      ),
    );
  }
}
