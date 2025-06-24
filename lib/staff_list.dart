import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_staff.dart';

class StaffListPage extends StatelessWidget {
  const StaffListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Staff List')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('staffs').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final staffs = snapshot.data!.docs;

          if (staffs.isEmpty) {
            return const Center(child: Text('No staff found.'));
          }

          return ListView.builder(
            itemCount: staffs.length,
            itemBuilder: (context, index) {
              final data = staffs[index].data() as Map<String, dynamic>;

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  title: Text(
                    '${data['first_name']} ${data['last_name']}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text(
                    'ID: ${data['id']} | Age: ${data['age']}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditStaffPage(
                                docId: staffs[index].id,
                                staffData: data,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Staff'),
                              content: const Text('Are you sure you want to delete this staff?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(), // Cancel
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.of(context).pop(); // Close dialog
                                    await FirebaseFirestore.instance
                                        .collection('staffs')
                                        .doc(staffs[index].id)
                                        .delete();

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Staff deleted')),
                                    );
                                  },
                                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

      // Floating Action Button to Add New Staff
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/add');
        },
        child: const Icon(Icons.person_add), // Changed from Icons.add
      ),
    );
  }
}
