import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:siva_saravana/Screens/Home_Sections/need_help_screen.dart';
import 'package:siva_saravana/Screens/Home_Sections/notification_screen.dart';
import 'package:siva_saravana/widgets/chatbox_widget.dart';
import 'package:siva_saravana/services/chit_scheme_api.dart';
import 'package:intl/intl.dart';
import '../../constants/app_colors.dart';
import 'my_chit_detail.dart';
import '../../services/profile_view_api.dart';
import '../../services/shared_prefs_helper.dart';

class MyChitsScreen extends StatefulWidget {
  final VoidCallback? onBackToHome;
  final VoidCallback? onMenuTap;
  const MyChitsScreen({super.key, this.onBackToHome, this.onMenuTap});

  @override
  State<MyChitsScreen> createState() => _MyChitsScreenState();
}

class _MyChitsScreenState extends State<MyChitsScreen> {
  bool _isLoading = true;
  List<dynamic> _myChitsList = [];
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _fetchMyChits();
    _fetchProfileName();
  }

  Future<void> _fetchProfileName() async {
    final savedName = await SharedPrefsHelper.getUserName();
    if (savedName.isNotEmpty) {
      if (mounted) {
        setState(() {
          _userName = savedName;
        });
      }
    } else {
      final response = await ProfileViewApiService.fetchProfile();
      if (mounted && response != null && response['error'] == false) {
        final profile = response['profile'];
        if (profile != null && profile['name'] != null) {
          setState(() {
            _userName = profile['name'];
          });
          SharedPrefsHelper.saveUserName(profile['name']);
        }
      }
    }
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
    if (dateString == null ||
        dateString == '0' ||
        dateString.toString().isEmpty)
      return '-';
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
          icon: Icon(Icons.menu, color: Colors.black, size: 24.w),
          onPressed: () {
            if (widget.onMenuTap != null) {
              widget.onMenuTap!();
            }
          },
        ),
        titleSpacing: 0,
        title: Text(
          'My Chits',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
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
                border: Border.all(
                  color: const Color(0xFF9B9B9B),
                  width: 0.5.w,
                ),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/scheme_images/need_help.png',
                    width: 16.w,
                    height: 16.h,
                  ),
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
                MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
                ),
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
    bool isPrized = chitItem['Status']?.toString().toLowerCase() == 'prized';
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon and Active status
              Container(
                width: 70.w,
                padding: EdgeInsets.symmetric(vertical: 6.h),
                decoration: BoxDecoration(
                  color: Color(0x33018F46),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                  ),
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/chit_group.png',
                      height: 28.h,
                      width: 28.w,
                    ),
                    SizedBox(height: 2.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(
                        chitItem['Chit Status']?.toString().toUpperCase() ?? '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 7.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              // Name and Group Code
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${_userName.isNotEmpty ? _userName : (chitItem['Chit Name']?.toString() ?? '')} - ${chitItem['Chit_id']?.toString() ?? ''}",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Text(
                            'GROUP CODE ',
                            style: TextStyle(
                              color: Color(0xFF475569),
                              fontSize: 12.sp,
                            ),
                          ),
                          Text(
                            chitItem['Group Name']?.toString() ?? '',
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
              ),
              // Status Badge
              Padding(
                padding: EdgeInsets.only(top: 10.h, right: 10.w),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: isPrized
                        ? const Color(0xFFCED6F9)
                        : const Color(0xFFFFFAE6),
                    border: Border.all(
                      color: isPrized
                          ? const Color(0xFF22378A)
                          : const Color(0xFFD9AB07),
                    ),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 4.w,
                        height: 4.w,
                        decoration: BoxDecoration(
                          color: isPrized
                              ? const Color(0xFF22378A)
                              : const Color(0xFFD9AB07),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        isPrized
                            ? 'Prized'
                            : chitItem['Status']?.toString() ?? '',
                        style: TextStyle(
                          color: isPrized
                              ? const Color(0xFF22378A)
                              : const Color(0xFFD9AB07),
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Divider(color: Color(0xFFF1F5F9), height: 1.h),
          Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Chit Value',
                          style: TextStyle(
                            color: Color(0xFF475569),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '₹ ${_formatAmount(chitItem['Chit Value'])}',
                          style: TextStyle(
                            color: const Color(0xFF2545C4),
                            fontWeight: FontWeight.w700,
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
                          style: TextStyle(
                            color: Color(0xFF475569),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          _formatDate(chitItem['Start Date']),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'End Date',
                          style: TextStyle(
                            color: Color(0xFF475569),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          _formatDate(chitItem['End Date']),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _showMiniStatementBottomSheet(context, chitItem);
                        },
                        child: Text(
                          'Mini Statement',
                          style: TextStyle(
                            color: const Color(0xFF22378A),
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                            decoration: TextDecoration.underline,
                            decorationColor: const Color(0xFF22378A),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MyChitDetailScreen(chitItem: chitItem),
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
                                fontWeight: FontWeight.w400,
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMiniStatementBottomSheet(BuildContext context, dynamic chitItem) {
    String groupCode = chitItem['Chit_id']?.toString() ?? '';
    String chitValue = _formatAmount(chitItem['Chit Value']);
    String name = _userName.isNotEmpty
        ? _userName
        : (chitItem['Chit Name']?.toString() ?? '');

    int parsedChitId = int.tryParse(groupCode) ?? 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return FutureBuilder<List<dynamic>?>(
          future: ChitSchemeApiService.fetchMiniStatement(parsedChitId),
          builder: (context, snapshot) {
            return Container(
              height: 450.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
              ),
              child: Column(
                children: [
                  // Header & Drag Handle
                  SizedBox(height: 12.h),
                  Center(
                    child: Container(
                      width: 50.w,
                      height: 5.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2.5.r),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.grey[500], size: 24.sp),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                  // Title Area
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Mini Statement',
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inter',
                                color: const Color(0xFF1E293B),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(color: const Color(0xFF0C8A4B)),
                              ),
                              child: Text(
                                'Group $groupCode',
                                style: TextStyle(
                                  color: const Color(0xFF0C8A4B),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Group Code: $groupCode • $name • Chit Value: ₹ $chitValue',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: const Color(0xFF64748B),
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Table Header
                  Container(
                    color: const Color(0xFFF8FAFC),
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text('DATE', style: _tableHeaderStyle()),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text('DUE', style: _tableHeaderStyle()),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'DUE AMT',
                            textAlign: TextAlign.right,
                            style: _tableHeaderStyle(),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'DIVI',
                            textAlign: TextAlign.right,
                            style: _tableHeaderStyle(),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            'ACTUAL DUE',
                            textAlign: TextAlign.right,
                            style: _tableHeaderStyle(),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'BALANCE',
                            textAlign: TextAlign.right,
                            style: _tableHeaderStyle(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Table Body
                  Expanded(
                    child: snapshot.connectionState == ConnectionState.waiting
                        ? const Center(child: CircularProgressIndicator())
                        : snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty
                            ? Center(
                                child: Text(
                                  'No statement data available.',
                                  style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                                ),
                              )
                            : ListView.separated(
                                itemCount: snapshot.data!.length,
                                separatorBuilder: (context, index) =>
                                    Divider(height: 1.h, color: const Color(0xFFF1F5F9)),
                                itemBuilder: (context, index) {
                                  final row = snapshot.data![index];
                                  final balance = double.tryParse(row['balance']?.toString() ?? '0') ?? 0;
                                  
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 12.h,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Text(_formatDate(row['date']), style: _tableRowStyle()),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(row['due']?.toString() ?? '-', style: _tableRowStyle()),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            row['dueAmt']?.toString() ?? '-',
                                            textAlign: TextAlign.right,
                                            style: _tableRowStyle(),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            row['divi']?.toString() ?? '-',
                                            textAlign: TextAlign.right,
                                            style: _tableRowStyle(),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            row['actualDue']?.toString() ?? '-',
                                            textAlign: TextAlign.right,
                                            style: _tableRowStyle(isBold: true),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            _formatAmount(balance),
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.bold,
                                              color: balance > 0
                                                  ? const Color(0xFFDC2626)
                                                  : const Color(0xFF0C8A4B),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }

  TextStyle _tableHeaderStyle() {
    return TextStyle(
      fontSize: 10.sp,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF64748B),
      fontFamily: 'Inter',
    );
  }

  TextStyle _tableRowStyle({bool isBold = false}) {
    return TextStyle(
      fontSize: 12.sp,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      color: const Color(0xFF334155),
      fontFamily: 'Inter',
    );
  }
}
