import 'package:flutter/material.dart';

/// AppColors is the centralized color management file for the application.
/// 
/// If client or branding color requirements change, update the hex codes
/// here to automatically update colors across the entire app.
class AppColors {
  AppColors._();

  // ===========================================================================
  // Brand & Primary Colors
  // ===========================================================================
  /// Primary brand color (Green accent used for branding, success states, etc.)
  static const Color primary = Color(0xFF0F8A4B);

  /// Light tint of primary color for highlights and active backgrounds
  static const Color primaryLight = Color(0xFFE8F5E9);

  /// Secondary brand accent
  static const Color accent = Color(0xFF00875A);

  // ===========================================================================
  // Sidebar & Navigation Drawer Colors
  // ===========================================================================
  /// Background of the sidebar / drawer sheet
  static const Color sidebarBackground = Color(0xFFFFFFFF);

  /// Light grey background for grouped menu cards (Profile-to-Statement, Settings, etc.)
  static const Color cardBackground = Color(0xFFF4F5F7);

  /// White background for circular icon badges inside cards
  static const Color iconCircleBackground = Color(0xFFFFFFFF);

  /// Color of menu item icons inside the cards
  static const Color iconColor = Color(0xFF22252A);

  /// Color for trailing chevron arrows ('>')
  static const Color chevronColor = Color(0xFF4A4E57);

  // ===========================================================================
  // User Header & "Need Help" Colors
  // ===========================================================================
  /// Background of user avatar circle
  static const Color avatarBackground = Color(0xFFFFFFFF);

  /// Border around user avatar
  static const Color avatarBorder = Color(0xFFE5E7EB);

  /// Default person icon inside avatar
  static const Color avatarIcon = Color(0xFF9CA3AF);

  /// Background for the "Need Help ?" button
  static const Color needHelpBackground = Color(0xFFFFFFFF);

  /// Border for the "Need Help ?" button
  static const Color needHelpBorder = Color(0xFFD1D5DB);

  /// Text color for "Need Help ?"
  static const Color needHelpText = Color(0xFF0F8A4B);

  /// Headset / Agent icon color in "Need Help ?"
  static const Color needHelpIcon = Color(0xFF1F2937);

  // ===========================================================================
  // Typography Colors
  // ===========================================================================
  /// Primary text color (User name, menu item titles)
  static const Color textPrimary = Color(0xFF1C1C1E);

  /// Secondary text color ("Hello" greeting, subtitle)
  static const Color textSecondary = Color(0xFF6B7280);

  /// Muted / disabled text color (App version, subtle hints)
  static const Color textMuted = Color(0xFF9CA3AF);

  // ===========================================================================
  // Settings Screen Specific Colors
  // ===========================================================================
  /// Background color for the Settings screen (#F3F3F5)
  static const Color settingsBackground = Color(0xFFF3F3F5);

  /// Section heading color (ACCOUNT, APP PREFERENCES, etc.) (#6B7280)
  static const Color settingsSectionHeading = Color(0xFF6B7280);

  /// Subheading / Item title color (Profile Information, Language, etc.) (#1A1C1C)
  static const Color settingsSubheading = Color(0xFF1A1C1C);

  /// Trailing right arrow chevron color (#6B7280)
  static const Color settingsRightArrow = Color(0xFF6B7280);

  /// Logout text and icon color (#E11D48)
  static const Color logout = Color(0xFFE11D48);

  /// White background for the settings group cards
  static const Color settingsCardBackground = Color(0xFFFFFFFF);

  /// Brand green color for leading icons in settings
  static const Color settingsIcon = Color(0xFF0F8A4B);

  /// Color for trailing text values like "English", "1.0.0"
  static const Color settingsTrailingText = Color(0xFF6B7280);

  /// Subtle divider line between items in a settings card
  static const Color settingsDivider = Color(0xFFF1F2F4);

  // ===========================================================================
  // Profile Screen Specific Colors
  // ===========================================================================
  /// Background color for the Profile screen header (#058334)
  static const Color profileHeaderBg = Color(0xFF058334);

  /// Border color surrounding profile image (#689419)
  static const Color profileBorder = Color(0xFF689419);

  /// Name text color (#058334)
  static const Color profileName = Color(0xFF058334);

  /// Phone number and SSCHT code text color (#000000)
  static const Color profilePhoneAndCode = Color(0xFF000000);

  /// Background color for personal info icons (rgba(160, 253, 170, 0.36))
  static const Color profileIconBg = Color(0x5CA0FDAA);

  /// Personal information item title color (#111827)
  static const Color profileItemTitle = Color(0xFF111827);

  /// Personal information subtext color (#6B7280)
  static const Color profileItemSubtext = Color(0xFF6B7280);

  /// Border color for profile personal info card (rgba(243, 244, 246, 1))
  static const Color profileCardBorder = Color.fromRGBO(243, 244, 246, 1);

  /// Drop shadow 1 color for personal info card (rgba(0, 0, 0, 0.05))
  static const Color profileCardShadow1 = Color.fromRGBO(0, 0, 0, 0.05);

