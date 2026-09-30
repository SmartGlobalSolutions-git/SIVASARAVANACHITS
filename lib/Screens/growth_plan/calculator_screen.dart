import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siva_saravana/widgets/chatbox_widget.dart';
import 'subscription_plan_screen.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _selectedScheme = 'Smart Savings Scheme';
  final TextEditingController _investmentController =
      TextEditingController(text: '1,00,000');
  final TextEditingController _emiController = TextEditingController();
  String _selectedNoOfEmis = '20';
  String _selectedNoOfChitMembers = '20';

  final List<String> _emiOptions = ['10', '12', '15', '20', '25', '30', '40', '50'];
  final List<String> _chitMemberOptions = ['10', '12', '15', '20', '25', '30', '40', '50'];

  @override
  void dispose() {
    _investmentController.dispose();
    _emiController.dispose();
    super.dispose();
  }

  void _navigateToSubscriptionPlan() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubscriptionPlanScreen(
          investmentAmount: _investmentController.text.trim().isEmpty
              ? '1,00,000'
              : _investmentController.text.trim(),
          durationMonths: _selectedNoOfEmis,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double scaleW = screenSize.width / 360.0;
    final double scaleH = screenSize.height / 800.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 56 * scaleH.clamp(0.85, 1.2),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Calculator',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 16 * scaleW.clamp(0.85, 1.2),
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
            letterSpacing: 0,
            height: 1.0,
            color: const Color(0xFF1E2638),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Green Rectangle Section (width: 392, height: 508, left: -19px, opacity: 1)
                SizedBox(
                  width: double.infinity,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Solid green base background to prevent any top white artifacts
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: 460 * scaleH,
                        child: Container(
                          color: const Color(0xFF018F46),
                        ),
                      ),

                      // Green Rectangle Asset Background (providing bottom torn paper edge)
                      Positioned(
                        left: -19 * scaleW,
                        top: -24 * scaleH,
                        width: 392 * scaleW,
                        height: 532 * scaleH,
                        child: Image.asset(
                          'assets/images/green_rectangle.png',
                          fit: BoxFit.fill,
                          opacity: const AlwaysStoppedAnimation(1.0),
                          errorBuilder: (context, error, stackTrace) =>
                              Container(color: const Color(0xFF018F46)),
                        ),
                      ),

                      // Solid green header cap for clean seam with AppBar
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: 48 * scaleH,
                        child: Container(
                          color: const Color(0xFF018F46),
                        ),
                      ),

                      // Content inside the Green Rectangle
                      Padding(
                        padding: EdgeInsets.only(
                          left: 17 * scaleW.clamp(0.85, 1.2),
                          right: 17 * scaleW.clamp(0.85, 1.2),
                          top: 16 * scaleH.clamp(0.85, 1.2),
                          bottom: 28 * scaleH.clamp(0.85, 1.2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Fund Calculator Title (Inter 600, 20px)
                            Text(
                              'Fund Calculator',
                              style: GoogleFonts.inter(
                                fontSize: 20 * scaleW.clamp(0.85, 1.2),
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 0,
                                height: 1.0,
                              ),
                            ),
                            SizedBox(height: 14 * scaleH.clamp(0.85, 1.2)),

                            // Radio Selection
                            Wrap(
                              spacing: 12 * scaleW.clamp(0.85, 1.1),
                              runSpacing: 8 * scaleH.clamp(0.85, 1.2),
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                _buildRadioButton('Smart Savings Scheme', scaleW),
                                _buildRadioButton('Flexi Cash', scaleW),
                              ],
                            ),
                            SizedBox(height: 8 * scaleH.clamp(0.85, 1.2)),
                            _buildRadioButton('Quick Cash', scaleW),
                            SizedBox(height: 14 * scaleH.clamp(0.85, 1.2)),

                            // White Box (width: 328, height: 318, top: 203px, left: 17px, border: 1px solid #E9E9E9)
                            Center(
                              child: Container(
                                width: 328 * scaleW.clamp(0.85, 1.2),
                                constraints: BoxConstraints(
                                  minHeight: 318 * scaleH.clamp(0.85, 1.2),
                                ),
                                padding: EdgeInsets.fromLTRB(
                                  16 * scaleW.clamp(0.85, 1.2),
                                  14 * scaleH.clamp(0.85, 1.2),
                                  16 * scaleW.clamp(0.85, 1.2),
                                  14 * scaleH.clamp(0.85, 1.2),
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: const Color(0xFFE9E9E9),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    // Plant Image Asset Watermark
                                    Positioned(
                                      right: -10,
                                      bottom: 10,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(83.97),
                                        child: Image.asset(
                                          'assets/images/plant.png',
                                          width: 135 * scaleW.clamp(0.9, 1.25),
                                          height: 220 * scaleH.clamp(0.85, 1.2),
                                          fit: BoxFit.contain,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const SizedBox.shrink(),
                                        ),
                                      ),
                                    ),

                                    // Form Elements inside white box
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // 1. Investment Amount ₹
                                        Text(
                                          'Investment Amount ₹',
                                          style: GoogleFonts.inriaSans(
                                            fontSize: 14 * scaleW.clamp(0.85, 1.2),
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF018F46),
                                          ),
                                        ),
                                        SizedBox(height: 4 * scaleH.clamp(0.85, 1.2)),
                                        _buildTextField(
                                          controller: _investmentController,
                                          hintText: 'ex: 1,00,000',
                                          keyboardType: TextInputType.number,
                                          scaleW: scaleW,
                                          scaleH: scaleH,
                                        ),
                                        SizedBox(height: 3 * scaleH.clamp(0.85, 1.2)),
                                        Text(
                                          'Enter values in multiples of Lakhs (min-1 Lakh to max-1 Crore)',
                                          style: GoogleFonts.inriaSans(
                                            fontSize: 9.5 * scaleW.clamp(0.85, 1.2),
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xFF222222),
                                          ),
                                        ),
                                        SizedBox(height: 6 * scaleH.clamp(0.85, 1.2)),

                                        // Centered "or"
                                        Center(
                                          child: Text(
                                            'or',
                                            style: GoogleFonts.inriaSans(
                                              fontSize: 13 * scaleW.clamp(0.85, 1.2),
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xFF333333),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 4 * scaleH.clamp(0.85, 1.2)),

                                        // 2. EMI Amount ₹
                                        Text(
                                          'EMI Amount ₹',
                                          style: GoogleFonts.inriaSans(
                                            fontSize: 14 * scaleW.clamp(0.85, 1.2),
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF018F46),
                                          ),
                                        ),
                                        SizedBox(height: 4 * scaleH.clamp(0.85, 1.2)),
                                        _buildTextField(
                                          controller: _emiController,
                                          hintText: 'ex: 1,00,000',
                                          keyboardType: TextInputType.number,
                                          scaleW: scaleW,
                                          scaleH: scaleH,
                                        ),
                                        SizedBox(height: 3 * scaleH.clamp(0.85, 1.2)),
                                        Text(
                                          'Enter values in multiples of 5000 (min-5000 to max-5Lakhs)',
                                          style: GoogleFonts.inriaSans(
                                            fontSize: 9.5 * scaleW.clamp(0.85, 1.2),
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xFF222222),
                                          ),
                                        ),
                                        SizedBox(height: 12 * scaleH.clamp(0.85, 1.2)),

                                        // 3. Row: No Of EMI's & No Of Chit Members (Dropdowns)
                                        Row(
                                          children: [
                                            // No Of EMI's Dropdown
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "No Of EMI's",
                                                    style: GoogleFonts.inriaSans(
                                                      fontSize: 13.5 *
                                                          scaleW.clamp(0.85, 1.2),
                                                      fontWeight: FontWeight.w600,
                                                      color: const Color(0xFF018F46),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: 4 *
                                                          scaleH.clamp(0.85, 1.2)),
                                                  _buildDropdownField(
                                                    value: _selectedNoOfEmis,
                                                    items: _emiOptions,
                                                    onChanged: (val) {
                                                      if (val != null) {
                                                        setState(() {
                                                          _selectedNoOfEmis = val;
                                                        });
                                                      }
                                                    },
                                                    scaleW: scaleW,
                                                    scaleH: scaleH,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                                width: 14 * scaleW.clamp(0.85, 1.2)),
                                            // No Of Chit Members Dropdown
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'No Of Chit Members',
                                                    style: GoogleFonts.inriaSans(
                                                      fontSize: 13.5 *
                                                          scaleW.clamp(0.85, 1.2),
                                                      fontWeight: FontWeight.w600,
                                                      color: const Color(0xFF018F46),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: 4 *
                                                          scaleH.clamp(0.85, 1.2)),
                                                  _buildDropdownField(
                                                    value: _selectedNoOfChitMembers,
                                                    items: _chitMemberOptions,
                                                    onChanged: (val) {
                                                      if (val != null) {
                                                        setState(() {
                                                          _selectedNoOfChitMembers =
                                                              val;
                                                        });
                                                      }
                                                    },
                                                    scaleW: scaleW,
                                                    scaleH: scaleH,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                            height: 14 * scaleH.clamp(0.85, 1.2)),

                                        // 4. Row: Note & Submit Button
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            // Note text
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    'Note:',
                                                    style: GoogleFonts.inriaSans(
                                                      fontSize: 10.5 *
                                                          scaleW.clamp(0.85, 1.2),
                                                      fontWeight: FontWeight.w600,
                                                      color: const Color(0xFF757575),
                                                    ),
                                                  ),
                                                  Text(
                                                    'Enter Values In Multiples Of\nLakhs In Investment',
                                                    style: GoogleFonts.inriaSans(
                                                      fontSize: 10 *
                                                          scaleW.clamp(0.85, 1.2),
                                                      fontWeight: FontWeight.w400,
                                                      color: const Color(0xFF757575),
                                                      height: 1.2,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                                width: 8 * scaleW.clamp(0.85, 1.2)),
                                            // Submit Button
                                            SizedBox(
                                              width: 125 * scaleW.clamp(0.9, 1.2),
                                              height: 42 * scaleH.clamp(0.85, 1.2),
                                              child: ElevatedButton(
                                                onPressed:
                                                    _navigateToSubscriptionPlan,
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0xFF018F46),
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(21),
                                                  ),
                                                  padding: EdgeInsets.zero,
                                                ),
                                                child: Text(
                                                  'Submit',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 16 *
                                                        scaleW.clamp(0.85, 1.2),
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),

          // Floating Robot Icon (fully visible on bottom right matching Subscription Plan screen)
          const ChatboxWidget(),
        ],
      ),
    );
  }

  Widget _buildRadioButton(String title, double scaleW) {
    final bool isSelected = _selectedScheme == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedScheme = title;
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16 * scaleW.clamp(0.85, 1.2),
            height: 16 * scaleW.clamp(0.85, 1.2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? Colors.transparent : Colors.white24,
              border: Border.all(
                color: isSelected ? Colors.white : Colors.white60,
                width: 2,
              ),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 6 * scaleW.clamp(0.85, 1.2),
                      height: 6 * scaleW.clamp(0.85, 1.2),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  )
                : null,
          ),
          SizedBox(width: 6 * scaleW.clamp(0.85, 1.1)),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 13.5 * scaleW.clamp(0.85, 1.1),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    required double scaleW,
    required double scaleH,
  }) {
    return Container(
      height: 38 * scaleH.clamp(0.85, 1.2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFE9E9E9),
          width: 1,
        ),
      ),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 10 * scaleW.clamp(0.85, 1.2)),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.inriaSans(
          fontSize: 14 * scaleW.clamp(0.85, 1.2),
          fontWeight: FontWeight.w400,
          color: const Color(0xFF333333),
        ),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          hintText: hintText,
          hintStyle: GoogleFonts.inriaSans(
            fontSize: 14 * scaleW.clamp(0.85, 1.2),
            fontWeight: FontWeight.w400,
            color: const Color(0xFFBDBDBD),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required double scaleW,
    required double scaleH,
  }) {
    return Container(
      height: 38 * scaleH.clamp(0.85, 1.2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFE9E9E9),
          width: 1,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10 * scaleW.clamp(0.85, 1.2)),
      alignment: Alignment.center,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Color(0xFF888888),
            size: 20,
          ),
          style: GoogleFonts.inriaSans(
            fontSize: 14 * scaleW.clamp(0.85, 1.2),
            fontWeight: FontWeight.w400,
            color: const Color(0xFF333333),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
