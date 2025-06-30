class Student {
  String id;
  String name;
  String phone;
  String address;
  String? photoPath;
  String courseType;
  int courseDuration;
  DateTime startDate;
  double amount;

  DateTime get endDate => startDate.add(Duration(days: courseDuration));

  Student({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    this.photoPath,
    required this.courseType,
    required this.courseDuration,
    required this.startDate,
    required this.amount,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
      photoPath: json['photoPath'],
      courseType: json['courseType'],
      courseDuration: json['courseDuration'],
      startDate: DateTime.parse(json['startDate']),
      amount: json['amount']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'photoPath': photoPath,
      'courseType': courseType,
      'courseDuration': courseDuration,
      'startDate': startDate.toIso8601String(),
      'amount': amount,
    };
  }
}
