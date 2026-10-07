import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Home_Sections/drawers_screen.dart';

class PendingHistoryScreen extends StatefulWidget {
  final VoidCallback? onBackTap;
  final VoidCallback? onMenuTap;
  const PendingHistoryScreen({Key? key, this.onBackTap, this.onMenuTap}) : super(key: key);

  @override
  State<PendingHistoryScreen> createState() => _PendingHistoryScreenState();
}

class _PendingHistoryScreenState extends State<PendingHistoryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDrawerOpen = false;

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
            icon: Icon(Icons.menu, color: Colors.black, size: 24.sp),
            onPressed: () {
              if (widget.onMenuTap != null) {
                widget.onMenuTap!();
              } else {
                _scaffoldKey.currentState?.openDrawer();
              }
            },
          ),
          title: Text(
            'Receipt Pending',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
              color: Colors.black,
            ),
          ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Placeholder for the illustration
            Image.asset('assets/pay aprove.gif', width: 150.w,), // fallback icon
            SizedBox(height: 30.h),
            Text(
              'Receipt Pending',
              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 15.h),
            Text(
              'Your payment is being processed. The\nreceipt will be generated shortly once the\npayment is confirmed.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600, height: 1.5),
            ),
            SizedBox(height: 40.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF6E4),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: Color(0Xfffde6b8)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.timelapse, color: Colors.orange, size: 24.sp),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'Please check back later or refresh to\nview your receipt.',
                      style: TextStyle(color: Colors.brown.shade700, fontSize: 13.sp, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),// pushes content up slightly
          ],
        ),
      ),
    ));
  }
}
