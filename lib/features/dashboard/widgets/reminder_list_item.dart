import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:suprobhat_driving_app/app/config/constants.dart';

class ReminderListItem extends StatelessWidget {
  final String studentName;
  final DateTime endDate;

  const ReminderListItem({
    super.key,
    required this.studentName,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: kSmallPadding / 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kSmallBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(kMediumPadding),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: kMediumPadding),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    studentName,
                    style: kBodyTextStyle.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: kSmallPadding / 4),
                  Text(
                    'Course ends: ${DateFormat('dd MMM yyyy').format(endDate)}',
                    style: kCaptionTextStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
