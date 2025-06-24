import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'staff_list.dart'; // Ensure this import exists

class AddStaffPage extends StatefulWidget {
  const AddStaffPage({super.key});

  @override
  State<AddStaffPage> createState() => _AddStaffPageState();
}

class _AddStaffPageState extends State<AddStaffPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  void _submitStaff() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('staffs').add({
        'id': _idController.text,
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'age': int.parse(_ageController.text),
      });

      _idController.clear();
      _firstNameController.clear();
      _lastNameController.clear();
      _ageController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Staff added successfully')),
      );
    }
  }

  Widget _buildInput({
    required String label,
    required TextEditingController controller,
    TextInputType type = TextInputType.text,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Staff')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildInput(
                label: 'Staff ID',
                controller: _idController,
                validator: (v) => v == null || v.isEmpty ? 'Enter staff ID' : null,
              ),
              _buildInput(
                label: 'First Name',
                controller: _firstNameController,
                validator: (v) => v == null || v.isEmpty ? 'Enter first name' : null,
              ),
              _buildInput(
                label: 'Last Name',
                controller: _lastNameController,
                validator: (v) => v == null || v.isEmpty ? 'Enter last name' : null,
              ),
              _buildInput(
                label: 'Age',
                controller: _ageController,
                type: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Enter age';
                  if (int.tryParse(v) == null) return 'Must be a number';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add Staff'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _submitStaff,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.list),
                  label: const Text('View Staff List'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const StaffListPage()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
