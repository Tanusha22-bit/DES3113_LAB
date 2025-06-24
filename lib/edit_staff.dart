import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditStaffPage extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> staffData;

  const EditStaffPage({
    super.key,
    required this.docId,
    required this.staffData,
  });

  @override
  State<EditStaffPage> createState() => _EditStaffPageState();
}

class _EditStaffPageState extends State<EditStaffPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _idController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _ageController;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(text: widget.staffData['id']);
    _firstNameController = TextEditingController(text: widget.staffData['first_name']);
    _lastNameController = TextEditingController(text: widget.staffData['last_name']);
    _ageController = TextEditingController(text: widget.staffData['age'].toString());
  }

  Future<void> _updateStaff() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance
          .collection('staffs')
          .doc(widget.docId)
          .update({
        'id': _idController.text,
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'age': int.parse(_ageController.text),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Staff updated')),
      );

      Navigator.pushReplacementNamed(context, '/list');
    }
  }

  Widget _buildInput(String label, TextEditingController controller,
      {TextInputType type = TextInputType.text}) {
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
        validator: (v) => v == null || v.isEmpty ? 'Required field' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Staff')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildInput('Staff ID', _idController),
              _buildInput('First Name', _firstNameController),
              _buildInput('Last Name', _lastNameController),
              _buildInput('Age', _ageController, type: TextInputType.number),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Update'),
                  onPressed: _updateStaff,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/add');
        },
        child: const Icon(Icons.person_add), // Changed from Icons.add
      ),
    );
  }
}
