import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:suprobhat_driving_app/app/data/providers/student_provider.dart';
import 'package:suprobhat_driving_app/app/config/constants.dart';

// Custom color constants for attendance
const attendancePresentColor = Color(0xFF008B8B); // Darker teal
const attendanceAbsentColor = Color(0xFFDC143C); // Crimson red

class AttendanceCalendar extends StatefulWidget {
  final String studentId;
  final DateTime? startDate;
  final DateTime? endDate;

  const AttendanceCalendar({
    super.key,
    required this.studentId,
    this.startDate,
    this.endDate,
  });

  @override
  State<AttendanceCalendar> createState() => _AttendanceCalendarState();
}

class _AttendanceCalendarState extends State<AttendanceCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.startDate ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context);
    final attendanceMap = studentProvider.getAttendanceMap(widget.studentId);
    final student = studentProvider.getStudentById(widget.studentId);

    if (student == null) return const SizedBox();

    return Column(
      children: [
        Card(
          margin: const EdgeInsets.symmetric(horizontal: kMediumPadding),
          child: TableCalendar(
            firstDay: widget.startDate ?? DateTime.utc(2023, 1, 1),
            lastDay: widget.endDate ?? DateTime.utc(2025, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            startingDayOfWeek: StartingDayOfWeek.monday,
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
              CalendarFormat.week: 'Week',
            },
            selectedDayPredicate:
                (day) => false, // Disable selected day highlight
            onDaySelected: (selectedDay, focusedDay) {
              // Only allow marking attendance between course start and end dates
              if (selectedDay.isBefore(student.startDate) ||
                  selectedDay.isAfter(student.endDate)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'You can only mark attendance during the course period.',
                    ),
                  ),
                );
                return;
              }

              // Check if already marked as present
              if (attendanceMap[selectedDay] == true) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Attendance is already marked for this day'),
                    backgroundColor: attendancePresentColor,
                    duration: Duration(seconds: 1),
                  ),
                );
                return;
              }

              setState(() {
                _focusedDay = focusedDay;
              });

              // Always mark as present when selecting a date
              studentProvider.markAttendance(
                widget.studentId,
                selectedDay,
                true,
              );

              // Show confirmation
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Attendance marked as present'),
                  duration: Duration(seconds: 1),
                  backgroundColor: attendancePresentColor,
                ),
              );
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarStyle: CalendarStyle(
              markersMaxCount: 1,
              todayDecoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1,
                ),
                shape: BoxShape.circle,
              ),
              todayTextStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, date, _) {
                final isPresent = attendanceMap[date] ?? false;
                final isInCourse =
                    !date.isBefore(student.startDate) &&
                    !date.isAfter(student.endDate);
                final hasAttendance = attendanceMap.containsKey(date);

                return Container(
                  margin: const EdgeInsets.all(4),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        hasAttendance
                            ? (isPresent
                                ? attendancePresentColor.withOpacity(0.8)
                                : attendanceAbsentColor.withOpacity(0.2))
                            : null,
                  ),
                  child: Text(
                    '${date.day}',
                    style: TextStyle(
                      color:
                          !isInCourse
                              ? Theme.of(context).disabledColor
                              : hasAttendance
                              ? (isPresent
                                  ? Colors.white
                                  : attendanceAbsentColor)
                              : null,
                      fontWeight: hasAttendance ? FontWeight.bold : null,
                    ),
                  ),
                );
              },
              todayBuilder: (context, date, _) {
                final isPresent = attendanceMap[date] ?? false;
                final isInCourse =
                    !date.isBefore(student.startDate) &&
                    !date.isAfter(student.endDate);
                final hasAttendance = attendanceMap.containsKey(date);

                return Container(
                  margin: const EdgeInsets.all(4),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        hasAttendance
                            ? (isPresent
                                ? attendancePresentColor.withOpacity(0.8)
                                : attendanceAbsentColor.withOpacity(0.2))
                            : null,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '${date.day}',
                    style: TextStyle(
                      color:
                          !isInCourse
                              ? Theme.of(context).disabledColor
                              : hasAttendance
                              ? (isPresent
                                  ? Colors.white
                                  : attendanceAbsentColor)
                              : null,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: kMediumPadding),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LegendItem(
              color: attendancePresentColor.withOpacity(0.8),
              textColor: Colors.white,
              label: 'Present',
            ),
            const SizedBox(width: kLargePadding),
            _LegendItem(
              color: attendanceAbsentColor.withOpacity(0.2),
              textColor: attendanceAbsentColor,
              label: 'Absent',
            ),
          ],
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final Color textColor;
  final String label;

  const _LegendItem({
    required this.color,
    required this.textColor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: Border.all(color: textColor),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
