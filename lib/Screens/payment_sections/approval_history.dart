import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../services/translation_service.dart';
import '../Home_Sections/drawers_screen.dart';

class ApprovalHistoryScreen extends StatefulWidget {
  final VoidCallback? onBackTap;
  final VoidCallback? onMenuTap;
  final Map<String, dynamic>? paymentData;
  final String? chitNumber;
  final String? groupName;
  final String? paymentDateTime;
  final String? amountPaid;
  final String? paymentStatus;
  final String? referenceNo;

  const ApprovalHistoryScreen({
    super.key,
    this.onBackTap,
    this.onMenuTap,
    this.paymentData,
    this.chitNumber,
    this.groupName,
    this.paymentDateTime,
    this.amountPaid,
    this.paymentStatus,
    this.referenceNo,
  });

  @override
  State<ApprovalHistoryScreen> createState() => _ApprovalHistoryScreenState();
}

class _ApprovalHistoryScreenState extends State<ApprovalHistoryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDrawerOpen = false;

  String get chitNumber {
    if (widget.chitNumber != null && widget.chitNumber!.isNotEmpty) {
      return widget.chitNumber!;
    }
    final p = widget.paymentData;
    if (p != null) {
      if (p['chit_no'] != null && p['chit_no'].toString().trim().isNotEmpty) {
        return p['chit_no'].toString();
      }
      if (p['chit_id'] != null) {
        return p['chit_id'].toString();
      }
    }
    return '-';
  }

  String get groupName {
    if (widget.groupName != null && widget.groupName!.isNotEmpty) {
      return widget.groupName!;
    }
    final p = widget.paymentData;
    if (p != null) {
      final gName = p['group_name']?.toString() ?? '';
      final gDetail = p['group_detail']?.toString() ?? '';
      if (gName.isNotEmpty && gDetail.isNotEmpty) {
        return '$gName / $gDetail';
      } else if (gName.isNotEmpty) {
        return gName;
      } else if (gDetail.isNotEmpty) {
        return gDetail;
      }
    }
    return '-';
  }

  String get paymentDateTime {
    if (widget.paymentDateTime != null && widget.paymentDateTime!.isNotEmpty) {
      return widget.paymentDateTime!;
    }
    final p = widget.paymentData;
    if (p != null) {
      if (p['datetime_display'] != null &&
          p['datetime_display'].toString().trim().isNotEmpty) {
        return p['datetime_display'].toString();
      }
      final d = p['date']?.toString() ?? '';
      final t = p['time']?.toString() ?? '';
      final dt = '$d $t'.trim();
      if (dt.isNotEmpty) return dt;
    }
    return '-';
  }

  String get amountPaid {
    if (widget.amountPaid != null && widget.amountPaid!.isNotEmpty) {
      return widget.amountPaid!.startsWith('₹')
          ? widget.amountPaid!
          : '₹${widget.amountPaid}';
    }
    final p = widget.paymentData;
    if (p != null) {
      final amt = p['amount_display'] ?? p['amount'];
      if (amt != null) return '₹$amt';
    }
    return '₹0';
  }

  String get paymentStatus {
    if (widget.paymentStatus != null && widget.paymentStatus!.isNotEmpty) {
      return widget.paymentStatus!;
    }
    final p = widget.paymentData;
    if (p != null) {
      return p['status']?.toString() ?? 'Approved';
    }
    return 'Approved';
  }

  String? get referenceNo {
    if (widget.referenceNo != null && widget.referenceNo!.isNotEmpty) {
      return widget.referenceNo;
    }
    final p = widget.paymentData;
    if (p != null &&
        p['ref'] != null &&
        p['ref'].toString().trim().isNotEmpty) {
      return p['ref'].toString();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isDrawerOpen,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_isDrawerOpen) {
          _scaffoldKey.currentState?.closeDrawer();
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        onDrawerChanged: (isOpened) {
          if (widget.onMenuTap == null) {
            setState(() {
              _isDrawerOpen = isOpened;
            });
          }
        },
        drawer: widget.onMenuTap == null ? const DrawersScreen() : null,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          titleSpacing: 0,
          leading: IconButton(
            icon: Icon(
              (widget.onBackTap != null || Navigator.canPop(context))
                  ? Icons.arrow_back
                  : Icons.menu,
              color: Colors.black,
              size: 24.sp,
            ),
            onPressed: () {
              if (widget.onBackTap != null) {
                widget.onBackTap!();
              } else if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else if (widget.onMenuTap != null) {
                widget.onMenuTap!();
              } else {
                _scaffoldKey.currentState?.openDrawer();
              }
            },
          ),
          title: TrText(
            'Receipt Approval',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
              color: Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          child: Column(
            children: [
              // The image was blank in the screenshot, just text below it
              Image.asset('assets/pay success.gif', width: 150.w),
              TrText(
                'Payment Successful',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0C8A4B),
                ),
              ),
              SizedBox(height: 10.h),
              TrText(
                'Your payment has been completed and the\nreceipt has been generated.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 30.h),
              // Details Card
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    _buildDetailRow('Chit Number', chitNumber),
                    SizedBox(height: 15.h),
                    _buildDetailRow('Group Name', groupName),
                    SizedBox(height: 15.h),
                    _buildDetailRow('Payment Date & Time', paymentDateTime),
                    SizedBox(height: 15.h),
                    _buildDetailRow('Amount Paid', amountPaid, isAmount: true),
                    if (referenceNo != null && referenceNo!.isNotEmpty) ...[
                      SizedBox(height: 15.h),
                      _buildDetailRow('Reference No', referenceNo!),
                    ],
                    SizedBox(height: 15.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TrText(
                          'Payment Status',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F6ED),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle, color: const Color(0xFF0C8A4B), size: 14.sp),
                              SizedBox(width: 5.w),
                              TrText(
                                paymentStatus,
                                style: TextStyle(
                                  color: const Color(0xFF0C8A4B),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              // Blue Alert Box
              Container(
                padding: EdgeInsets.all(15.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B3C73),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.receipt_long, color: Colors.white, size: 30.sp),
                    SizedBox(width: 15.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TrText(
                            'Your receipt has been generated successfully.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          TrText(
                            'You can download or share it for your records.',
                            style: TextStyle(color: Colors.white70, fontSize: 11.sp),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              // Download Button
              SizedBox(
                width: 250.w,
                height: 45.h,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.download, color: Colors.white, size: 20.sp),
                  label: TrText(
                    'Download Receipt',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0C8A4B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isAmount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TrText(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 10.w),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: isAmount ? const Color(0xFF0C8A4B) : Colors.black87,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
