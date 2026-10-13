import 'package:flutter/material.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TranslationService {
  static const String _prefLanguageKey = 'selected_language';

  // ValueNotifier to notify listening UI widgets when language changes
  static final ValueNotifier<String> currentLanguageNotifier =
      ValueNotifier<String>('English');

  static String get currentLanguage => currentLanguageNotifier.value;
  static bool get isTamil => currentLanguageNotifier.value == 'Tamil';

  static OnDeviceTranslator? _translator;
  static final OnDeviceTranslatorModelManager _modelManager =
      OnDeviceTranslatorModelManager();

  // In-memory runtime translation cache to avoid re-translating already translated strings
  static final Map<String, String> _cache = {};

  /// Initialize the translation service and restore saved language preference
  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLang = prefs.getString(_prefLanguageKey) ?? 'English';
    currentLanguageNotifier.value = savedLang;

    if (savedLang == 'Tamil') {
      _initTranslator();
      await _ensureModelDownloaded();
    }
  }

  static void _initTranslator() {
    _translator?.close();
    _translator = OnDeviceTranslator(
      sourceLanguage: TranslateLanguage.english,
      targetLanguage: TranslateLanguage.tamil,
    );
  }

  /// Change application language
  static Future<void> changeLanguage(String language) async {
    if (currentLanguageNotifier.value == language) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefLanguageKey, language);

    if (language == 'Tamil') {
      _initTranslator();
      // Ensure Tamil model is downloaded
      await _ensureModelDownloaded();
    } else {
      _translator?.close();
      _translator = null;
    }

    currentLanguageNotifier.value = language;
  }

  static Future<void> _ensureModelDownloaded() async {
    try {
      final isDownloaded = await _modelManager
          .isModelDownloaded(TranslateLanguage.tamil.bcpCode);
      if (!isDownloaded) {
        await _modelManager.downloadModel(TranslateLanguage.tamil.bcpCode);
      }
    } catch (e) {
      debugPrint('Error downloading ML Kit Tamil model: $e');
    }
  }

  /// Translate a given English text to Tamil using Google ML Kit OnDeviceTranslator
  static Future<String> translate(String text) async {
    if (!isTamil || text.trim().isEmpty) return text;

    // Return from runtime cache if already translated by ML Kit
    if (_cache.containsKey(text)) {
      return _cache[text]!;
    }

    try {
      if (_translator == null) {
        _initTranslator();
      }
      final translated = await _translator?.translateText(text) ?? text;
      _cache[text] = translated;
      return translated;
    } catch (e) {
      debugPrint('ML Kit translation error for "$text": $e');
      return text;
    }
  }

  /// Synchronous cache check (only returns if ML Kit has already translated it during this session)
  static String? getCachedTranslation(String text) {
    if (!isTamil) return text;
    return _cache[text];
  }
}

/// A reactive widget that translates English text dynamically via Google ML Kit
class TrText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final bool autoReduceTamilSize;

  const TrText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.autoReduceTamilSize = true,
  });

  TextStyle? _effectiveStyle(bool isTamil) {
    if (!isTamil || style == null || !autoReduceTamilSize) return style;
    final size = style!.fontSize;
    if (size == null) return style;

    // Reduce font size proportionally for Tamil language to prevent overflow
    final double reducedSize = size >= 18
        ? (size - 2.5)
        : (size > 14
            ? (size - 2.0)
            : (size > 10 ? (size - 1.5) : (size > 7 ? (size - 1.0) : size)));
    return style!.copyWith(fontSize: reducedSize);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: TranslationService.currentLanguageNotifier,
      builder: (context, lang, _) {
        final bool isTamil = lang == 'Tamil';
        final effectiveStyle = _effectiveStyle(isTamil);

        if (!isTamil) {
          return Text(
            text,
            style: style,
            textAlign: textAlign,
            overflow: overflow,
            maxLines: maxLines,
          );
        }

        // Check if ML Kit already translated this string into the session cache
        final cached = TranslationService.getCachedTranslation(text);
        if (cached != null) {
          return Text(
            cached,
            style: effectiveStyle,
            textAlign: textAlign,
            overflow: overflow,
            maxLines: maxLines,
          );
        }

        // Translate on-the-fly using Google ML Kit OnDeviceTranslator
        return FutureBuilder<String>(
          future: TranslationService.translate(text),
          initialData: text,
          builder: (context, snapshot) {
            return Text(
              snapshot.data ?? text,
              style: effectiveStyle,
              textAlign: textAlign,
              overflow: overflow,
              maxLines: maxLines,
            );
          },
        );
      },
    );
  }
}

