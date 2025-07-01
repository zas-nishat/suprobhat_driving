import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:suprobhat_driving_app/app/config/constants.dart';
import 'package:suprobhat_driving_app/app/data/models/student_model.dart';
import 'package:suprobhat_driving_app/features/student_management/screens/student_profile_screen.dart';

class StudentListTile extends StatelessWidget {
  final Student student;

  const StudentListTile({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: kMediumPadding, vertical: kSmallPadding / 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kSmallBorderRadius),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          backgroundImage: student.photoPath != null ? FileImage(File(student.photoPath!)) : null,
          child: student.photoPath == null
              ? Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  size: 30,
                )
              : null,
        ),
        title: Text(
          student.name,
          style: kBodyTextStyle.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Course: ${student.courseType}'),
            Text(
              'Duration: ${DateFormat('dd MMM yyyy').format(student.startDate)} - ${DateFormat('dd MMM yyyy').format(student.endDate)}',
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => StudentProfileScreen(student: student),
            ),
          );
        },
      ),
    );
  }
}
