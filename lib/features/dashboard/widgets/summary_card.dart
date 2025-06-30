import 'package:flutter/material.dart';
import 'package:suprobhat_driving_app/app/config/constants.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;

  const SummaryCard({
    super.key,
    required this.title,
    required this.count,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kMediumBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(kMediumPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 36, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: kSmallPadding),
            Text(
              title,
              style: kBodyTextStyle.copyWith(color: Colors.grey[700]),
            ),
            const SizedBox(height: kSmallPadding / 2),
            Text(
              count.toString(),
              style: kHeadingTextStyle.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
