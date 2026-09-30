import 'package:flutter/material.dart';
import 'package:siva_saravana/Screens/Home_Sections/need_help_screen.dart';
import 'package:siva_saravana/Screens/Home_Sections/notification_screen.dart';
import 'package:siva_saravana/constants/app_colors.dart';
import 'package:siva_saravana/Screens/chit_schemes/subscription_screen.dart';
import '../../services/chit_scheme_api.dart';
import 'package:siva_saravana/widgets/chatbox_widget.dart';
import 'screen_utils.dart';

class ChitSchemaScreen extends StatefulWidget {
  final int initialTab;
  final VoidCallback? onBackTap;
  const ChitSchemaScreen({super.key, this.initialTab = 0, this.onBackTap});

  @override
  State<ChitSchemaScreen> createState() => _ChitSchemaScreenState();
}

class _ChitSchemaScreenState extends State<ChitSchemaScreen> {
  late int _selectedTabIndex;

  List<dynamic> _schemes = [];
  List<dynamic> _availableChits = [];
  bool _isLoadingSchemes = true;
  bool _isLoadingAvailable = true;

  @override
  void initState() {
    super.initState();
    _selectedTabIndex = widget.initialTab;
    _fetchData();
  }

  Future<void> _fetchData() async {
    final schemesData = await ChitSchemeApiService.fetchChitSchemes();
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
    ScreenUtil.init(context);

    final currentList = _selectedTabIndex == 0 ? _schemes : _availableChits;
    final isLoading = _selectedTabIndex == 0
        ? _isLoadingSchemes
        : _isLoadingAvailable;

    return Scaffold(
      backgroundColor: Color(0xFFF3F3F5),
      appBar: AppBar(
        backgroundColor: Color(0xFFF3F3F5),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.backIconColor,
            size: 24.sp,
          ),
          onPressed: () {
            if (widget.onBackTap != null) {
              widget.onBackTap!();
            } else {
              Navigator.maybePop(context);
            }
          },
        ),
        titleSpacing: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Chits Schemes',
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.bold,
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
                border: Border.all(color: Color(0xFF9B9B9B), width: 0.5),
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
                    style: TextStyle(color: Color(0xFF018F46), fontSize: 12.sp),
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
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 10.h),
                // Tab Bar Switcher (Chits Schemes / Available Chits)
                _buildTabBar(),

                // Table Column Titles Header
                _buildTableHeader(),

                // List of Chit Schemes
                Expanded(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : currentList.isEmpty
                      ? const Center(child: Text('No data found.'))
                      : ListView.separated(
                          itemCount: currentList.length,
                          separatorBuilder: (context, index) => Divider(
                            height: 1,
                            thickness: 1,
                            color: AppColors.dividerColor,
                          ),
                          itemBuilder: (context, index) {
                            final item = currentList[index];
                            return _buildTableRow(item);
                          },
                        ),
                ),
              ],
            ),

            // Floating Mascot Overlay Bot Icon (Bottom Right)
            const ChatboxWidget(),
          ],
        ),
      ),
    );
  }

  /// Top Tab Bar for selecting between "Chits Schemes" and "Available Chits"
  Widget _buildTabBar() {
    return Row(
      children: [
        // Tab 1: Chits Schemes
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedTabIndex = 0;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 14.h),
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
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: _selectedTabIndex == 0
                      ? const Color(0xFF0C8A4B)
                      : Colors.grey,
                ),
              ),
            ),
          ),
        ),

        // Tab 2: Available Chits
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedTabIndex = 1;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 14.h),
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
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: _selectedTabIndex == 1
                      ? const Color(0xFF0C8A4B)
                      : Colors.grey,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Header row for table columns (Chit Value, Members, Months, View)
  Widget _buildTableHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.tableHeaderBg,
        border: Border(
          bottom: BorderSide(color: AppColors.dividerColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              'Chit Value',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.tableHeaderText,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Members',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.tableHeaderText,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Months',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.tableHeaderText,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'View',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.tableHeaderText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Individual row for chit scheme data
  Widget _buildTableRow(dynamic item) {
    final bool isScheme = _selectedTabIndex == 0;
    final String chitValue = isScheme
        ? '₹ ${item['ch_value'] ?? '0'}'
        : '₹ ${item['value'] ?? '0'}';
    final String members = isScheme
        ? '${item['nom'] ?? '0'}'
        : '${item['total_sub'] ?? '0'}';
    final String months = isScheme
        ? '${item['nom'] ?? '0'}'
        : '${item['total_sub'] ?? '0'}';

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        children: [
          // Chit Value (Green bold text 16sp)
          Expanded(
            flex: 3,
            child: Text(
              chitValue,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
          ),

          // Members Count (16sp)
          Expanded(
            flex: 2,
            child: Text(
              members,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.rowText,
              ),
            ),
          ),

          // Months Count (16sp)
          Expanded(
            flex: 2,
            child: Text(
              months,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.rowText,
              ),
            ),
          ),

          // View Eye Icon
          Expanded(
            flex: 1,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  if (isScheme) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SubscriptionScreen(chitId: item['id'] ?? 0),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Detail view coming soon')),
                    );
                  }
                },
                child: Image.asset(
                  'assets/scheme_images/view-svgrepo-com 2 (1).png',
                  width: 22.w,
                  height: 22.h,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.remove_red_eye_outlined,
                    size: 22.sp,
                    color: AppColors.rowText,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
