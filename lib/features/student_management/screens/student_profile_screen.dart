import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:suprobhat_driving_app/app/config/constants.dart';
import 'package:suprobhat_driving_app/app/data/models/student_model.dart';
import 'package:suprobhat_driving_app/app/data/providers/student_provider.dart';
import 'package:suprobhat_driving_app/features/student_management/screens/add_edit_student_screen.dart';
import 'package:suprobhat_driving_app/features/student_management/widgets/profile_detail_item.dart';
import 'package:suprobhat_driving_app/features/student_management/widgets/attendance_calendar.dart';
import 'package:suprobhat_driving_app/shared_widgets/custom_app_bar.dart';

class StudentProfileScreen extends StatelessWidget {
  final Student student;

  const StudentProfileScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context);
    final totalAttendanceDays = student.courseDuration;
    final attendedDays = studentProvider.getAttendanceCount(student.id);

    return Scaffold(
      appBar: CustomAppBar(
        title: student.name,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddEditStudentScreen(student: student),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Delete Student'),
                      content: Text(
                        'Are you sure you want to delete ${student.name}?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            studentProvider.deleteStudent(student.id);
                            Navigator.of(context).pop(); // Close dialog
                            Navigator.of(
                              context,
                            ).pop(); // Pop back to student list
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kMediumPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              backgroundImage:
                  student.photoPath != null
                      ? FileImage(File(student.photoPath!))
                      : null,
              child:
                  student.photoPath == null
                      ? Icon(
                        Icons.person,
                        size: 80,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      )
                      : null,
            ),
            const SizedBox(height: kLargePadding),
            ProfileDetailItem(
              icon: Icons.phone,
              label: 'Phone',
              value: student.phone,
            ),
            ProfileDetailItem(
              icon: Icons.location_on,
              label: 'Address',
              value: student.address,
            ),
            ProfileDetailItem(
              icon: Icons.school,
              label: 'Course Type',
              value: student.courseType,
            ),
            ProfileDetailItem(
              icon: Icons.timelapse,
              label: 'Course Duration',
              value: '${student.courseDuration} days',
            ),
            ProfileDetailItem(
              icon: Icons.calendar_today,
              label: 'Start Date',
              value: DateFormat('dd MMM yyyy').format(student.startDate),
            ),
            ProfileDetailItem(
              icon: Icons.calendar_month,
              label: 'End Date',
              value: DateFormat('dd MMM yyyy').format(student.endDate),
            ),
            ProfileDetailItem(
              icon: Icons.currency_rupee,
              label: 'Course Amount',
              value: '₹ ${student.amount.toStringAsFixed(2)}',
            ),
            const SizedBox(height: kLargePadding),
            Text('Attendance Progress', style: kSubHeadingTextStyle),
            const SizedBox(height: kSmallPadding),
            LinearProgressIndicator(
              value:
                  totalAttendanceDays > 0
                      ? attendedDays / totalAttendanceDays
                      : 0,
              minHeight: 10,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: kSmallPadding),
            Text(
              'Attended: $attendedDays / $totalAttendanceDays days',
              style: kBodyTextStyle,
            ),
            const SizedBox(height: kLargePadding),
            Text('Attendance Calendar', style: kSubHeadingTextStyle),
            const SizedBox(height: kSmallPadding),
            AttendanceCalendar(
              studentId: student.id,
              startDate: student.startDate,
              endDate: student.endDate,
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
