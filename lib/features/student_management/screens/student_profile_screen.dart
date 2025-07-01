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

class StudentProfileScreen extends StatefulWidget {
  final Student student;

  const StudentProfileScreen({super.key, required this.student});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  bool _showNidInfo = false;

  void _toggleNidInfo() {
    setState(() {
      _showNidInfo = !_showNidInfo;
    });
  }

  Widget _buildNidSection() {
    if (!_showNidInfo) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: kMediumPadding),
        child: Center(
          child: ElevatedButton.icon(
            onPressed: _toggleNidInfo,
            icon: const Icon(Icons.visibility),
            label: const Text('View NID Information'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: kLargePadding,
                vertical: kMediumPadding,
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('NID Information', style: kSubHeadingTextStyle),
            IconButton(
              icon: const Icon(Icons.visibility_off),
              onPressed: _toggleNidInfo,
              tooltip: 'Hide NID Information',
            ),
          ],
        ),
        const SizedBox(height: kMediumPadding),
        if (widget.student.nidNumber != null)
          ProfileDetailItem(
            icon: Icons.credit_card,
            label: 'NID Number',
            value: widget.student.nidNumber!,
          ),
        if (widget.student.nidFrontPath != null || widget.student.nidBackPath != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kMediumPadding),
            child: Row(
              children: [
                if (widget.student.nidFrontPath != null)
                  Expanded(
                    child: Column(
                      children: [
                        const Text('NID Front'),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                child: Image.file(
                                  File(widget.student.nidFrontPath!),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: FileImage(File(widget.student.nidFrontPath!)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (widget.student.nidFrontPath != null && widget.student.nidBackPath != null)
                  const SizedBox(width: kMediumPadding),
                if (widget.student.nidBackPath != null)
                  Expanded(
                    child: Column(
                      children: [
                        const Text('NID Back'),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                child: Image.file(
                                  File(widget.student.nidBackPath!),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: FileImage(File(widget.student.nidBackPath!)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context);
    final totalAttendanceDays = widget.student.courseDuration;
    final attendedDays = studentProvider.getAttendanceCount(widget.student.id);

    return Scaffold(
      appBar: CustomAppBar(
        title: widget.student.name,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddEditStudentScreen(student: widget.student),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Student'),
                  content: Text(
                    'Are you sure you want to delete ${widget.student.name}?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        studentProvider.deleteStudent(widget.student.id);
                        Navigator.of(context).pop(); // Close dialog
                        Navigator.of(context).pop(); // Pop back to student list
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
                  widget.student.photoPath != null
                      ? FileImage(File(widget.student.photoPath!))
                      : null,
              child:
                  widget.student.photoPath == null
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
              value: widget.student.phone,
            ),
            ProfileDetailItem(
              icon: Icons.location_on,
              label: 'Address',
              value: widget.student.address,
            ),
            ProfileDetailItem(
              icon: Icons.school,
              label: 'Course Type',
              value: widget.student.courseType,
            ),
            ProfileDetailItem(
              icon: Icons.timelapse,
              label: 'Course Duration',
              value: '${widget.student.courseDuration} days',
            ),
            ProfileDetailItem(
              icon: Icons.calendar_today,
              label: 'Start Date',
              value: DateFormat('dd MMM yyyy').format(widget.student.startDate),
            ),
            ProfileDetailItem(
              icon: Icons.calendar_month,
              label: 'End Date',
              value: DateFormat('dd MMM yyyy').format(widget.student.endDate),
            ),
            ProfileDetailItem(
              icon: Icons.currency_rupee,
              label: 'Course Amount',
              value: '₹ ${widget.student.amount.toStringAsFixed(2)}',
            ),
            const SizedBox(height: kLargePadding),
            
            // NID Section with toggle
            _buildNidSection(),
            
            const SizedBox(height: kLargePadding),
            Text('Attendance Progress', style: kSubHeadingTextStyle),
            const SizedBox(height: kSmallPadding),
            LinearProgressIndicator(
              value: totalAttendanceDays > 0 ? attendedDays / totalAttendanceDays : 0,
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
              studentId: widget.student.id,
              startDate: widget.student.startDate,
              endDate: widget.student.endDate,
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
