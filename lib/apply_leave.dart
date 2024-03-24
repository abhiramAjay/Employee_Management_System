import 'package:attendanceapp/leave_service.dart'; // Create a service for leave requests
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'leave_status.dart';

class LeaveApplicationPage extends StatefulWidget {
  const LeaveApplicationPage({Key? key}) : super(key: key);

  @override
  _LeaveApplicationPageState createState() => _LeaveApplicationPageState();
}

class _LeaveApplicationPageState extends State<LeaveApplicationPage> {
  final _formKey = GlobalKey<FormState>(); // For form validation

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  // String _leaveType = "Select Leave Type"; // Initial leave type
  String _leaveType = "Select Leave Type"; // Initial value

  List<String> _leaveTypes = [
    "Select Leave Type",
    "Casual Leave",
    "Sick Leave",
    "Vacation Leave"
  ];


  final TextEditingController _reasonController = TextEditingController();

  String get formattedStartDate => DateFormat('yMMMMd').format(_startDate);
  String get formattedEndDate => DateFormat('yMMMMd').format(_endDate);

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
          _endDate = _startDate; // Set initial end date to start date
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }
  void _goToLeaveStatusPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => LeaveHistoryPage()));
  }
  void _submitLeaveApplication() async {
    if (_formKey.currentState!.validate()) {
      // Call your LeaveService to submit the leave request
      LeaveService.submitLeaveRequest(
        startDate: _startDate,
        endDate: _endDate,
        leaveType: _leaveType,
        reason: _reasonController.text,
      );

      // Show a success message or navigate back after submission
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Leave application submitted successfully!'),
      ));
      Navigator.pop(context); // Close the page
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave Application'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Leave Type Dropdown
              DropdownButtonFormField<String>(
                value: _leaveType,
                items: _leaveTypes.map((type) => DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                )).toList(),
                onChanged: (value) => setState(() => _leaveType = value!),
                validator: (value) => value == "Select Leave Type" ? "Please select a leave type" : null,
                decoration: const InputDecoration(
                  labelText: 'Leave Type',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),

              // Start Date Picker
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Start Date: $formattedStartDate'),
                  TextButton(
                    onPressed: () => _selectDate(context, true),
                    child: const Text('Select', style: TextStyle(fontFamily: 'Nexa', fontSize: 16)),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),

              // End Date Picker
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('End Date: $formattedEndDate'),
                  TextButton(
                    onPressed: () => _selectDate(context, false),
                    child: const Text('Select', style: TextStyle(fontFamily: 'Nexa', fontSize: 16)),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),

              // Reason for Leave Text Field
              TextFormField(
                controller: _reasonController,
                decoration: const InputDecoration(
                  labelText: 'Reason for Leave',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? "Please enter a reason for leave" : null,
                minLines: 3,
                maxLines: 5,
              ),
              // Button for submitting the application
              ElevatedButton(
                onPressed: () {
                  _submitLeaveApplication();
                  // Call _goToLeaveStatusPage only if submission is successful
                  if (_formKey.currentState!.validate()) {
                    _goToLeaveStatusPage();
                  }
                },
                child: const Text('Submit Leave Application', style: TextStyle(fontFamily: 'Nexa', fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
  }
