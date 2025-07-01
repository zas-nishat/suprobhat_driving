import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suprobhat_driving_app/app/config/constants.dart';
import 'package:suprobhat_driving_app/app/data/models/student_model.dart';
import 'package:suprobhat_driving_app/app/data/providers/student_provider.dart';
import 'dart:io';

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
  bool _isAttendanceMarked = false;

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
    final studentProvider = Provider.of<StudentProvider>(
      context,
      listen: false,
    );
    
    final attendanceMap = studentProvider.getAttendanceMap(widget.student.id);
    final date = DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
      widget.selectedDate.day,
    );
    
    setState(() {
      _isAttendanceMarked = attendanceMap.containsKey(date);
      _isPresent = attendanceMap[date] ?? false;
    });
  }

  void _toggleAttendance(bool? value) {
    // If already marked as present, don't allow changes
    if (_isPresent) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Attendance is already marked for this day'),
          backgroundColor: Colors.teal,
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    if (value == null || !value) return; // Only allow marking as present

    setState(() {
      _isPresent = true;
      _isAttendanceMarked = true;
    });

    Provider.of<StudentProvider>(context, listen: false).markAttendance(
      widget.student.id,
      widget.selectedDate,
      true,
    );

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Attendance marked as present'),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.teal,
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
              backgroundImage: widget.student.photoPath != null
                  ? FileImage(File(widget.student.photoPath!))
                  : null,
              child: widget.student.photoPath == null
                  ? Icon(
                      Icons.person,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    )
                  : null,
            ),
            const SizedBox(width: kMediumPadding),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.student.name,
                    style: kBodyTextStyle.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.student.phone,
                    style: kBodyTextStyle.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  if (_isAttendanceMarked)
                    Text(
                      _isPresent ? 'Present' : 'Absent',
                      style: TextStyle(
                        color: _isPresent ? Colors.teal : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
            Switch(
              value: _isPresent,
              onChanged: _isPresent ? null : _toggleAttendance,
              activeColor: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }
}
