import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
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
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _nidNumberController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  String? _selectedCourseType;
  int? _selectedCourseDuration;
  DateTime _selectedStartDate = DateTime.now();
  String? _photoPath;
  String? _nidFrontPath;
  String? _nidBackPath;

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
      _amountController.text = widget.student!.amount.toString();
      _nidNumberController.text = widget.student!.nidNumber ?? '';
      _nidFrontPath = widget.student!.nidFrontPath;
      _nidBackPath = widget.student!.nidBackPath;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _amountController.dispose();
    _nidNumberController.dispose();
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

  Future<void> _pickImage(ImageSource source, String type) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          switch (type) {
            case 'profile':
              _photoPath = pickedFile.path;
              break;
            case 'nidFront':
              _nidFrontPath = pickedFile.path;
              break;
            case 'nidBack':
              _nidBackPath = pickedFile.path;
              break;
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to pick image. Please try again.'),
        ),
      );
    }
  }

  void _showImagePickerOptions(String type) {
    String title;
    switch (type) {
      case 'profile':
        title = 'Profile Photo';
        break;
      case 'nidFront':
        title = 'NID Front Photo';
        break;
      case 'nidBack':
        title = 'NID Back Photo';
        break;
      default:
        title = 'Photo';
    }

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery, type);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera, type);
                },
              ),
              if ((type == 'profile' && _photoPath != null) ||
                  (type == 'nidFront' && _nidFrontPath != null) ||
                  (type == 'nidBack' && _nidBackPath != null))
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Remove Photo'),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      switch (type) {
                        case 'profile':
                          _photoPath = null;
                          break;
                        case 'nidFront':
                          _nidFrontPath = null;
                          break;
                        case 'nidBack':
                          _nidBackPath = null;
                          break;
                      }
                    });
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _saveStudent() {
    if (_formKey.currentState!.validate()) {
      final studentProvider = Provider.of<StudentProvider>(
        context,
        listen: false,
      );

      final newStudent = Student(
        id: widget.student?.id ?? const Uuid().v4(),
        name: _nameController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        photoPath: _photoPath,
        courseType: _selectedCourseType!,
        courseDuration: _selectedCourseDuration!,
        startDate: _selectedStartDate,
        amount: double.parse(_amountController.text),
        nidNumber:
            _nidNumberController.text.isEmpty
                ? null
                : _nidNumberController.text,
        nidFrontPath: _nidFrontPath,
        nidBackPath: _nidBackPath,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Photo Section
              Center(
                child: GestureDetector(
                  onTap: () => _showImagePickerOptions('profile'),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        backgroundImage:
                            _photoPath != null
                                ? FileImage(File(_photoPath!))
                                : null,
                        child:
                            _photoPath == null
                                ? Icon(
                                  Icons.person,
                                  size: 60,
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.onPrimaryContainer,
                                )
                                : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            size: 20,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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

              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Course Amount',
                  border: OutlineInputBorder(),
                  prefixText: '₹ ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the course amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid amount';
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
                  DropdownMenuItem(
                    value: 'Both',
                    child: Text('Both (Auto + Manual)'),
                  ),
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
                title: Text(
                  'Start Date: ${MaterialLocalizations.of(context).formatShortDate(_selectedStartDate)}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDate,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  borderRadius: BorderRadius.circular(kSmallBorderRadius),
                ),
              ),
              const SizedBox(height: kLargePadding),

              // NID Section
              const Text(
                'NID Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: kMediumPadding),

              TextFormField(
                controller: _nidNumberController,
                decoration: const InputDecoration(
                  labelText: 'NID Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: kMediumPadding),

              // NID Photos
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const Text('NID Front'),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => _showImagePickerOptions('nidFront'),
                          child: Container(
                            height: 120,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child:
                                _nidFrontPath != null
                                    ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        File(_nidFrontPath!),
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                    : Icon(
                                      Icons.add_photo_alternate,
                                      size: 40,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: kMediumPadding),
                  Expanded(
                    child: Column(
                      children: [
                        const Text('NID Back'),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => _showImagePickerOptions('nidBack'),
                          child: Container(
                            height: 120,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child:
                                _nidBackPath != null
                                    ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        File(_nidBackPath!),
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                    : Icon(
                                      Icons.add_photo_alternate,
                                      size: 40,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: kLargePadding),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveStudent,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: kMediumPadding,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(kSmallBorderRadius),
                    ),
                  ),
                  child: Text(
                    widget.student == null ? 'Add Student' : 'Update Student',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
