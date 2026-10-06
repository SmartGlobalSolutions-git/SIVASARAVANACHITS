import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'prebid_detail.dart';
import 'package:intl/intl.dart';
import '../../services/prebid_api.dart';
import '../../services/profile_view_api.dart';

const Color kScreenBg = Color(0xFFF3F3F5);
const Color kCardBorderColor = Color(0xFFA7F3D0);
const Color kCreamBoxColor = Color(0xFFD9AB07);
const Color kBadgeBgColor = Color(0xFFF0FDF4);
const Color kBadgeDotColor = Color(0xFF00562E);
const Color kBadgeTextColor = Color(0xFF00562E);
const Color kNameColor = Color(0xFF000000);
const Color kGroupLabelColor = Color(0xFF475569);
const Color kGroupValueColor = Color(0xFF0F172A);
const Color kDateLabelColor = Color(0xFF263238);
const Color kDateValueColor = Color(0xFF018F46);
const Color kNeedHelpBorderColor = Color(0xFF9B9B9B);
const Color kNeedHelpTextColor = Color(0xFF018F46);
const Color kPrebidGradientStart = Color(0xFFE2B721);
const Color kPrebidGradientEnd = Color(0xFFC39F1E);

class PrebiddingListScreen extends StatefulWidget {
  const PrebiddingListScreen({super.key});

  @override
  State<PrebiddingListScreen> createState() => _PrebiddingListScreenState();
}

class _PrebiddingListScreenState extends State<PrebiddingListScreen> {
  bool _isLoading = true;
  List<dynamic> _items = [];
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _fetchProfileName();
    _fetchPrebidList();
  }

  Future<void> _fetchProfileName() async {
    final response = await ProfileViewApiService.fetchProfile();
    if (mounted && response != null && response['error'] == false) {
      final profile = response['profile'];
      if (profile != null && profile['name'] != null) {
        setState(() {
          _userName = profile['name'];
        });
      }
    }
  }

  Future<void> _fetchPrebidList() async {
    final items = await PrebidApiService.fetchPrebidList();
    if (mounted) {
      setState(() {
        _items = items ?? [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScreenBg,
      appBar: _buildAppBar(context),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
          ? const Center(child: Text("No prebid items found."))
          : ListView.separated(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
              itemCount: _items.length,
              separatorBuilder: (_, __) => SizedBox(height: 16.h),
              itemBuilder: (context, index) =>
                  PrebidCard(item: _items[index], userName: _userName),
            ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      titleSpacing: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, size: 24.sp, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Prebidding',
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
          fontSize: 16.sp,
          height: 1.0,
          color: Colors.black,
        ),
      ),
      actions: [
        // "Need Help ?" pill.
        Container(
          margin: EdgeInsets.only(right: 8.w),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            border: Border.all(color: kNeedHelpBorderColor, width: 0.6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/prebitting/help.png',
                width: 14.sp,
                height: 14.sp,
              ),
              SizedBox(width: 4.w),
              Text(
                'Need Help ?',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 10.sp,
                  height: 1.0,
                  color: kNeedHelpTextColor,
                ),
              ),
            ],
          ),
        ),
        // Notification bell.
        Padding(
          padding: EdgeInsets.only(right: 16.w),
          child: Image.asset(
            'assets/prebitting/notification.png',
            width: 22.sp,
            height: 22.sp,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

// ----------------------------------------------------------------------
// CARD
// ----------------------------------------------------------------------
class PrebidCard extends StatelessWidget {
  final dynamic item;
  final String userName;
  const PrebidCard({super.key, required this.item, required this.userName});

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
    String chitName = userName.isNotEmpty
        ? userName
        : (item['Chit Name']?.toString() ?? '');
    String groupCode = item['Group Name']?.toString() ?? '';
    String startDate = _formatDate(item['Start Date']);
    String endDate = _formatDate(item['End Date']);
    double runBal =
        double.tryParse(item['Running Balance']?.toString() ?? '0') ?? 0.0;
    bool isPrized = item['Status']?.toString().toLowerCase() == 'prized';

    return Container(
      width: 328,
      padding: EdgeInsets.fromLTRB(17.w, 10.h, 13.w, 15.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: kCardBorderColor.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  "$chitName - ${item['Chit_id'] ?? ''}",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                    color: kNameColor,
                  ),
                ),
              ),
              _StatusBadge(isPrized: isPrized),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Text(
                'GROUP CODE',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 11.sp,
                  color: kGroupLabelColor,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                groupCode,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                  color: kGroupValueColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Container(
            width: 320,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: kCreamBoxColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12.12.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoRow(
                  iconAsset: 'assets/prebitting/date.png',
                  label: 'Start - End Date',
                  value: '$startDate - \n$endDate',
                ),
                SizedBox(height: 5.h),
                _InfoRow(
                  iconAsset: 'assets/prebitting/cash.png',
                  label: 'Running Balance',
                  value: '₹ ${_formatAmount(item['Running Balance'])}',
                ),
                SizedBox(height: 10.h),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PrebiddingDetailScreen(
                            groupName: groupCode,
                            groupCode: item['Chit_id']?.toString() ?? '',
                            auctionDateTime: DateTime.now().add(
                              const Duration(hours: 4),
                            ),
                            lastAuctionAmount: runBal,
                            chitId: item['Chit_id']?.toString() ?? '',
                            grpId: item['Group Id']?.toString() ?? '',
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 86.w,
                      height: 23.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26.92.r),
                        gradient: const LinearGradient(
                          colors: [kPrebidGradientStart, kPrebidGradientEnd],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Text(
                        'Prebid',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: 12.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------------------
// Unprized / Prized status pill.
// ----------------------------------------------------------------------
class _StatusBadge extends StatelessWidget {
  final bool isPrized;
  const _StatusBadge({required this.isPrized});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.86.w, vertical: 3.55.h),
      decoration: BoxDecoration(
        color: kBadgeBgColor,
        borderRadius: BorderRadius.circular(8862.75.r), // fully pill-shaped
        border: Border.all(
          color: kBadgeDotColor.withValues(alpha: 0.15),
          width: 0.89,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: kBadgeDotColor,
            ),
          ),
          SizedBox(width: 5.32.w),
          Text(
            isPrized ? 'Prized' : 'Unprized',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 10.64.sp,
              height: 14.18 / 10.64,
              color: kBadgeTextColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------------------
// Icon + label + value row used twice inside the cream box.
// ----------------------------------------------------------------------
class _InfoRow extends StatelessWidget {
  final String iconAsset;
  final String label;
  final String value;

  const _InfoRow({
    required this.iconAsset,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(iconAsset, width: 22.sp, height: 22.sp),
        SizedBox(width: 12.w),
        SizedBox(
          width: 130.w,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              fontSize: 13.sp,
              color: kDateLabelColor,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: 13.sp,
              color: kDateValueColor,
            ),
          ),
        ),
      ],
    );
  }
}
