import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suprobhat_driving_app/app/config/constants.dart';
import 'package:suprobhat_driving_app/app/data/providers/student_provider.dart';
import 'package:suprobhat_driving_app/features/dashboard/widgets/summary_card.dart';
import 'package:suprobhat_driving_app/features/dashboard/widgets/reminder_list_item.dart';
import 'package:suprobhat_driving_app/shared_widgets/custom_app_bar.dart';
import 'package:suprobhat_driving_app/features/student_management/screens/add_edit_student_screen.dart';
import 'package:suprobhat_driving_app/features/student_management/screens/student_list_screen.dart';
import 'package:suprobhat_driving_app/features/attendance/screens/attendance_tracker_screen.dart';
import 'package:suprobhat_driving_app/features/training_videos/screens/video_grid_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    _DashboardContent(),
    const StudentListScreen(),
    const AttendanceTrackerScreen(),
    ChannelPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Students'),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library),
            label: 'Youtube',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Dashboard'),
      body: Padding(
        padding: const EdgeInsets.all(kMediumPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<StudentProvider>(
              builder: (context, studentProvider, child) {
                final totalStudents = studentProvider.students.length;
                final today = DateTime.now();
                final todayAttendance =
                    studentProvider
                        .getAttendanceForDate(today)
                        .where((record) => record.isPresent)
                        .length;

                return Row(
                  children: [
                    Expanded(
                      child: SummaryCard(
                        title: 'Total Students',
                        count: totalStudents,
                        icon: Icons.people,
                      ),
                    ),
                    const SizedBox(width: kMediumPadding),
                    Expanded(
                      child: SummaryCard(
                        title: 'Present Today',
                        count: todayAttendance,
                        icon: Icons.check_circle,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: kLargePadding),
            Text('Upcoming Course End Reminders', style: kSubHeadingTextStyle),
            const SizedBox(height: kSmallPadding),
            Expanded(
              child: Consumer<StudentProvider>(
                builder: (context, studentProvider, child) {
                  final upcomingStudents =
                      studentProvider.getUpcomingCourseEndStudents();
                  if (upcomingStudents.isEmpty) {
                    return const Center(
                      child: Text('No upcoming course endings.'),
                    );
                  }
                  return ListView.builder(
                    itemCount: upcomingStudents.length,
                    itemBuilder: (context, index) {
                      final student = upcomingStudents[index];
                      return ReminderListItem(
                        studentName: student.name,
                        endDate: student.endDate,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddEditStudentScreen(),
            ),
          );
        },
        icon: const Icon(Icons.person_add),
        label: const Text('Add Student'),
      ),
    );
  }
}
