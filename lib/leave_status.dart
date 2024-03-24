import 'package:attendanceapp/services/helperFunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import FirebaseAuth

class LeaveHistoryPage extends StatefulWidget {
  const LeaveHistoryPage({Key? key}) : super(key: key);

  @override
  _LeaveHistoryPageState createState() => _LeaveHistoryPageState();
}

class _LeaveHistoryPageState extends State<LeaveHistoryPage> {
  List<Map<String, dynamic>> _leaveRequests = []; // Empty list to store leave requests

  @override
  void initState() {
    super.initState();
    _fetchLeaveRequests(); // Fetch leave requests on page load
  }

  Future<void> _fetchLeaveRequests() async {
    final db = FirebaseFirestore.instance;
    final String employeeUid = await HelperFunctions.getUserUidFromSharedPreference(); // Assuming User.id stores the employee ID

    // Query to get leave requests from the employee's document
    final querySnapshot = await db.collection('employees').doc(employeeUid).collection('LeaveRequests').get();

    setState(() {
      _leaveRequests = querySnapshot.docs.map((doc) => {
        ...doc.data(), // Get all fields
        'startDate': (doc.data()['startDate'] as Timestamp).toDate(), // Convert Timestamp to DateTime
        'endDate': (doc.data()['endDate'] as Timestamp).toDate(), // Convert Timestamp to DateTime
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave History', style: TextStyle(
          fontFamily: "NexaBold",
          fontSize: 20,
          color: Colors.black54,
        ),),
      ),
      body: _leaveRequests.isEmpty
          ? const Center(child: Text('No leave requests found'))
          : ListView.builder(
        itemCount: _leaveRequests.length,
        itemBuilder: (context, index) {
          final leaveRequest = _leaveRequests[index];
          return ListTile(
            title: Text('${leaveRequest['leaveType']}'), // Display leave type
            subtitle: Text(
              '${DateFormat('yMMMMd').format(leaveRequest['startDate'])} - ${DateFormat('yMMMMd').format(leaveRequest['endDate'])}',
            ), // Display start and end dates (now as DateTime)
            trailing: Text(leaveRequest['status']), // Display status
          );
        },
      ),
    );
  }
}