  /// Drop shadow 2 color for personal info card (rgba(0, 0, 0, 0.03))
  static const Color profileCardShadow2 = Color.fromRGBO(0, 0, 0, 0.03);

  /// White back arrow icon color on green profile header (#FFFFFF)
  static const Color profileHeaderIcon = Color(0xFFFFFFFF);

  /// White title text color on green profile header (#FFFFFF)
  static const Color profileHeaderTitle = Color(0xFFFFFFFF);

  /// White background for profile information card (#FFFFFF)
  static const Color profileCardBackground = Color(0xFFFFFFFF);

  // ===========================================================================
  // Bottom Sheet (Change Profile Photo) Specific Colors
  // ===========================================================================
  /// Background of the bottom sheet modal (#FFFFFF)
  static const Color bottomSheetBg = Color(0xFFFFFFFF);

  /// Title of the bottom sheet modal (#111827)
  static const Color bottomSheetTitle = Color(0xFF111827);

  /// Subtitle of the bottom sheet modal (#6B7280)
  static const Color bottomSheetSubtitle = Color(0xFF6B7280);

  /// Close icon button color (#9CA3AF)
  static const Color bottomSheetCloseIcon = Color(0xFF9CA3AF);

  /// Divider line in bottom sheet (#F3F4F6)
  static const Color bottomSheetDivider = Color(0xFFF3F4F6);

  /// Background for normal bottom sheet cards (#FFFFFF)
  static const Color bottomSheetCardBg = Color(0xFFFFFFFF);

  /// Title color for normal bottom sheet cards (#111827)
  static const Color bottomSheetItemTitle = Color(0xFF111827);

  /// Subtitle color for normal bottom sheet cards (#6B7280)
  static const Color bottomSheetItemSubtitle = Color(0xFF6B7280);

  /// Chevron arrow color for normal bottom sheet cards (#D1D5DB)
  static const Color bottomSheetChevron = Color(0xFFD1D5DB);

  /// Border for Take Photo and Choose from Gallery cards (#F3F4F6)
  static const Color bottomSheetCardBorder = Color(0xFFF3F4F6);

  /// Border for Remove Photo card (#FFE4E6)
  static const Color bottomSheetDeleteBorder = Color(0xFFFFE4E6);

  /// Background for Remove Photo card (#FFF1F24D)
  static const Color bottomSheetDeleteBg = Color(0x4DFFF1F2);

  /// Box shadow for bottom sheet cards (0px 1px 2px 0px #0000000D)
  static const Color bottomSheetCardShadow = Color(0x0D000000);

  /// Background for green photo & gallery icon badges (#ECFDF5)
  static const Color bottomSheetGreenIconBg = Color(0xFFECFDF5);

  /// Background for red delete icon badge (#FEE2E2)
  static const Color bottomSheetRedIconBg = Color(0xFFFEE2E2);

  /// Background color for the Cancel button (#F3F4F6)
  static const Color bottomSheetCancelBg = Color(0xFFF3F4F6);

  /// Text color for the Cancel button (#374151)
  static const Color bottomSheetCancelText = Color(0xFF374151);

  /// Red text color for Remove Photo title (#EF4444)
  static const Color bottomSheetDeleteText = Color(0xFFEF4444);

  /// Chevron arrow color for bottom sheet delete item (#FDA4AF)
  static const Color bottomSheetDeleteChevron = Color(0xFFFDA4AF);

  // ===========================================================================
  // Common Screen & Header Colors (Settings, Privacy Policy, Terms, FAQ, Support)
  // ===========================================================================
  /// Common background for screens (#F3F3F5)
  static const Color screenBackground = Color(0xFFF3F3F5);

  /// White app bar background (#FFFFFF)
  static const Color appBarBackground = Color(0xFFFFFFFF);

  /// App bar back arrow icon color (#1F2937)
  static const Color appBarIcon = Color(0xFF1F2937);

  /// App bar title color (#000000)
  static const Color appBarTitle = Color(0xFF000000);

  /// Subtle app bar bottom border divider (#F3F4F6)
  static const Color appBarDivider = Color(0xFFF3F4F6);

  // ===========================================================================
  // Privacy Policy & Terms and Conditions Colors
  // ===========================================================================
  /// Section titles for policy screens (#1F2937)
  static const Color policyTitle = Color(0xFF1F2937);

  /// Body content text for policy screens (#374151)
  static const Color policyBody = Color(0xFF374151);

  // ===========================================================================
  // About Us Screen Specific Colors
  // ===========================================================================
  /// Vibrant green text for About Us intro paragraph (#299E64)
  static const Color aboutIntroText = Color(0xFF299E64);

  /// Heading color for About Us sections (#111827)
  static const Color aboutHeading = Color(0xFF111827);

  /// Body content text for About Us sections (#374151)
  static const Color aboutBody = Color(0xFF374151);

