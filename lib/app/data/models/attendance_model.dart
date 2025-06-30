class Attendance {
  String studentId;
  DateTime date;
  bool isPresent;

  Attendance({
    required this.studentId,
    required this.date,
    required this.isPresent,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      studentId: json['studentId'],
      date: DateTime.parse(json['date']),
      isPresent: json['isPresent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'date': date.toIso8601String(),
      'isPresent': isPresent,
    };
  }
}
