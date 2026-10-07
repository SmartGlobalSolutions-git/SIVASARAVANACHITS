import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfGenerator {
  static Future<void> generateChitStatement(List<dynamic> transactions, dynamic chitId) async {
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
          ];
        },
      ),
    );

    try {
      Directory? dir;
      if (Platform.isAndroid) {
        dir = Directory('/storage/emulated/0/Download');
        if (!await dir.exists()) {
          dir = await getExternalStorageDirectory();
        }
      } else {
        dir = await getDownloadsDirectory();
      }
      
      if (dir != null) {
        final file = File('${dir.path}/chit_statement_$chitId.pdf');
        await file.writeAsBytes(await pdf.save());
      }
    } catch (e) {
      debugPrint('Error generating PDF: $e');
    }
  }

  static Future<void> generatePassbookStatement(List<dynamic> transactions, dynamic chitId) async {
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
          ];
        },
      ),
    );

    try {
      Directory? dir;
      if (Platform.isAndroid) {
        dir = Directory('/storage/emulated/0/Download');
        if (!await dir.exists()) {
          dir = await getExternalStorageDirectory();
        }
      } else {
        dir = await getDownloadsDirectory();
      }
      
      if (dir != null) {
        final file = File('${dir.path}/passbook_statement_$chitId.pdf');
        await file.writeAsBytes(await pdf.save());
      }
    } catch (e) {
      debugPrint('Error generating PDF: $e');
    }
  }
}
