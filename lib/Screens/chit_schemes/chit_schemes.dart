import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:siva_saravana/Screens/Home_Sections/need_help_screen.dart';
import 'package:siva_saravana/Screens/Home_Sections/notification_screen.dart';
import 'package:siva_saravana/Screens/chit_schemes/subscription_screen.dart';
import 'package:siva_saravana/Screens/Home_Sections/drawers_screen.dart';
import '../../services/chit_scheme_api.dart';
import 'package:siva_saravana/widgets/chatbox_widget.dart';

class ChitSchemesScreen extends StatefulWidget {
  final int initialTab;
  final VoidCallback? onBackTap;
  final VoidCallback? onMenuTap;
  final Map<String, String>? growthPlanParams;
  const ChitSchemesScreen({
    super.key,
    this.initialTab = 0,
    this.onBackTap,
    this.onMenuTap,
    this.growthPlanParams,
  });

  @override
  State<ChitSchemesScreen> createState() => _ChitSchemesScreenState();
}

class _ChitSchemesScreenState extends State<ChitSchemesScreen> {
  late int _selectedTabIndex;
  List<dynamic> _schemes = [];
  List<dynamic> _availableChits = [];
  bool _isLoadingSchemes = true;
  bool _isLoadingAvailable = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDrawerOpen = false;

  @override
  void initState() {
    super.initState();
    _selectedTabIndex = widget.initialTab;
    _fetchData();
  }

