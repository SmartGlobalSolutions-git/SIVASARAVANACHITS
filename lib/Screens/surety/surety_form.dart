import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// ---------------------------------------------------------------------
/// Surety Screen — matches Figma design (colors, sizes, radii, spacing)
/// ---------------------------------------------------------------------
class SuretyScreen extends StatefulWidget {
  const SuretyScreen({super.key});

  @override
  State<SuretyScreen> createState() => _SuretyScreenState();
}

class _SuretyScreenState extends State<SuretyScreen> {
  // ---- Figma colors -----------------------------------------------------
  static const Color kGreen = Color(0xFF018F46);
  static const Color kBorder = Color(0xFFE3E2E2);
  static const Color kLabel = Color(0xFF1B1C1C);
  static const Color kSubText = Color(0xFF414752);
  static const Color kPlaceholder = Color(0xFF717783);
  static const Color kScreenBg = Color(0xFFF7F7F7);
  static const Color kRed = Color(0xFFE53935);

  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  final _aadharCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _remarksCtrl = TextEditingController();

  DateTime? _selectedDob;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _dobCtrl.dispose();
    _aadharCtrl.dispose();
    _addressCtrl.dispose();
    _remarksCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 25, now.month, now.day),
      firstDate: DateTime(1950),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: kGreen),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDob = picked;
        _dobCtrl.text =
        '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      // TODO: hook up to your save/API logic here.
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        ),
        builder: (context) => Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 40.h, bottom: 60.h, left: 20.w, right: 20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/surety/tick_surety.png',
                width: 80.w,
                height: 80.w,
              ),
              SizedBox(height: 24.h),
              Text(
                'Submitted Successfully',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 24.sp,
                  height: 1.0,
                  color: const Color(0xFF018F46),
                ),
              ),
            ],
          ),
        ),
      );

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScreenBg,
      appBar: _buildAppBar(context),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Enter the surety person's details below.",
                      style: TextStyle(
                        fontSize: 15,
                        color: kSubText,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(color: kBorder, width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _fieldLabel('Full Name', required: true),
                          const SizedBox(height: 8),
                          _buildTextField(
                            controller: _nameCtrl,
                            hint: 'Enter full name',
                            icon: Icons.person_outline,
                            keyboardType: TextInputType.name,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Full name is required';
                              }
                              if (v.trim().length < 3) {
                                return 'Enter a valid name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          _fieldLabel('Phone Number', required: true),
                          const SizedBox(height: 8),
                          _buildTextField(
                            controller: _phoneCtrl,
                            hint: 'Enter phone number',
                            icon: Icons.call_outlined,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Phone number is required';
                              }
                              if (v.trim().length != 10) {
                                return 'Enter a valid 10-digit number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          _fieldLabel('Date of Birth', required: true),
                          const SizedBox(height: 8),
                          _buildTextField(
                            controller: _dobCtrl,
                            hint: 'Select date of birth',
                            icon: Icons.calendar_today_outlined,
                            trailingIcon: Icons.calendar_month_outlined,
                            readOnly: true,
                            onTap: _pickDob,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Date of birth is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          _fieldLabel('Aadhar Number', required: true),
                          const SizedBox(height: 8),
                          _buildTextField(
                            controller: _aadharCtrl,
                            hint: 'Enter Aadhar number',
                            icon: Icons.badge_outlined,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(12),
                            ],
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Aadhar number is required';
                              }
                              if (v.trim().length != 12) {
                                return 'Enter a valid 12-digit Aadhar number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          _fieldLabel('Address', required: true),
                          const SizedBox(height: 8),
                          _buildTextField(
                            controller: _addressCtrl,
                            hint: 'Enter address',
                            icon: Icons.location_on_outlined,
                            maxLines: 3,
                            minLines: 3,
                            keyboardType: TextInputType.multiline,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Address is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: const [
                              Text(
                                'Remarks ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: kLabel,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                '(Optional)',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: kPlaceholder,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _buildTextField(
                            controller: _remarksCtrl,
                            hint: 'Enter remarks',
                            icon: Icons.description_outlined,
                            maxLines: 3,
                            minLines: 3,
                            keyboardType: TextInputType.multiline,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  // ---- AppBar -------------------------------------------------------------
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      titleSpacing: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black, size: 20.sp),
        onPressed: () => Navigator.of(context).maybePop(),
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
                  color: kGreen,
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

  // ---- Bottom action bar ----------------------------------------------
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: kScreenBg,
        border: Border(top: BorderSide(color: kBorder.withOpacity(0.5), width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).maybePop(),
              style: OutlinedButton.styleFrom(
                foregroundColor: kGreen,
                side: const BorderSide(color: kGreen, width: 1),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(72),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: _onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: kGreen,
                foregroundColor: Colors.white,
                elevation: 1,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(72),
                ),
              ),
              child: const Text(
                'Save Surety',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---- Reusable label ---------------------------------------------------
  Widget _fieldLabel(String text, {bool required = false}) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 16,
          color: kLabel,
          fontWeight: FontWeight.w400,
        ),
        children: [
          TextSpan(text: text),
          if (required)
            const TextSpan(text: ' *', style: TextStyle(color: kRed)),
        ],
      ),
    );
  }

  // ---- Reusable text field -----------------------------------------------
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    IconData? trailingIcon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    bool readOnly = false,
    VoidCallback? onTap,
    int maxLines = 1,
    int? minLines,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      readOnly: readOnly,
      onTap: onTap,
      maxLines: maxLines,
      minLines: minLines,
      style: const TextStyle(fontSize: 15, color: kLabel),
      cursorColor: kGreen,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 15, color: kPlaceholder),
        prefixIcon: maxLines == 1
            ? Icon(icon, color: kGreen, size: 20)
            : Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: Icon(icon, color: kGreen, size: 20),
        ),
        suffixIcon: trailingIcon != null
            ? Icon(trailingIcon, color: kGreen, size: 20)
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: kBorder, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: kBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: kGreen, width: 1.2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: kRed, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: kRed, width: 1.2),
        ),
      ),
    );
  }
}