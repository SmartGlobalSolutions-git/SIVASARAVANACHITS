import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siva_saravana/widgets/chatbox_widget.dart';

class SubscriptionPlanScreen extends StatelessWidget {
  final String investmentAmount;
  final String durationMonths;

  const SubscriptionPlanScreen({
    super.key,
    this.investmentAmount = '1,00,000',
    this.durationMonths = '20',
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double scaleW = screenSize.width / 360.0;
    final double scaleH = screenSize.height / 800.0;

    final List<Map<String, String>> planRows = [
      {'month': '1', 'sub': '5,000', 'div': '0', 'bid': '0', 'prize': '0'},
      {'month': '2', 'sub': '5,000', 'div': '0', 'bid': '30,000', 'prize': '70,000'},
      {'month': '3', 'sub': '3,750', 'div': '1,250', 'bid': '30,000', 'prize': '70,000'},
      {'month': '4', 'sub': '3,750', 'div': '1,250', 'bid': '28,000', 'prize': '72,000'},
      {'month': '5', 'sub': '3,850', 'div': '1,150', 'bid': '25,000', 'prize': '75,000'},
      {'month': '6', 'sub': '4,000', 'div': '1,000', 'bid': '24,500', 'prize': '75,000'},
      {'month': '7', 'sub': '4,025', 'div': '975', 'bid': '24,000', 'prize': '76,000'},
      {'month': '8', 'sub': '4,050', 'div': '950', 'bid': '22,500', 'prize': '77,500'},
      {'month': '9', 'sub': '4,125', 'div': '875', 'bid': '21,000', 'prize': '79,000'},
      {'month': '10', 'sub': '4,200', 'div': '800', 'bid': '20,000', 'prize': '80,000'},
      {'month': '11', 'sub': '4,250', 'div': '750', 'bid': '19,000', 'prize': '81,000'},
      {'month': '12', 'sub': '4,300', 'div': '700', 'bid': '18,000', 'prize': '82,000'},
      {'month': '13', 'sub': '4,350', 'div': '650', 'bid': '17,000', 'prize': '83,000'},
      {'month': '14', 'sub': '4,400', 'div': '600', 'bid': '16,000', 'prize': '84,000'},
      {'month': '15', 'sub': '4,450', 'div': '550', 'bid': '15,000', 'prize': '85,000'},
      {'month': '16', 'sub': '4,500', 'div': '500', 'bid': '13,000', 'prize': '87,000'},
      {'month': '17', 'sub': '4,600', 'div': '400', 'bid': '11,000', 'prize': '89,000'},
      {'month': '18', 'sub': '4,700', 'div': '300', 'bid': '9,000', 'prize': '91,000'},
      {'month': '19', 'sub': '4,800', 'div': '200', 'bid': '7,000', 'prize': '93,000'},
      {'month': '20', 'sub': '4,900', 'div': '100', 'bid': '5,000', 'prize': '95,000'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Stack(
          children: [
            // Background Gradient with exact green glow behind header & upper table
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFFFFFFF),
                      Color(0xFFF2FAF5),
                      Color(0xFFD4F6E5),
                      Color(0xFFBCECD2),
                      Color(0xFFDCF6E8),
                      Color(0xFFF4FBF7),
                      Color(0xFFFFFFFF),
                    ],
                    stops: [0.0, 0.08, 0.20, 0.35, 0.55, 0.75, 1.0],
                  ),
                ),
              ),
            ),

