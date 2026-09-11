import 'package:printing/printing.dart';

import 'report_pdf_builder.dart';

const _reportPdfFilename = 'Raport-FutureMe.pdf';

/// Opens the native print/save-as-PDF dialog for the final report.
Future<void> downloadReportPdf({required String userName, String? summary, required List<Map<String, String>> sections}) async {
  final bytes = await buildReportPdf(userName: userName, summary: summary, sections: sections);
  await Printing.layoutPdf(onLayout: (_) async => bytes, name: _reportPdfFilename);
}

/// Opens the native share sheet with the final report as a PDF attachment.
Future<void> shareReportPdf({required String userName, String? summary, required List<Map<String, String>> sections}) async {
  final bytes = await buildReportPdf(userName: userName, summary: summary, sections: sections);
  await Printing.sharePdf(bytes: bytes, filename: _reportPdfFilename);
}
