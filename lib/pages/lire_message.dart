import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:systeme_pers/classes/Message.dart';

class LireMessagePage extends StatelessWidget {
  const LireMessagePage({super.key, required this.message});
  final Message message;

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: CommandBar(
                primaryItems: [
                  CommandBarButton(
                    icon: const Icon(FluentIcons.back, size: 20),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    subtitle: const Text('Retour'),
                  ),
                  CommandBarButton(
                    onPressed: () {},
                    label: Text(
                      "Message de ${message.emetteur.matricule}",
                      style: const TextStyle(fontSize: 20, backgroundColor: Colors.white),
                    ),
                    subtitle: Text(
                      'Vers ${message.recepteur.matricule}',
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FilledButton(
                  child: Row(
                    children: const [
                      Text('Imprimer'),
                      Padding(padding: EdgeInsets.all(5)),
                      Icon(FluentIcons.print)
                    ],
                  ),
                  onPressed: () async {
                    await Printing.layoutPdf(onLayout: ((format) async => _generatePdf(format)));
                  },
                ),
              ],
            )
          ],
        ),
      ),
      content: PdfPreview(
        build: (format) => _generatePdf(format),
        allowSharing: false,
        canDebug: false,
        pdfFileName: 'message_${message.dateEnvoi.toString()}',
        onPrinted: (context) => inmpressionOk(context),
        onError: (context, error) => inmpressionOk(context, error),
      ),
      bottomBar: Row(),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    // final font = await PdfGoogleFonts.nunitoExtraLight();

    pdf.addPage(pw.Page(
      pageFormat: format,
      build: (context) => pw.Column(children: [
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 50, vertical: 25),
          margin: const pw.EdgeInsets.only(top: 20),
          color: PdfColor.fromHex('#FFF'),
          width: double.infinity,
          child: pw.Text(
            'Message',
            style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 20,
                // font: font,
                decoration: pw.TextDecoration.underline,
                decorationStyle: pw.TextDecorationStyle.solid),
          ),
        ),
        pw.Container(
          color: PdfColor.fromHex('#FFF'),
          width: double.infinity,
          padding: const pw.EdgeInsets.symmetric(horizontal: 50, vertical: 35),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(message.titre, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Padding(padding: const pw.EdgeInsets.all(10)),
              pw.Text(message.contenu),
              pw.Padding(padding: const pw.EdgeInsets.all(20)),
              pw.Text('Envoye a ${message.recepteur.matricule}'),
              pw.Text('Le ${message.dateEnvoi.toString()}'),
            ],
          ),
        ),
      ]),
    ));

    return pdf.save();
  }

  inmpressionOk(BuildContext context, [error]) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => ContentDialog(
        title: Text(error == null ? "Impression reussi" : "Une erreur est survenue"),
        content: error == null ? null : Text(error.toString()),
        actions: [
          FilledButton(
            child: const Text('Okay, compris'),
            onPressed: () {
              Navigator.pop(context, true);
            },
          )
        ],
      ),
    );
  }
}