            // Main Content Column (Non-scrollable, uses Expanded)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Custom AppBar (transparent, responsive, zero-overflow)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 6 * scaleW.clamp(0.85, 1.2),
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.arrow_back, color: Colors.black87, size: 22),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 4),
                      // Title: Subscription Plan (Expanded to prevent overflow)
                      Expanded(
                        child: Text(
                          'Subscription Plan',
                          style: GoogleFonts.inter(
                            fontSize: 16 * scaleW.clamp(0.85, 1.2),
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            letterSpacing: 0,
                            height: 1.0,
                            color: const Color(0xFF1E2638),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                      const SizedBox(width: 4),
                      // Need Help ? button
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        height: 32 * scaleH.clamp(0.85, 1.2),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.95),
                          border: Border.all(color: const Color(0xFF8E8E93), width: 0.8),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'asset/images/help_operator.png',
                              width: 14 * scaleW.clamp(0.85, 1.2),
                              height: 14 * scaleH.clamp(0.85, 1.2),
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.headset_mic, size: 14, color: Color(0xFF018F46)),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Need Help ?',
                              style: GoogleFonts.inter(
                                fontSize: 10.5 * scaleW.clamp(0.85, 1.1),
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF018F46),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                      // Notification Icon
                      IconButton(
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(),
                        icon: Image.asset(
                          'asset/images/notification.png',
                          width: 22 * scaleW.clamp(0.85, 1.2),
                          height: 22 * scaleH.clamp(0.85, 1.2),
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.notifications_none_outlined, color: Colors.black87, size: 22),
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                // Siva Saravana Layout Block (logo: width: 107, height: 27.9846, above ₹ 1,00,000)
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 4 * scaleH.clamp(0.85, 1.2),
                      bottom: 4 * scaleH.clamp(0.85, 1.2),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'asset/images/sivasaravana_logo.png',
                          width: 107 * scaleW.clamp(0.85, 1.2),
                          height: 27.9846 * scaleH.clamp(0.85, 1.2),
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const SizedBox.shrink(),
                        ),
                        SizedBox(height: 2 * scaleH.clamp(0.85, 1.2)),
                        Text(
                          '₹ $investmentAmount',
                          style: GoogleFonts.inter(
                            fontSize: 30 * scaleW.clamp(0.85, 1.2),
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF018F46),
                            letterSpacing: -0.5,
                            height: 1.15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 4 * scaleH.clamp(0.85, 1.2)),

                // Table Container Card (Expanded, non-scrollable, darker lines + vertical grid)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12 * scaleW.clamp(0.85, 1.2),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF9E9E9E), width: 1.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          // Table Header
                          Container(
                            color: const Color(0xFF018F46),
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                _buildHeaderCell('Month', flex: 10, scale: scaleW.clamp(0.85, 1.2), hasRightBorder: true),
                                _buildHeaderCell('Subscription\n(₹)', flex: 22, scale: scaleW.clamp(0.85, 1.2), hasRightBorder: true),
                                _buildHeaderCell('Dividend\n(₹)', flex: 18, scale: scaleW.clamp(0.85, 1.2), hasRightBorder: true),
                                _buildHeaderCell('Bid Value\n(₹)', flex: 18, scale: scaleW.clamp(0.85, 1.2), hasRightBorder: true),
                                _buildHeaderCell('Prize Amount\n(₹)', flex: 22, scale: scaleW.clamp(0.85, 1.2), hasRightBorder: false),
                              ],
                            ),
                          ),

                          // Table Data Rows (with darker divider lines and vertical column lines)
                          Expanded(
                            child: Column(
                              children: planRows.map((item) {
                                return Expanded(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Color(0xFFBDBDBD), // Darker crisp divider line
                                          width: 0.9,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        _buildDataCell(item['month']!, flex: 10, isMonth: true, scale: scaleW.clamp(0.85, 1.2), hasRightBorder: true),
                                        _buildDataCell(item['sub']!, flex: 22, scale: scaleW.clamp(0.85, 1.2), hasRightBorder: true),
                                        _buildDataCell(item['div']!, flex: 18, scale: scaleW.clamp(0.85, 1.2), hasRightBorder: true),
                                        _buildDataCell(item['bid']!, flex: 18, scale: scaleW.clamp(0.85, 1.2), hasRightBorder: true),
                                        _buildDataCell(item['prize']!, flex: 22, scale: scaleW.clamp(0.85, 1.2), hasRightBorder: false),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),

                          // Total Summary Row
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            decoration: const BoxDecoration(
                              color: Color(0xFFEAF8F1),
                              border: Border(
                                top: BorderSide(
                                  color: Color(0xFF9E9E9E), // Darker top border for Total row
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                _buildSummaryCell('Total', flex: 10, isLabel: true, scale: scaleW.clamp(0.85, 1.2), hasRightBorder: true),
                                _buildSummaryCell('87,000', flex: 22, scale: scaleW.clamp(0.85, 1.2), hasRightBorder: true),
                                _buildSummaryCell('13,000', flex: 18, scale: scaleW.clamp(0.85, 1.2), hasRightBorder: true),
                                _buildSummaryCell('–', flex: 18, scale: scaleW.clamp(0.85, 1.2), hasRightBorder: true),
                                _buildSummaryCell('95,000', flex: 22, scale: scaleW.clamp(0.85, 1.2), hasRightBorder: false),
                              ],
                            ),
                          ),

                          // Disclaimer Note
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            color: const Color(0xFFF9FDFB),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF018F46),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.location_on,
                                    size: 8,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    'This is an indicative plan. Values may vary based on actual chit group rules.',
                                    style: GoogleFonts.inriaSans(
                                      fontSize: 8.5 * scaleW.clamp(0.85, 1.2),
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF666666),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Spacing above Available Slot
                SizedBox(height: 12 * scaleH.clamp(0.85, 1.2)),

                // Available Slot - 14 Text (width: 137, height: 12, left: 16px, opacity: 1)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16 * scaleW.clamp(0.85, 1.2),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 137 * scaleW.clamp(0.85, 1.2),
                      height: 12 * scaleH.clamp(0.85, 1.2),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Available Slot - 14',
                          style: GoogleFonts.inter(
                            fontSize: 12 * scaleW.clamp(0.85, 1.2),
                            fontWeight: FontWeight.w500,
                            color: const Color(0xB2000DFF),
                            letterSpacing: 0,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Spacing below Available Slot
                SizedBox(height: 12 * scaleH.clamp(0.85, 1.2)),

                // Bottom Bar with Enquire Now Button (width: 316, height: 36, top: 17px, left: 22px, border-radius: 140px)
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(
                    22 * scaleW.clamp(0.85, 1.2),
                    17 * scaleH.clamp(0.85, 1.2),
                    22 * scaleW.clamp(0.85, 1.2),
                    17 * scaleH.clamp(0.85, 1.2),
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 316 * scaleW.clamp(0.85, 1.2),
                      height: 36 * scaleH.clamp(0.85, 1.2),
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Enquiry submitted successfully!'),
                              backgroundColor: Color(0xFF018F46),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF018F46),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(140),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: Text(
                          'Enquire Now',
                          style: GoogleFonts.inter(
                            fontSize: 14 * scaleW.clamp(0.85, 1.2),
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Floating Robot Icon (Sitting at the bottom right of the table area)
            const ChatboxWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCell(
    String text, {
    required int flex,
    required double scale,
    bool hasRightBorder = false,
  }) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          border: hasRightBorder
              ? const Border(
                  right: BorderSide(
                    color: Color(0x33FFFFFF), // Subtle white vertical line
                    width: 0.8,
                  ),
                )
              : null,
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 9.5 * scale,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            height: 1.1,
          ),
        ),
      ),
    );
  }

  Widget _buildDataCell(
    String text, {
    required int flex,
    bool isMonth = false,
    required double scale,
    bool hasRightBorder = false,
  }) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          border: hasRightBorder
              ? const Border(
                  right: BorderSide(
                    color: Color(0xFFE5E5E5), // Subtle vertical column line
                    width: 0.8,
                  ),
                )
              : null,
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.inriaSans(
            fontSize: 11 * scale,
            fontWeight: isMonth ? FontWeight.w700 : FontWeight.w400,
            color: isMonth ? const Color(0xFF018F46) : const Color(0xFF222222),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCell(
    String text, {
    required int flex,
    bool isLabel = false,
    required double scale,
    bool hasRightBorder = false,
  }) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          border: hasRightBorder
              ? const Border(
                  right: BorderSide(
                    color: Color(0xFFD4EAE0), // Vertical line inside Total row
                    width: 0.8,
                  ),
                )
              : null,
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.inriaSans(
            fontSize: 11 * scale,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF018F46),
          ),
        ),
      ),
    );
  }
}
