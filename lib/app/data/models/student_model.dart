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
  String? nidNumber;
  String? nidFrontPath;
  String? nidBackPath;

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
    this.nidNumber,
    this.nidFrontPath,
    this.nidBackPath,
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
      nidNumber: json['nidNumber'],
      nidFrontPath: json['nidFrontPath'],
      nidBackPath: json['nidBackPath'],
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
      'nidNumber': nidNumber,
      'nidFrontPath': nidFrontPath,
      'nidBackPath': nidBackPath,
    };
  }
}