  // ===========================================================================
  // Help & Support Screen Specific Colors
  // ===========================================================================
  /// Black greeting text ("Hi Akhil, How can we help ?") (#000000)
  static const Color helpGreeting = Color(0xFF000000);

  /// Subtitle under greeting and under chat button (#6B7280)
  static const Color helpSubtitle = Color(0xFF6B7280);

  /// Background for the search bar (#FFFFFF)
  static const Color searchBarBg = Color(0xFFFFFFFF);

  /// Border for the search bar (#E5E7EB)
  static const Color searchBarBorder = Color(0xFFE5E7EB);

  /// Shadow for the search bar (rgba(0, 0, 0, 0.03))
  static const Color searchBarShadow = Color(0x08000000);

  /// Text color inside search bar (#1F2937)
  static const Color searchBarText = Color(0xFF1F2937);

  /// Hint text color inside search bar (#9CA3AF)
  static const Color searchBarHint = Color(0xFF9CA3AF);

  /// Search icon color (#374151)
  static const Color searchBarIcon = Color(0xFF374151);

  /// Green background for "Chat with us" pill button (#058334)
  static const Color chatButtonBg = Color(0xFF058334);

  /// White text for "Chat with us" button (#FFFFFF)
  static const Color chatButtonText = Color(0xFFFFFFFF);

  /// Heading for "Contact us" section (#000000)
  static const Color contactHeading = Color(0xFF000000);

  /// Background for "Contact us" card (#FFFFFF)
  static const Color contactCardBg = Color(0xFFFFFFFF);

  /// Border for "Contact us" card (#E5E7EB)
  static const Color contactCardBorder = Color(0xFFE5E7EB);

  /// Shadow for contact card
  static const Color contactCardShadow = Color(0x06000000);

  /// Divider between contact items (#F3F4F6)
  static const Color contactDivider = Color(0xFFF3F4F6);

  /// Background for icon badges inside contact card (#FFFFFF)
  static const Color contactIconBadgeBg = Color(0xFFFFFFFF);

  /// Border for icon badges inside contact card (#E5E7EB)
  static const Color contactIconBadgeBorder = Color(0xFFE5E7EB);

  /// Item title in contact card (#000000)
  static const Color contactItemTitle = Color(0xFF000000);

  /// 34% black chevron arrow in contact card (#57000000)
  static const Color contactChevron = Color(0x57000000);

  // ===========================================================================
  // FAQ Screen Specific Colors
  // ===========================================================================
  /// Number text color inside FAQ badge (#006837)
  static const Color faqNumberText = Color(0xFF006837);

  /// Number circular badge background (#ECFDF3)
  static const Color faqNumberBg = Color(0xFFECFDF3);

  /// Question text color in FAQ card (#111827)
  static const Color faqQuestionText = Color(0xFF111827);

  /// Chevron arrow icon color in FAQ card (#1F2937)
  static const Color faqChevron = Color(0xFF1F2937);

  /// Answer container background (#EEFAF4)
  static const Color faqAnswerBg = Color(0xFFEEFAF4);

  /// Answer text color (#3C574F)
  static const Color faqAnswerText = Color(0xFF3C574F);

  /// Background for FAQ question cards (#FFFFFF)
  static const Color faqCardBg = Color(0xFFFFFFFF);

  /// Border for FAQ question cards (#E5E7EB)
  static const Color faqCardBorder = Color(0xFFE5E7EB);

  /// Subtle shadow for FAQ question cards
  static const Color faqCardShadow = Color(0x06000000);

  /// Background for "Still have a question?" support card (#EEFAF4)
  static const Color faqSupportCardBg = Color(0xFFEEFAF4);

  /// Border for "Still have a question?" support card (#D1F2DF)
  static const Color faqSupportCardBorder = Color(0xFFD1F2DF);

  /// Background for headphone icon badge (#D4F4E2)
  static const Color faqSupportHeadphoneBg = Color(0xFFD4F4E2);

  /// Title for support card ("Still have a question?") (#111827)
  static const Color faqSupportTitle = Color(0xFF111827);

  /// Subtext for support card ("We're here to help you.") (#6B7280)
  static const Color faqSupportSubtext = Color(0xFF6B7280);

  /// Border for "Contact Support →" pill button (#006837)
  static const Color faqSupportButtonBorder = Color(0xFF006837);

  /// Text and arrow color for "Contact Support →" pill button (#006837)
  static const Color faqSupportButtonText = Color(0xFF006837);

  /// Background for "Contact Support →" pill button (#FFFFFF)
  static const Color faqSupportButtonBg = Color(0xFFFFFFFF);

  // ===========================================================================
  // General App & Layout Colors
  // ===========================================================================
  /// Default scaffold / page background
  static const Color scaffoldBackground = Color(0xFFF8F9FA);

  /// Divider and separator lines
  static const Color divider = Color(0xFFE5E7EB);

  /// Splash / ripple effect color for tap interactions
  static const Color splashColor = Color(0x10000000);

  /// Highlight color when holding down a list item
  static const Color highlightColor = Color(0x08000000);
}
