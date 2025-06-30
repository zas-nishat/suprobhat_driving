import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suprobhat_driving_app/app/config/constants.dart';
import 'package:suprobhat_driving_app/app/data/providers/student_provider.dart';
import 'package:suprobhat_driving_app/features/student_management/screens/add_edit_student_screen.dart';
import 'package:suprobhat_driving_app/features/student_management/widgets/student_list_tile.dart';
import 'package:suprobhat_driving_app/shared_widgets/custom_app_bar.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Student List',
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddEditStudentScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(kMediumPadding),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search by Name or Phone',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),
          ),
          Expanded(
            child: Consumer<StudentProvider>(
              builder: (context, studentProvider, child) {
                final filteredStudents = studentProvider.searchStudents(_searchQuery);
                if (filteredStudents.isEmpty) {
                  return const Center(
                    child: Text('No students found.'),
                  );
                }
                return ListView.builder(
                  itemCount: filteredStudents.length,
                  itemBuilder: (context, index) {
                    final student = filteredStudents[index];
                    return StudentListTile(student: student);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
