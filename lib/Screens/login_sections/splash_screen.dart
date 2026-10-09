import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart' as constants;
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../../services/shared_prefs_helper.dart';
import 'WelcomeScreen.dart';
import '../main_wrapper.dart';
import '../first_time_main_wrapper.dart';
import '../../services/profile_view_api.dart';
import '../../services/chit_scheme_api.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _scaleAnimation;

  late AnimationController _textController;
  late Animation<Offset> _slideAnimation;

  bool _showUpdateUI = false;
  String _downloadUrl = '';
  String _updateMessage = '';

  @override
  void initState() {
    super.initState();

    // Logo pulsing animation (zoom out and zoom in)
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.6, end: 0.8).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    // Text slide animation (from bottom to center)
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 6.0), // Start lower from the bottom
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutBack, // Gives a nice subtle bounce effect when reaching the center
    ));

    // Start text animation
    _textController.forward();

    // Start initialization and navigate
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final minimumDelay = Future.delayed(const Duration(seconds: 3));

    try {
      // Fetch and save Device ID
      String deviceId = 'unknown';
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? 'unknown';
      }
      await SharedPrefsHelper.saveDeviceId(deviceId);

      // Fetch and save Location
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }
        if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
          Position position = await Geolocator.getCurrentPosition();
          await SharedPrefsHelper.saveLocation(
            position.latitude.toString(),
            position.longitude.toString(),
          );
        } else {
          await SharedPrefsHelper.saveLocation('123', '123');
        }
      } else {
        await SharedPrefsHelper.saveLocation('123', '123');
      }
    } catch (e) {
      debugPrint('Error during initialization: $e');
      await SharedPrefsHelper.saveLocation('123', '123');
    }

    final token = await SharedPrefsHelper.getToken();
    final isNewUser = await SharedPrefsHelper.getIsNewUser();

    if (token != null && token.isNotEmpty) {
      final response = await ProfileViewApiService.fetchProfile();
      if (response != null && response['error'] == false) {
        final profile = response['profile'];
        if (profile != null && profile['name'] != null) {
          await SharedPrefsHelper.saveUserName(profile['name'].toString());
        }
      }
    }

    // Version Check
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;
      
      final versionResponse = await ChitSchemeApiService.checkVersion(currentVersion);
      if (versionResponse != null && versionResponse['error'] == false) {
        String latestVersion = versionResponse['latest_version'] ?? '';
        bool updateRequired = versionResponse['update_required'] ?? false;
  
        if (currentVersion != latestVersion || updateRequired) {
          if (mounted) {
            setState(() {
              _showUpdateUI = true;
              _downloadUrl = versionResponse['download_url'] ?? '';
              _updateMessage = versionResponse['message'] ?? 'Please update the app to continue.';
            });
          }
          return; // Halt further navigation
        }
      }
    } catch (e) {
      debugPrint('Version check failed: $e');
    }

    await minimumDelay;

    if (mounted) {
      if (token != null && token.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => isNewUser ? const FirstTimeMainWrapper() : const MainWrapper(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
      }
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constants.AppColors.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Logo
            ScaleTransition(
              scale: _scaleAnimation,
              child: Image.asset(
                'assets/login_images/splash.png',
                width: 120.w, // Adjust size as appropriate for splash
                height: 120.w,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 20.h,),
            
            // Animated Text sliding from bottom
            SlideTransition(
              position: _slideAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'SIVA SARAVANA',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 27.61.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.0,
                      letterSpacing: 0,
                    ),
                  ),
                  SizedBox(height: 10.h), // Adjust this value to increase/decrease the space
                  Text(
                    'CHITS ( P) LTD',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 16.63.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.0,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
            ),
            if (_showUpdateUI)
              Padding(
                padding: EdgeInsets.only(top: 40.h),
                child: Column(
                  children: [
                    Text(
                      _updateMessage,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () async {
                        if (_downloadUrl.isNotEmpty) {
                          final uri = Uri.parse(_downloadUrl);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: constants.AppColors.primaryColor,
                        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                      ),
                      child: Text(
                        'Update Now',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
