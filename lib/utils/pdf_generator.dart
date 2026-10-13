import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfGenerator {
  static const MethodChannel _channel = MethodChannel('com.siva_saravana.app/file_downloader');

  /// Saves the PDF directly to device storage (Downloads folder on Android).
  static Future<String> _saveToDevice(List<int> bytes, String fileName) async {
    if (Platform.isAndroid) {
      try {
        final result = await _channel.invokeMethod<String>('saveToDownloads', {
          'fileName': fileName,
          'bytes': Uint8List.fromList(bytes),
        });
        return result ?? 'Downloads/$fileName';
      } catch (e) {
        debugPrint('Native download failed: $e. Falling back to app storage.');
      }
    }

    // Fallback for iOS or desktop
    final Directory? dir = Platform.isIOS
        ? await getApplicationDocumentsDirectory()
        : await getDownloadsDirectory();

    final targetDir = dir ?? await getApplicationDocumentsDirectory();
    final file = File('${targetDir.path}/$fileName');
    await file.writeAsBytes(bytes);
    return file.path;
  }

  static Future<String> generateChitStatement(List<dynamic> transactions, dynamic chitId) async {
    try {
      final pdf = pw.Document();
      
      final font = await PdfGoogleFonts.robotoRegular();
      final fontBold = await PdfGoogleFonts.robotoBold();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          theme: pw.ThemeData.withFont(
            base: font,
            bold: fontBold,
          ),
          build: (pw.Context context) {
            return [
              pw.Text('Chit Statement', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 5),
              pw.Text('Chit ID: $chitId', style: const pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 20),
              pw.TableHelper.fromTextArray(
                context: context,
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                headerDecoration: const pw.BoxDecoration(color: PdfColors.green800),
                cellAlignment: pw.Alignment.center,
                headers: ['SL. NO.', 'DATE', 'TYPE', 'DIVIDEND', 'DEBIT', 'CREDIT', 'BALANCE'],
                data: transactions.map((t) {
                  return [
                    t['sno']?.toString() ?? '',
                    t['date']?.toString() ?? '',
                    t['type']?.toString() ?? '',
                    t['dividend']?.toString() ?? '0',
                    t['debit']?.toString() ?? '0',
                    t['credit']?.toString() ?? '0',
                    t['balance']?.toString() ?? '0',
                  ];
                }).toList(),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'NOTE: This is a system generated pdf',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.grey700,
                ),
              ),
            ];
          },
        ),
      );

      final pdfBytes = await pdf.save();
      final savedPath = await _saveToDevice(pdfBytes, 'chit_statement_$chitId.pdf');
      return savedPath;
    } catch (e) {
      debugPrint('Error generating PDF: $e');
      rethrow;
    }
  }

  static Future<String> generatePassbookStatement(List<dynamic> transactions, dynamic chitId) async {
    try {
      final pdf = pw.Document();

      final font = await PdfGoogleFonts.robotoRegular();
      final fontBold = await PdfGoogleFonts.robotoBold();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          theme: pw.ThemeData.withFont(
            base: font,
            bold: fontBold,
          ),
          build: (pw.Context context) {
            return [
              pw.Text('Passbook Statement', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 5),
              pw.Text('Chit ID: $chitId', style: const pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 20),
              pw.TableHelper.fromTextArray(
                context: context,
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                headerDecoration: const pw.BoxDecoration(color: PdfColors.green800),
                cellAlignment: pw.Alignment.center,
                headers: ['S.NO', 'RECEIPT DATE', 'TRANSACTION TYPE', 'AMOUNT'],
                data: transactions.map((t) {
                  return [
                    t['sno']?.toString() ?? '',
                    t['date']?.toString() ?? '',
                    t['transaction_type']?.toString() ?? '',
                    t['collection']?.toString() ?? '0',
                  ];
                }).toList(),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'NOTE: This is a system generated pdf',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.grey700,
                ),
              ),
            ];
          },
        ),
      );

      final pdfBytes = await pdf.save();
      final savedPath = await _saveToDevice(pdfBytes, 'passbook_statement_$chitId.pdf');
      return savedPath;
    } catch (e) {
      debugPrint('Error generating PDF: $e');
      rethrow;
    }
  }

  /// Share PDF method (for Share button if needed)
  static Future<void> shareChitStatement(List<dynamic> transactions, dynamic chitId) async {
    final pdfBytes = await _buildChitPdfBytes(transactions, chitId);
    await Printing.sharePdf(bytes: pdfBytes, filename: 'chit_statement_$chitId.pdf');
  }

  static Future<void> sharePassbookStatement(List<dynamic> transactions, dynamic chitId) async {
    final pdfBytes = await _buildPassbookPdfBytes(transactions, chitId);
    await Printing.sharePdf(bytes: pdfBytes, filename: 'passbook_statement_$chitId.pdf');
  }

  static Future<Uint8List> _buildChitPdfBytes(List<dynamic> transactions, dynamic chitId) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.robotoRegular();
    final fontBold = await PdfGoogleFonts.robotoBold();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: font, bold: fontBold),
        build: (pw.Context context) => [
          pw.Text('Chit Statement', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 5),
          pw.Text('Chit ID: $chitId', style: const pw.TextStyle(fontSize: 16)),
          pw.SizedBox(height: 20),
          pw.TableHelper.fromTextArray(
            context: context,
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.green800),
            cellAlignment: pw.Alignment.center,
            headers: ['SL. NO.', 'DATE', 'TYPE', 'DIVIDEND', 'DEBIT', 'CREDIT', 'BALANCE'],
            data: transactions.map((t) => [
              t['sno']?.toString() ?? '',
              t['date']?.toString() ?? '',
              t['type']?.toString() ?? '',
              t['dividend']?.toString() ?? '0',
              t['debit']?.toString() ?? '0',
              t['credit']?.toString() ?? '0',
              t['balance']?.toString() ?? '0',
            ]).toList(),
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            'NOTE: This is a system generated pdf',
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.grey700,
            ),
          ),
        ],
      ),
    );
    return pdf.save();
  }

  static Future<Uint8List> _buildPassbookPdfBytes(List<dynamic> transactions, dynamic chitId) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.robotoRegular();
    final fontBold = await PdfGoogleFonts.robotoBold();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: font, bold: fontBold),
        build: (pw.Context context) => [
          pw.Text('Passbook Statement', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 5),
          pw.Text('Chit ID: $chitId', style: const pw.TextStyle(fontSize: 16)),
          pw.SizedBox(height: 20),
          pw.TableHelper.fromTextArray(
            context: context,
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.green800),
            cellAlignment: pw.Alignment.center,
            headers: ['S.NO', 'RECEIPT DATE', 'TRANSACTION TYPE', 'AMOUNT'],
            data: transactions.map((t) => [
              t['sno']?.toString() ?? '',
              t['date']?.toString() ?? '',
              t['transaction_type']?.toString() ?? '',
              t['collection']?.toString() ?? '0',
            ]).toList(),
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            'NOTE: This is a system generated pdf',
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.grey700,
            ),
          ),
        ],
      ),
    );
    return pdf.save();
  }
}
