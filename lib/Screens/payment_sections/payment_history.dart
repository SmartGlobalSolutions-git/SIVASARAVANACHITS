import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'pending_history.dart';
import 'approval_history.dart';

class PaymentHistory extends StatefulWidget {
  const PaymentHistory({Key? key}) : super(key: key);

  @override
  State<PaymentHistory> createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  bool isMyChitsOverview = false;

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
          'Payment History',
          style: TextStyle(color: Colors.black, fontSize: 18.sp, fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
        children: [
          // Tabs
          Container(
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() => isMyChitsOverview = true);
                      Navigator.pop(context); // Go back to My Chits Overview
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      decoration: BoxDecoration(
                        color: isMyChitsOverview ? const Color(0xFFE8F6ED) : Colors.white,
                        border: Border(
                          bottom: BorderSide(
                            color: isMyChitsOverview ? const Color(0xFF0C8A4B) : Colors.transparent,
                            width: 2.h,
                          ),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'My Chit Overview',
                        style: TextStyle(
                          color: isMyChitsOverview ? const Color(0xFF0C8A4B) : Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isMyChitsOverview = false),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      decoration: BoxDecoration(
                        color: !isMyChitsOverview ? const Color(0xFFE8F6ED) : Colors.white,
                        border: Border(
                          bottom: BorderSide(
                            color: !isMyChitsOverview ? const Color(0xFF0C8A4B) : Colors.transparent,
                            width: 2.h,
                          ),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Payment History',
                        style: TextStyle(
                          color: !isMyChitsOverview ? const Color(0xFF0C8A4B) : Colors.grey,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15.h),

          // List
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
              children: [
                _buildHistoryCard(
                  chitId: 'Chit / 1123',
                  groupName: 'Group Name / L-10',
                  date: '24 Aug 2026, 11:45 AM',
                  status: 'Pending',
                  amount: '₹4,12,500',
                  isPending: true,
                ),
                SizedBox(height: 10.h),
                _buildHistoryCard(
                  chitId: 'Chit / 1123',
                  groupName: 'Group Name / L-10',
                  date: '24 Jul 2026, 10:45 AM',
                  status: 'Pending',
                  amount: '₹4,12,500',
                  isPending: true,
                ),
                SizedBox(height: 15.h),
                Center(
                  child: Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey.shade300)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Text('July 2026', style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
                      ),
                      Expanded(child: Divider(color: Colors.grey.shade300)),
                    ],
                  ),
                ),
                SizedBox(height: 15.h),
                _buildHistoryCard(
                  chitId: 'Chit / 1123',
                  groupName: 'Group Name / L-10',
                  date: '24 Jun 2026, 9:45 AM',
                  status: 'Approved',
                  amount: '₹4,12,500',
                  isPending: false,
                ),
                SizedBox(height: 10.h),
                _buildHistoryCard(
                  chitId: 'Chit / 1123',
                  groupName: 'Group Name / L-10',
                  date: '24 May 2026, 10:45 AM',
                  status: 'Approved',
                  amount: '₹4,12,500',
                  isPending: false,
                ),
                SizedBox(height: 10.h),
                _buildHistoryCard(
                  chitId: 'Chit / 1123',
                  groupName: 'Group Name / L-10',
                  date: '24 Aug 2026, 11:45 AM',
                  status: 'Approved',
                  amount: '₹4,12,500',
                  isPending: false,
                ),
                SizedBox(height: 10.h),
                _buildHistoryCard(
                  chitId: 'Chit / 1123',
                  groupName: 'Group Name / L-10',
                  date: '24 Aug 2026, 11:45 AM',
                  status: 'Approved',
                  amount: '₹4,12,500',
                  isPending: false,
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard({
    required String chitId,
    required String groupName,
    required String date,
    required String status,
    required String amount,
    required bool isPending,
  }) {
    return GestureDetector(
      onTap: () {
        if (isPending) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const PendingHistoryScreen()));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ApprovalHistoryScreen()));
        }
      },
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: Colors.grey.shade200),
        ),
      child: Row(
        children: [
          Container(
            width: 45.w,
            height: 45.w,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F6ED),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(Icons.account_balance_wallet, color: const Color(0xFF0C8A4B), size: 20.sp),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(chitId, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.black87)),
                SizedBox(height: 2.h),
                Text(groupName, style: TextStyle(fontSize: 11.sp, color: Colors.grey)),
                SizedBox(height: 2.h),
                Text(date, style: TextStyle(fontSize: 11.sp, color: Colors.grey)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isPending ? Colors.orange.shade50 : Colors.white,
                  border: Border.all(color: isPending ? Colors.orange.shade200 : const Color(0xFF1B3C73)),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Row(
                  children: [
                    if (isPending)
                      Container(
                        margin: EdgeInsets.only(right: 4.w),
                        width: 6.w,
                        height: 6.w,
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                      )
                    else
                      Padding(
                        padding: EdgeInsets.only(right: 4.w),
                        child: Icon(Icons.check, color: const Color(0xFF1B3C73), size: 12.sp),
                      ),
                    Text(
                      status,
                      style: TextStyle(
                        color: isPending ? Colors.orange : const Color(0xFF1B3C73),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Text(amount, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: const Color(0xFF0C8A4B))),
            ],
          ),
        ],
      ),
    ));
  }
}
