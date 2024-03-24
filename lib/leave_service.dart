import 'package:attendanceapp/services/helperFunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaveService {
  static Future<void> submitLeaveRequest({
    required DateTime startDate,
    required DateTime endDate,
    required String leaveType,
    required String reason,
  }) async {
    final db = FirebaseFirestore.instance;
    final String employeeUid = await HelperFunctions.getUserUidFromSharedPreference(); // Assuming User.id stores the employee ID

    // Create a new document for the leave request
    final leaveRequest = {
      'startDate': startDate,
      'endDate': endDate,
      'leaveType': leaveType,
      'reason': reason,
      'status': 'Pending', // Add a status field (e.g., Pending, Approved, Rejected)
    };

    try {
      await db.collection('employees').doc(employeeUid).collection('LeaveRequests').add(leaveRequest);
      print('Leave request submitted successfully!');
    } catch (e) {
      print('Error submitting leave request: $e');
    }
  }
}
