import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:siva_saravana/Screens/Home_Sections/need_help_screen.dart';
import 'package:siva_saravana/Screens/Home_Sections/notification_screen.dart';
import 'package:siva_saravana/widgets/chatbox_widget.dart';
import 'package:siva_saravana/services/chit_scheme_api.dart';
import 'package:intl/intl.dart';
import '../../constants/app_colors.dart';
import 'my_chit_detail.dart';

class MyChitsScreen extends StatefulWidget {
  final VoidCallback? onBackToHome;
  const MyChitsScreen({super.key, this.onBackToHome});

  @override
  State<MyChitsScreen> createState() => _MyChitsScreenState();
}

class _MyChitsScreenState extends State<MyChitsScreen> {
  bool _isLoading = true;
  List<dynamic> _myChitsList = [];

  @override
  void initState() {
    super.initState();
    _fetchMyChits();
  }

  Future<void> _fetchMyChits() async {
    final chits = await ChitSchemeApiService.fetchMyChits();
    if (mounted) {
      setState(() {
        _myChitsList = chits ?? [];
        _isLoading = false;
      });
    }
  }

  String _formatAmount(dynamic amount) {
    if (amount == null) return '0';
    try {
      final formatter = NumberFormat('#,##,###');
      if (amount is int) return formatter.format(amount);
      if (amount is double) return formatter.format(amount);
      if (amount is String) return formatter.format(double.parse(amount));
    } catch (e) {
      return amount.toString();
    }
    return amount.toString();
  }

  String _formatDate(dynamic dateString) {
    if (dateString == null || dateString == '0' || dateString.toString().isEmpty) return '-';
    try {
      final DateTime parsed = DateTime.parse(dateString.toString());
      return DateFormat('dd MMM yyyy').format(parsed);
    } catch (e) {
      return dateString.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F3F5),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.w),
          onPressed: () {
            if (widget.onBackToHome != null) {
              widget.onBackToHome!();
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          'My Chits',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NeedHelpScreen()),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: const Color(0xFF9B9B9B), width: 0.5.w),
              ),
              child: Row(
                children: [
                  Image.asset('assets/scheme_images/need_help.png', width: 16.w, height: 16.h,),
                  SizedBox(width: 4.w),
                  Text(
                    'Need Help ?',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 10.w),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationScreen()),
              );
            },
            child: Image.asset(
              'assets/home_images/notification.png',
              width: 24.w,
              height: 24.h,
            ),
          ),
          SizedBox(width: 16.w),
        ],
      ),
      body: Stack(
        children: [
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _myChitsList.isEmpty
                  ? const Center(child: Text("No chits found."))
                  : ListView.builder(
                      padding: EdgeInsets.all(16.w),
                      itemCount: _myChitsList.length,
                      itemBuilder: (context, index) {
                        final chitItem = _myChitsList[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: _buildChitCard(context, chitItem),
                        );
                      },
                    ),
          const ChatboxWidget(),
        ],
      ),
    );
  }

  Widget _buildChitCard(BuildContext context, dynamic chitItem) {
    bool isPrized = chitItem['Chit Status']?.toString().toLowerCase() == 'prized';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000), // #00000040
            offset: Offset(0, 4),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
        border: Border.all(color: AppColors.primaryColor, width: 0.5.w),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon and Active status
              Container(
                width: 60.w,
                padding: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.people,
                      color: AppColors.primaryColor,
                      size: 28.w,
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(
                        chitItem['Status']?.toString().toUpperCase() ?? 'ACTIVE',
                        style: TextStyle(color: Colors.white, fontSize: 10.sp),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              // Name and Group Code
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chitItem['Chit Name']?.toString() ?? 'Unknown',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Text(
                          'CHIT ID ',
                          style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                        ),
                        Text(
                          chitItem['Chit_id']?.toString() ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Status Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isPrized
                      ? const Color(0xFFE8EAF6)
                      : const Color(0xFFFFF8E1),
                  border: Border.all(
                    color: isPrized
                        ? const Color(0xFF3F51B5)
                        : const Color(0xFFFFC107),
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        color: isPrized
                            ? const Color(0xFF3F51B5)
                            : const Color(0xFFFFC107),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      isPrized ? 'Prized' : chitItem['Chit Status']?.toString() ?? 'Non-prized',
                      style: TextStyle(
                        color: isPrized
                            ? const Color(0xFF3F51B5)
                            : const Color(0xFFFF8F00),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chit Value',
                    style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '₹ ${_formatAmount(chitItem['Chit Value'])}',
                    style: TextStyle(
                      color: const Color(0xFF1565C0),
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Start Date',
                    style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    _formatDate(chitItem['Sdate']),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'End Date',
                    style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    _formatDate(chitItem['Ag_date']),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyChitDetailScreen(chitItem: chitItem),
                  ),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View Detail',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.arrow_forward,
                    color: AppColors.primaryColor,
                    size: 16.w,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