  Future<void> _fetchData() async {
    List<dynamic>? schemesData;
    if (widget.growthPlanParams != null) {
      schemesData = await ChitSchemeApiService.fetchGrowthPlanChits(
        widget.growthPlanParams!,
      );
    } else {
      schemesData = await ChitSchemeApiService.fetchChitSchemes();
    }
    if (mounted) {
      setState(() {
        _schemes = schemesData ?? [];
        _isLoadingSchemes = false;
      });
    }

    final availableData = await ChitSchemeApiService.fetchAvailableChits();
    if (mounted) {
      setState(() {
        _availableChits = availableData ?? [];
        _isLoadingAvailable = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentList = _selectedTabIndex == 0 ? _schemes : _availableChits;
    final isLoading = _selectedTabIndex == 0
        ? _isLoadingSchemes
        : _isLoadingAvailable;

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
        backgroundColor: const Color(0xFFF3F3F5),
        onDrawerChanged: (isOpened) {
          if (widget.onMenuTap == null) {
            setState(() {
              _isDrawerOpen = isOpened;
            });
          }
        },
        drawer: widget.onMenuTap == null ? const DrawersScreen() : null,
        appBar: AppBar(
          backgroundColor: const Color(0xFFF3F3F5),
          elevation: 0,
          surfaceTintColor: Colors.transparent,
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
          titleSpacing: 0,
          title: Text(
            'Chits Schemes',
            style: TextStyle(
              fontSize: 16.sp,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NeedHelpScreen(),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0xFF9B9B9B),
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/scheme_images/need_help.png',
                      width: 14.w,
                      height: 14.w,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Need Help ?',
                      style: TextStyle(
                        color: const Color(0xFF0C8A4B),
                        fontSize: 10.sp,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 12.w),
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
                width: 22.w,
                height: 22.w,
                color: Colors.black,
              ),
            ),
            SizedBox(width: 16.w),
          ],
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  _buildTabBar(),
                  if (_selectedTabIndex == 0) _buildTableHeader(),
                  Expanded(
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : currentList.isEmpty
                        ? const Center(child: Text('No data found.'))
                        : ListView.separated(
                            padding: _selectedTabIndex == 1
                                ? EdgeInsets.symmetric(vertical: 16.h)
                                : EdgeInsets.zero,
                            itemCount: currentList.length,
                            separatorBuilder: (context, index) =>
                                _selectedTabIndex == 0
                                ? Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: const Color(0xFFE5E7EB),
                                  )
                                : SizedBox(height: 16.h),
                            itemBuilder: (context, index) {
                              final item = currentList[index];
                              return _selectedTabIndex == 0
                                  ? _buildTableRow(item)
                                  : _buildAvailableChitCard(item);
                            },
                          ),
                  ),
                ],
              ),
              const ChatboxWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTabIndex = 0),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                decoration: BoxDecoration(
                  color: _selectedTabIndex == 0
                      ? const Color(0xFFE8F6ED)
                      : Colors.white,
                  border: Border(
                    bottom: BorderSide(
                      color: _selectedTabIndex == 0
                          ? const Color(0xFF0C8A4B)
                          : Colors.transparent,
                      width: 2.h,
                    ),
                  ),
                ),
                child: Text(
                  'Chits Schemes',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    color: _selectedTabIndex == 0
                        ? const Color(0xFF0C8A4B)
                        : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTabIndex = 1),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                decoration: BoxDecoration(
                  color: _selectedTabIndex == 1
                      ? const Color(0xFFE8F6ED)
                      : Colors.white,
                  border: Border(
                    bottom: BorderSide(
                      color: _selectedTabIndex == 1
                          ? const Color(0xFF0C8A4B)
                          : Colors.transparent,
                      width: 2.h,
                    ),
                  ),
                ),
                child: Text(
                  'Available Chits',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    color: _selectedTabIndex == 1
                        ? const Color(0xFF0C8A4B)
                        : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              'Chit Value',
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Members',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Months',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'View',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(dynamic item) {
    final String chitValue =
        '₹ ${_formatAmount(double.tryParse((item['ch_value'] ?? item['chit_value'])?.toString() ?? '0') ?? 0)}';
    final String members =
        '${item['nom'] ?? item['no_of_members'] ?? item['no_of_emis'] ?? '0'}';
    final String months =
        '${item['nom'] ?? item['no_of_members'] ?? item['no_of_emis'] ?? '0'}';

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              chitValue,
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                color: const Color(0xFF0C8A4B),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              members,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              months,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SubscriptionScreen(chitId: item['id'] ?? 0),
                    ),
                  );
                },
                child: Image.asset(
                  'assets/scheme_images/view-svgrepo-com 2 (1).png',
                  width: 22.w,
                  height: 22.w,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.remove_red_eye_outlined,
                    size: 22.sp,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableChitCard(dynamic item) {
    final String chitValueStr = item['value']?.toString() ?? '0';
    final double chitValue = double.tryParse(chitValueStr) ?? 0;

    final String durationStr = item['duration_text']?.toString() ?? '';
    final String availableSlotsStr = item['bal_sub']?.toString() ?? '0';

    final String halfTicketValueStr =
        item['value_half_ticket']?.toString() ?? '0';
    final double halfTicketValue = double.tryParse(halfTicketValueStr) ?? 0;
    final String halfTicketSlotsStr =
        item['bal_half_ticket']?.toString() ?? '0';

    final String fullTicketSlotsStr =
        item['bal_full_ticket']?.toString() ?? '0';
    final String totalMonthsStr = item['total_month']?.toString() ?? '0';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFF00875A), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
            child: Text(
              'Chit Value - ₹ ${_formatAmount(chitValue)}',
              style: TextStyle(
                fontSize: 16.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                color: const Color(0xFF018F46),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 1.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F8FA),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/date.png',
                          height: 18.h,
                          width: 18.w,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Total Months',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.grey,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          '$totalMonthsStr Months',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                            color: Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 40.h,
                    width: 1.w,
                    color: const Color(0xFFE2E8F0),
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/clock.png',
                          height: 18.h,
                          width: 18.w,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Duration',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.grey,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          durationStr,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                            color: Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 40.h,
                    width: 1.w,
                    color: const Color(0xFFE2E8F0),
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/persons.png',
                          height: 18.h,
                          width: 18.w,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Available Slots',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.grey,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          '$availableSlotsStr Slots',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                            color: Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              'Ticket Details',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(height: 7.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F7FD),
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(color: const Color(0xFFE2EAF4)),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/ticket.png',
                          color: const Color(0xFF1B64B7),
                          width: 18.w,
                          height: 18.w,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.confirmation_num_outlined,
                            color: const Color(0xFF1B64B7),
                            size: 22.sp,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '½ Ticket',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.grey,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              Text(
                                '₹${_formatAmount(halfTicketValue)}',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD6E8FC),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            '$halfTicketSlotsStr Slots',
                            style: TextStyle(
                              fontSize: 9.sp,
                              color: const Color(0xFF1B64B7),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF9F2),
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(color: const Color(0xFFFCECDA)),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/ticket.png',
                          color: const Color(0xFFD98E04),
                          width: 18.w,
                          height: 18.w,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.confirmation_num_outlined,
                            color: const Color(0xFFD98E04),
                            size: 18.sp,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '1 Ticket',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.grey,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              Text(
                                '₹${_formatAmount(chitValue)}',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFBE4C6),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            '$fullTicketSlotsStr Slots',
                            style: TextStyle(
                              fontSize: 9.sp,
                              color: const Color(0xFFD98E04),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 8.h),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubscriptionScreen(
                    chitId: item['scheme_id'] ?? 0,
                    isAvailableChit: true,
                  ),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 10.h,
              ).copyWith(top: 0),
              padding: EdgeInsets.symmetric(vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xFF018F46),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'View Details',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(Icons.chevron_right, color: Colors.white, size: 20.sp),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(double v) {
    final String s = v.toInt().toString();
    final reversed = s.split('').reversed.toList();
    final buffer = StringBuffer();
    for (int i = 0; i < reversed.length; i++) {
      if (i != 0 && i % 3 == 0) buffer.write(',');
      buffer.write(reversed[i]);
    }
    return buffer.toString().split('').reversed.join();
  }
}
