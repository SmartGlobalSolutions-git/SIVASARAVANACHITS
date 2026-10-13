import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';
import '../services/translation_service.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: TranslationService.currentLanguageNotifier,
      builder: (context, lang, _) {
        if (lang != 'Tamil') {
          return _buildNavBar(['Home', 'My Chits', 'Payments', 'Passbook']);
        }

        return FutureBuilder<List<String>>(
          future: Future.wait([
            TranslationService.translate('Home'),
            TranslationService.translate('My Chits'),
            TranslationService.translate('Payments'),
            TranslationService.translate('Passbook'),
          ]),
          initialData: [
            TranslationService.getCachedTranslation('Home') ?? 'Home',
            TranslationService.getCachedTranslation('My Chits') ?? 'My Chits',
            TranslationService.getCachedTranslation('Payments') ?? 'Payments',
            TranslationService.getCachedTranslation('Passbook') ?? 'Passbook',
          ],
          builder: (context, snapshot) {
            final labels =
                snapshot.data ?? ['Home', 'My Chits', 'Payments', 'Passbook'];
            return _buildNavBar(labels);
          },
        );
      },
    );
  }

  Widget _buildNavBar(List<String> labels) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: const Color(0x4D000000),
            width: 0.8.w,
          ),
        ),
      ),
      child: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: const Color(0xFF707B83),
        selectedFontSize: 12.sp,
        unselectedFontSize: 12.sp,
        iconSize: 24.w,
        currentIndex: currentIndex,
        onTap: onTap,
        items: [
          BottomNavigationBarItem(
            icon: const ImageIcon(AssetImage('assets/bottom_nav/home.png')),
            label: labels[0],
          ),
          BottomNavigationBarItem(
            icon: const ImageIcon(AssetImage('assets/bottom_nav/chit.png')),
            label: labels[1],
          ),
          BottomNavigationBarItem(
            icon: const ImageIcon(AssetImage('assets/bottom_nav/payment.png')),
            label: labels[2],
          ),
          BottomNavigationBarItem(
            icon: const ImageIcon(AssetImage('assets/bottom_nav/passbook.png')),
            label: labels[3],
          ),
        ],
      ),
    );
  }
}

