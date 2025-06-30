import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suprobhat_driving_app/app/config/constants.dart';
import 'package:suprobhat_driving_app/app/data/models/student_model.dart';
import 'package:suprobhat_driving_app/app/data/providers/student_provider.dart';
import 'package:suprobhat_driving_app/shared_widgets/custom_app_bar.dart';
import 'package:uuid/uuid.dart'; // For generating unique IDs

class AddEditStudentScreen extends StatefulWidget {
  final Student? student;

  const AddEditStudentScreen({super.key, this.student});

  @override
  State<AddEditStudentScreen> createState() => _AddEditStudentScreenState();
}

class _AddEditStudentScreenState extends State<AddEditStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? _selectedCourseType;
  int? _selectedCourseDuration;
  DateTime _selectedStartDate = DateTime.now();
  String? _photoPath; // TODO: Implement image picking

  @override
  void initState() {
    super.initState();
    if (widget.student != null) {
      _nameController.text = widget.student!.name;
      _phoneController.text = widget.student!.phone;
      _addressController.text = widget.student!.address;
      _selectedCourseType = widget.student!.courseType;
      _selectedCourseDuration = widget.student!.courseDuration;
      _selectedStartDate = widget.student!.startDate;
      _photoPath = widget.student!.photoPath;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedStartDate) {
      setState(() {
        _selectedStartDate = picked;
      });
    }
  }

  void _saveStudent() {
    if (_formKey.currentState!.validate()) {
      final studentProvider = Provider.of<StudentProvider>(context, listen: false);

      final newStudent = Student(
        id: widget.student?.id ?? const Uuid().v4(),
        name: _nameController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        photoPath: _photoPath,
        courseType: _selectedCourseType!,
        courseDuration: _selectedCourseDuration!,
        startDate: _selectedStartDate,
      );

      if (widget.student == null) {
        studentProvider.addStudent(newStudent);
      } else {
        studentProvider.updateStudent(newStudent);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.student == null ? 'Add Student' : 'Edit Student',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kMediumPadding),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Photo Picker (Placeholder)
              CircleAvatar(
                radius: 60,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: _photoPath == null
                    ? Icon(Icons.person, size: 60, color: Theme.of(context).colorScheme.onPrimaryContainer)
                    : null, // TODO: Display image from _photoPath
              ),
              TextButton(
                onPressed: () {
                  // TODO: Implement image picking logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Image picking not yet implemented.')),
                  );
                },
                child: const Text('Add Photo'),
              ),
              const SizedBox(height: kMediumPadding),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: kMediumPadding),

              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: kMediumPadding),

              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: kMediumPadding),

              DropdownButtonFormField<String>(
                value: _selectedCourseType,
                decoration: const InputDecoration(
                  labelText: 'Course Type',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Auto', child: Text('Auto')),
                  DropdownMenuItem(value: 'Manual', child: Text('Manual')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedCourseType = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a course type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: kMediumPadding),

              DropdownButtonFormField<int>(
                value: _selectedCourseDuration,
                decoration: const InputDecoration(
                  labelText: 'Course Duration (days)',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 15, child: Text('15 Days')),
                  DropdownMenuItem(value: 30, child: Text('30 Days')),
                  DropdownMenuItem(value: 45, child: Text('45 Days')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedCourseDuration = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a course duration';
                  }
                  return null;
                },
              ),
              const SizedBox(height: kMediumPadding),

              ListTile(
                title: Text('Start Date: ${MaterialLocalizations.of(context).formatShortDate(_selectedStartDate)}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDate,
                shape: RoundedRectangleBorder(side: BorderSide(color: Theme.of(context).colorScheme.outline), borderRadius: BorderRadius.circular(kSmallBorderRadius)),
              ),
              const SizedBox(height: kLargePadding),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveStudent,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: kMediumPadding),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(kSmallBorderRadius),
                    ),
                  ),
                  child: Text(
                    widget.student == null ? 'Save Student' : 'Update Student',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
