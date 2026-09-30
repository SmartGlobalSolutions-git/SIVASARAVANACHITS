import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:siva_saravana/widgets/chatbox_widget.dart';
import 'chit_statement.dart';

class StatementScreen extends StatefulWidget {
  const StatementScreen({Key? key}) : super(key: key);

  @override
  State<StatementScreen> createState() => _StatementScreenState();
}

class _StatementScreenState extends State<StatementScreen> {
  DateTimeRange? _selectedDateRange;

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTime? startDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateRange?.start ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      helpText: 'Select Start Date',
    );

    if (startDate != null) {
      if (!context.mounted) return;
      final DateTime? endDate = await showDatePicker(
        context: context,
        initialDate: _selectedDateRange?.end ?? startDate,
        firstDate: startDate,
        lastDate: DateTime(2101),
        helpText: 'Select End Date',
      );

      if (endDate != null) {
        setState(() {
          _selectedDateRange = DateTimeRange(start: startDate, end: endDate);
        });
      }
    }
  }

  String get _formattedDateRange {
    if (_selectedDateRange == null) {
      return 'Select Date Range';
    }
    final start = _selectedDateRange!.start;
    final end = _selectedDateRange!.end;
    final startStr = "${start.day.toString().padLeft(2, '0')}/${start.month.toString().padLeft(2, '0')}/${start.year}";
    final endStr = "${end.day.toString().padLeft(2, '0')}/${end.month.toString().padLeft(2, '0')}/${end.year}";
    return '$startStr - $endStr';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text(
          'Statement',
          style: TextStyle(color: Colors.black, fontSize: 18.sp, fontWeight: FontWeight.w500),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Chit ID',
                      style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                    ),
                    SizedBox(width: 15.w),
                    Text(':', style: TextStyle(fontSize: 14.sp, color: Colors.black87)),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Container(
                        height: 45.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Enter Chit ID :',
                            hintStyle: TextStyle(fontSize: 13.sp, color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
                            suffixIcon: const Icon(Icons.search, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Date Range',
                      style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                    ),
                    Row(
                      children: [
                        Icon(Icons.refresh, color: Colors.grey, size: 16.sp),
                        SizedBox(width: 4.w),
                        Text(
                          'Refresh',
                          style: TextStyle(fontSize: 13.sp, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                GestureDetector(
                  onTap: () => _selectDateRange(context),
                  child: Container(
                    height: 45.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25.r),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: Text(
                            _formattedDateRange,
                            style: TextStyle(fontSize: 13.sp, color: Colors.black87),
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: Icon(Icons.calendar_today_outlined, color: Colors.grey, size: 20.sp),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
                Center(
                  child: SizedBox(
                    width: 200.w,
                    height: 45.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChitStatementScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0C8A4B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Bot Icon
          const ChatboxWidget(),
        ],
      ),
    );
  }
}
