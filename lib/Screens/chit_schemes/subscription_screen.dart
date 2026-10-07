import 'package:siva_saravana/widgets/chatbox_widget.dart';

import 'package:flutter/material.dart';
import 'package:siva_saravana/Screens/Home_Sections/need_help_screen.dart';
import 'package:siva_saravana/Screens/Home_Sections/notification_screen.dart';
import 'package:siva_saravana/widgets/chit_enquiry.dart';
import 'package:siva_saravana/constants/app_colors.dart';
import 'package:siva_saravana/Screens/Home_Sections/drawers_screen.dart';
import 'screen_utils.dart';
import '../../services/chit_scheme_api.dart';

class SubscriptionScreen extends StatefulWidget {
  final int chitId;
  final bool isAvailableChit;
  final VoidCallback? onBackTap;
  final VoidCallback? onMenuTap;
  const SubscriptionScreen({super.key, required this.chitId, this.isAvailableChit = false, this.onBackTap, this.onMenuTap});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDrawerOpen = false;
  bool _isLoading = true;
  Map<String, dynamic>? _itemData;
  List<dynamic> _schedule = [];
  Map<String, dynamic>? _totals;

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    if (widget.isAvailableChit) {
      final detailData = await ChitSchemeApiService.fetchAvailableChitDetail(widget.chitId);
      if (mounted) {
        setState(() {
          if (detailData != null) {
            _itemData = detailData;
            _schedule = detailData['sub_records'] ?? [];
            _calculateTotals();
          }
          _isLoading = false;
        });
      }
    } else {
      final detailData = await ChitSchemeApiService.fetchChitSchemeDetail(widget.chitId);
      if (mounted) {
        setState(() {
          if (detailData != null) {
            _itemData = detailData['item'];
            _schedule = detailData['schedule'] ?? [];
            _totals = detailData['totals'];
          }
          _isLoading = false;
        });
      }
    }
  }

  void _calculateTotals() {
    if (_schedule.isNotEmpty) {
      double totalDue = 0;
      double totalDividend = 0;
      double totalPrize = 0;
      for (var row in _schedule) {
        totalDue += double.tryParse(row['due_amt']?.toString() ?? '0') ?? 0;
        totalDividend += double.tryParse(row['damount']?.toString() ?? '0') ?? 0;
        totalPrize += double.tryParse(row['pamount']?.toString() ?? '0') ?? 0;
      }
      _totals = {
        'due_amt': totalDue.toInt(),
        'divident': totalDividend.toInt(),
        'total': totalPrize.toInt(),
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

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
          titleSpacing: 0,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(
              Icons.menu,
              color: AppColors.backIconColor,
              size: 24.sp,
            ),
            onPressed: () {
              if (widget.onMenuTap != null) {
                widget.onMenuTap!();
              } else {
                _scaffoldKey.currentState?.openDrawer();
              }
            },
          ),
        title: Text(
          'Subscription Plan',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.titleText,
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
                border: Border.all(color: const Color(0xFF9B9B9B), width: 0.5),
                borderRadius: BorderRadius.circular(20),
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
                    style: TextStyle(color: const Color(0xFF018F46), fontSize: 12.sp),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 8.w),
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  // Main Scrollable Screen Body
                  Expanded(
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [0.0, 0.22, 0.35, 1.0],
                                colors: [
                                  Color(0xFFE8FDF2), // Top near header is light mint green
                                  Color(0xFFE8FDF2), // Light mint green continues behind logo & value
                                  Color(0xFFF6FDF9), // Gradual transition down into white
                                  Colors.white, // Full white for table card & rest of page
                                ],
                              ),
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: 12.h),

                                // Company Logo Asset
                                Image.asset(
                                  'assets/scheme_images/image 9.png',
                                  height: 38.h,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) => Text(
                                    'Siva Saravana Chit Funds (P) Ltd',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.titleText,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 6.h),

                                // Green Chit Value Header Text
                                Text(
                                  _itemData != null ? '₹ ${_itemData!['ch_value'] ?? '0'}' : '₹ 0',
                                  style: TextStyle(
                                    fontSize: 42.sp,
                                    fontWeight: FontWeight.w900,
                                    color: const Color(0xFF009640),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                SizedBox(height: 16.h),

                                // Content Container with Table Card
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Subscription Table Card Container
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(16.sp),
                                          border: Border.all(color: const Color(0xFFE2E8F0)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withAlpha(12),
                                              blurRadius: 12,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        clipBehavior: Clip.antiAlias,
                                        child: Column(
                                          children: [
                                            // Green Table Header
                                            Container(
                                              color: const Color(0xFF008837),
                                              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 4.w),
                                              child: Row(
                                                children: [
                                                  _buildHeaderCell('Month', flex: 2),
                                                  _buildHeaderCell('Subscription\n(₹)', flex: 3),
                                                  _buildHeaderCell('Dividend\n(₹)', flex: 3),
                                                  _buildHeaderCell('Bid Value\n(₹)', flex: 3),
                                                  _buildHeaderCell('Prize Amount\n(₹)', flex: 3),
                                                ],
                                              ),
                                            ),

                                            // Table Data Rows
                                            ListView.separated(
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemCount: _schedule.length,
                                              separatorBuilder: (context, index) => const Divider(
                                                height: 1,
                                                thickness: 0.5,
                                                color: Color(0xFFEEEEEE),
                                              ),
                                              itemBuilder: (context, index) {
                                                final row = _schedule[index];
                                                final String monthStr = widget.isAvailableChit ? '${row['month'] ?? ''}' : '${row['sno'] ?? ''}';
                                                final String dueAmtStr = '${row['due_amt'] ?? ''}';
                                                final String dividendStr = widget.isAvailableChit ? '${row['damount'] ?? ''}' : '${row['divident'] ?? ''}';
                                                final String bidAmtStr = widget.isAvailableChit ? '${row['dis_amount'] ?? ''}' : '${row['bid_amt'] ?? ''}';
                                                final String prizeAmtStr = widget.isAvailableChit ? '${row['pamount'] ?? ''}' : '${row['payment'] ?? ''}';

                                                return Container(
                                                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
                                                  color: Colors.white,
                                                  child: Row(
                                                    children: [
                                                      // Month
                                                      Expanded(
                                                        flex: 2,
                                                        child: Text(
                                                          monthStr,
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize: 13.sp,
                                                            fontWeight: FontWeight.bold,
                                                            color: const Color(0xFF009640),
                                                          ),
                                                        ),
                                                      ),
                                                      // Subscription (due_amt)
                                                      Expanded(
                                                        flex: 3,
                                                        child: Text(
                                                          dueAmtStr,
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(fontSize: 13.sp, color: const Color(0xFF333333)),
                                                        ),
                                                      ),
                                                      // Dividend (divident)
                                                      Expanded(
                                                        flex: 3,
                                                        child: Text(
                                                          dividendStr,
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(fontSize: 13.sp, color: const Color(0xFF333333)),
                                                        ),
                                                      ),
                                                      // Bid Value (bid_amt)
                                                      Expanded(
                                                        flex: 3,
                                                        child: Text(
                                                          bidAmtStr,
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(fontSize: 13.sp, color: const Color(0xFF333333)),
                                                        ),
                                                      ),
                                                      // Prize Amount (payment)
                                                      Expanded(
                                                        flex: 3,
                                                        child: Text(
                                                          prizeAmtStr,
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(fontSize: 13.sp, color: const Color(0xFF333333)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),

                                            // Total Row (Light Green Background)
                                            Container(
                                              color: const Color(0xFFE8FDF2),
                                              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 4.w),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                      'Total',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 13.sp,
                                                        fontWeight: FontWeight.bold,
                                                        color: const Color(0xFF009640),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Text(
                                                      _totals != null ? '${_totals!['due_amt'] ?? ''}' : '',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 13.sp,
                                                        fontWeight: FontWeight.bold,
                                                        color: const Color(0xFF009640),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Text(
                                                      _totals != null ? '${_totals!['divident'] ?? ''}' : '',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 13.sp,
                                                        fontWeight: FontWeight.bold,
                                                        color: const Color(0xFF009640),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Text(
                                                      '-',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 13.sp,
                                                        fontWeight: FontWeight.bold,
                                                        color: const Color(0xFF009640),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Text(
                                                      _totals != null ? '${_totals!['total'] ?? ''}' : '',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 13.sp,
                                                        fontWeight: FontWeight.bold,
                                                        color: const Color(0xFF009640),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // Single Line Notice Box Under Total
                                            Container(
                                              width: double.infinity,
                                              margin: EdgeInsets.all(8.w),
                                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF2FBF6),
                                                borderRadius: BorderRadius.circular(8.sp),
                                                border: Border.all(color: const Color(0xFFD4F2E2)),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.lightbulb_outline,
                                                    size: 15.sp,
                                                    color: const Color.fromARGB(255, 134, 153, 143),
                                                  ),
                                                  SizedBox(width: 4.w),
                                                  Expanded(
                                                    child: Text(
                                                      'This is an indicative plan. Values may vary based on actual chit group rules.',
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 12.sp,
                                                        fontWeight: FontWeight.w500,
                                                        color: const Color(0xFF444444),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(height: 90.h), // Bottom spacing for fixed button
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Enquire Now Bottom Sticky Button
                        Positioned(
                          left: 16.w,
                          right: 16.w,
                          bottom: 16.h,
                          child: SizedBox(
                            width: double.infinity,
                            height: 50.h,
                            child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => const ChitEnquirySheet(),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF009640),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(26.sp),
                                ),
                              ),
                              child: Text(
                                'Enquire Now',
                                style: TextStyle(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const ChatboxWidget(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    ));
  }

  /// Available Slots Card UI Component matching exact second screenshot
  Widget _buildAvailableSlotsCard() {
    final List<Map<String, String>> slotsData = const [
      {'type': '0.5 Ticket', 'value': '₹50,000', 'slots': '28 Slots'},
      {'type': '1 Ticket', 'value': '₹1,00,000', 'slots': '14 Slots'},
      {'type': '2 Tickets', 'value': '₹2,00,000', 'slots': '7 Slots'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(1.sp),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Purple Header Title Banner
          Container(
            color: const Color(0xFF4A4DE7),
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            child: Text(
              'Available Slots',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          // Table Header Row (Light Purple Background)
          Container(
            color: const Color(0xFFECECFF),
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Ticket Type',
                    style: TextStyle(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF4A4DE7),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Ticket Value',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF4A4DE7),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Available Slots',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF4A4DE7),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Data Rows
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: slotsData.length,
            separatorBuilder: (context, index) => const Divider(
              height: 1,
              thickness: 0.5,
              color: Color(0xFFEEEEEE),
            ),
            itemBuilder: (context, index) {
              final row = slotsData[index];
              final isEven = index % 2 == 0;
              return Container(
                color: isEven ? Colors.white : const Color(0xFFF7F7FD),
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                child: Row(
                  children: [
                    // Ticket Type
                    Expanded(
                      flex: 3,
                      child: Text(
                        row['type']!,
                        style: TextStyle(
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF333333),
                        ),
                      ),
                    ),
                    // Ticket Value
                    Expanded(
                      flex: 3,
                      child: Text(
                        row['value']!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF333333),
                        ),
                      ),
                    ),
                    // Available Slots
                    Expanded(
                      flex: 3,
                      child: Text(
                        row['slots']!,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF333333),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Helper for Table Header Cells
  Widget _buildHeaderCell(String label, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          height: 1.2,
        ),
      ),
    );
  }
}
