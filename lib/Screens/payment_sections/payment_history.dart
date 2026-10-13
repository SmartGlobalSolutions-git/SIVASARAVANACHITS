import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../services/translation_service.dart';
import '../../services/payment_api.dart';
import '../Home_Sections/drawers_screen.dart';
import 'pending_history.dart';
import 'approval_history.dart';

class PaymentHistory extends StatefulWidget {
  final VoidCallback? onBackTap;
  final VoidCallback? onMenuTap;
  const PaymentHistory({super.key, this.onBackTap, this.onMenuTap});

  @override
  State<PaymentHistory> createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDrawerOpen = false;
  bool isMyChitsOverview = false;

  bool _isLoading = true;
  List<dynamic> _payments = [];

  @override
  void initState() {
    super.initState();
    _fetchPaymentHistory();
  }

  Future<void> _fetchPaymentHistory() async {
    setState(() {
      _isLoading = true;
    });

    final data = await PaymentApiService.fetchPaymentHistory();
    if (!mounted) return;

    if (data != null && data['payments'] is List) {
      setState(() {
        _payments = List<dynamic>.from(data['payments']);
        _isLoading = false;
      });
    } else {
      setState(() {
        _payments = [];
        _isLoading = false;
      });
    }
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
        backgroundColor: const Color(0xFFF4F5F9),
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
          title: TrText(
            'Payment History',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
              color: Colors.black,
            ),
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
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context); // Go back to My Chits Overview
                        }
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
                        child: TrText(
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
                        child: TrText(
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

            // Dynamic List
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF0C8A4B),
                      ),
                    )
                  : RefreshIndicator(
                      color: const Color(0xFF0C8A4B),
                      onRefresh: _fetchPaymentHistory,
                      child: _payments.isEmpty
                          ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                SizedBox(height: 120.h),
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.receipt_long_outlined,
                                        size: 50.sp,
                                        color: Colors.grey.shade400,
                                      ),
                                      SizedBox(height: 10.h),
                                      TrText(
                                        'No payment history found',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.grey.shade600,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
                              itemCount: _payments.length,
                              itemBuilder: (context, index) {
                                final payment = _payments[index];
                                return _buildListItem(index, payment);
                              },
                            ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(int index, dynamic payment) {
    final String currentMonth = payment['month_label']?.toString() ?? '';
    final bool showMonthDivider = currentMonth.isNotEmpty &&
        (index == 0 ||
            _payments[index - 1]['month_label']?.toString() != currentMonth);

    final chitIdVal = payment['chit_id']?.toString() ??
        payment['chit_no']?.toString() ??
        '';
    final String chitId = 'Chit / $chitIdVal';

    final groupName = payment['group_name']?.toString() ?? '';
    final groupDetail = payment['group_detail']?.toString() ?? '';
    String groupDisplay = 'Group Name / ';
    if (groupName.isNotEmpty && groupDetail.isNotEmpty) {
      groupDisplay += '$groupName / $groupDetail';
    } else if (groupName.isNotEmpty) {
      groupDisplay += groupName;
    } else if (groupDetail.isNotEmpty) {
      groupDisplay += groupDetail;
    } else {
      groupDisplay += '-';
    }

    final String dateDisplay =
        (payment['datetime_display'] != null &&
                payment['datetime_display'].toString().trim().isNotEmpty)
            ? payment['datetime_display'].toString()
            : '${payment['date'] ?? ''} ${payment['time'] ?? ''}'.trim();

    final String status = payment['status']?.toString() ?? 'Approved';
    final bool isPending = status.toLowerCase() == 'pending';

    final String amountDisplay =
        '₹${payment['amount_display'] ?? payment['amount'] ?? '0'}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showMonthDivider) ...[
          if (index > 0) SizedBox(height: 15.h),
          Center(
            child: Row(
              children: [
                Expanded(child: Divider(color: Colors.grey.shade300)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: TrText(
                    currentMonth,
                    style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                  ),
                ),
                Expanded(child: Divider(color: Colors.grey.shade300)),
              ],
            ),
          ),
          SizedBox(height: 15.h),
        ],
        _buildHistoryCard(
          payment: payment,
          chitId: chitId,
          groupName: groupDisplay,
          date: dateDisplay,
          status: status,
          amount: amountDisplay,
          isPending: isPending,
        ),
        SizedBox(height: 10.h),
      ],
    );
  }

  Widget _buildHistoryCard({
    required dynamic payment,
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PendingHistoryScreen(),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ApprovalHistoryScreen(
                paymentData: payment is Map<String, dynamic>
                    ? payment
                    : Map<String, dynamic>.from(payment as Map),
              ),
            ),
          );
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
              child: Icon(
                Icons.account_balance_wallet,
                color: const Color(0xFF0C8A4B),
                size: 20.sp,
              ),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chitId,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    groupName,
                    style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    date,
                    style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: isPending ? Colors.orange.shade50 : Colors.white,
                    border: Border.all(
                      color: isPending
                          ? Colors.orange.shade200
                          : const Color(0xFF1B3C73),
                    ),
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
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
                          child: Icon(
                            Icons.check,
                            color: const Color(0xFF1B3C73),
                            size: 12.sp,
                          ),
                        ),
                      TrText(
                        status,
                        style: TextStyle(
                          color: isPending
                              ? Colors.orange
                              : const Color(0xFF1B3C73),
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  amount,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0C8A4B),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
