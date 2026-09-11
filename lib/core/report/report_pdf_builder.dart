import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Renders the final FutureMe report — [summary] + [sections] (each a
/// `{title, body}` map, as stored by `UserRepository.saveFinalReport`) —
/// into an actual downloadable/shareable PDF file.
Future<Uint8List> buildReportPdf({
  required String userName,
  String? summary,
  required List<Map<String, String>> sections,
}) async {
  final regular = pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Regular.ttf'));
  final bold = pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Bold.ttf'));

  final doc = pw.Document();
  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      theme: pw.ThemeData.withFont(base: regular, bold: bold),
      margin: const pw.EdgeInsets.symmetric(horizontal: 36, vertical: 40),
      build: (context) => [
        pw.Text('Raportul tău FutureMe', style: pw.TextStyle(font: bold, fontSize: 24)),
        pw.SizedBox(height: 4),
        pw.Text(userName, style: pw.TextStyle(font: regular, fontSize: 12, color: PdfColors.grey700)),
        pw.SizedBox(height: 20),
        pw.Divider(color: PdfColors.grey400),
        pw.SizedBox(height: 16),
        if (summary != null && summary.isNotEmpty) ...[
          pw.Text(summary, style: pw.TextStyle(font: regular, fontSize: 12, fontStyle: pw.FontStyle.italic, color: PdfColors.grey800)),
          pw.SizedBox(height: 20),
        ],
        for (final s in sections) ...[
          pw.Text(s['title'] ?? '', style: pw.TextStyle(font: bold, fontSize: 15)),
          pw.SizedBox(height: 6),
          pw.Text(s['body'] ?? '', style: pw.TextStyle(font: regular, fontSize: 12, lineSpacing: 2)),
          pw.SizedBox(height: 18),
        ],
      ],
    ),
  );
  return doc.save();
}
