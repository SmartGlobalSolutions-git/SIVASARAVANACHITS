import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'surety_form.dart' as surety_form;

const Color kScreenBg = Color(0xFFF7F7F7);
const Color kCardBorder = Color(0xFFD1FAE5);
const Color kHeaderGreen = Color(0xFF018F46);
const Color kGroupCodeYellow = Color(0xFFFACC15);
const Color kCustomerPillColor = Color(0xFF3B5BDB);
const Color kRowLabelColor = Color(0xFF4B5563);
const Color kRowValueGreen = Color(0xFF018F46);
const Color kRowIconBg = Color(0xFFE6F6EC);

// ----------------------------------------------------------------------
// DATA
// ----------------------------------------------------------------------
class _SuretyGroup {
  final String groupCode;
  final String chitValue;
  final String startEndDate;
  final String runningBalance;
  final bool isCustomer;

  const _SuretyGroup({
    required this.groupCode,
    required this.chitValue,
    required this.startEndDate,
    required this.runningBalance,
    this.isCustomer = true,
  });
}

const List<_SuretyGroup> _groups = [
  _SuretyGroup(
    groupCode: '10-L',
    chitValue: '10,00,000',
    startEndDate: '10 Jan 26 - 10 Dec 26',
    runningBalance: '5,00,000',
  ),
  _SuretyGroup(
    groupCode: '10-L',
    chitValue: '10,00,000',
    startEndDate: '10 Jan 26 - 10 Dec 26',
    runningBalance: '5,00,000',
  ),
];

// ----------------------------------------------------------------------
// SCREEN
// ----------------------------------------------------------------------
class SuretyScreen extends StatelessWidget {
  const SuretyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScreenBg,
      appBar: _buildAppBar(context),
      body: ListView.separated(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
        itemCount: _groups.length,
        separatorBuilder: (_, __) => SizedBox(height: 16.h),
        itemBuilder: (context, index) => SuretyCard(
          data: _groups[index],
          onSuretyTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const surety_form.SuretyScreen(),
              ),
            );
          },
        ),
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
        icon: Icon(Icons.arrow_back, color: Colors.black, size: 20.sp),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Surety',
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
          fontSize: 16.sp,
          color: Colors.black,
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 8.w),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            border: Border.all(color: const Color(0xFF9B9B9B), width: 0.6),
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
                  color: kHeaderGreen,
                ),
              ),
            ],
          ),
        ),
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
class SuretyCard extends StatelessWidget {
  final _SuretyGroup data;
  final VoidCallback onSuretyTap;
  const SuretyCard({super.key, required this.data, required this.onSuretyTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 345,
      height: 240,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: kHeaderGreen, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 8.h),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _InfoRow(
                    iconAsset: 'assets/surety/chit.png',
                    label: 'Chit Value',
                    value: data.chitValue,
                    valueBold: true,
                  ),
                  _InfoRow(
                    iconAsset: 'assets/surety/surety_date.png',
                    label: 'Start-End Date',
                    value: data.startEndDate,
                    valueBold: false,
                  ),
                  _InfoRow(
                    iconAsset: 'assets/surety/balance.png',
                    label: 'Running Balance',
                    value: data.runningBalance,
                    valueBold: true,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 3.h, 16.w, 18.h),
            child: Center(
              child: GestureDetector(
                onTap: onSuretyTap,
                child: Container(
                  width: 120.w,
                  height: 30.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: kHeaderGreen,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Text(
                    'Surety',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                      height: 1.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 38.h,
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: 168 / 328,
            child: Container(
              decoration: BoxDecoration(
                color: kHeaderGreen,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(40.r),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 2.h, 16.w, 0),
            child: Row(
              children: [
                Container(
                  width: 30.sp,
                  height: 30.sp,
                  child: Image.asset(
                    'assets/surety/surety_group.png',
                    width: 30,
                    height: 30,
                  ),
                ),
                SizedBox(width: 8.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Group Detail',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      data.groupCode,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                        color: kGroupCodeYellow,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                if (data.isCustomer)
                  Container(
                    margin: EdgeInsets.only(right: 4.w),
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.r),
                      border: Border.all(color: kCustomerPillColor, width: 1),
                    ),
                    child: Text(
                      'Customer',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                        color: kCustomerPillColor,
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
// One icon + label + value row.
// ----------------------------------------------------------------------
class _InfoRow extends StatelessWidget {
  final String iconAsset;
  final String label;
  final String value;
  final bool valueBold;

  const _InfoRow({
    required this.iconAsset,
    required this.label,
    required this.value,
    required this.valueBold,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Row(
        children: [
          Container(width: 23.sp, height: 25.sp, child: Image.asset(iconAsset)),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 12.41.sp,
                color: kRowLabelColor,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: valueBold ? FontWeight.w700 : FontWeight.w600,
              fontSize: valueBold ? 14.18.sp : 12.41.sp,
              color: kRowValueGreen,
            ),
          ),
        ],
      ),
    );
  }
}
