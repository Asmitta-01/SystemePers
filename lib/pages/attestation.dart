import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:systeme_pers/classes/Employe.dart';
import 'package:systeme_pers/classes/Utilisateur.dart';

class AttestationPage extends StatelessWidget {
  const AttestationPage({super.key, required this.employe, required this.currentEmploye});

  final Employe employe;
  final Employe currentEmploye;

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
                    label: const Text(
                      "Attestation de travail",
                      style: TextStyle(fontSize: 20, backgroundColor: Colors.white),
                    ),
                    subtitle: Text(
                      'Employe ${employe.matricule}',
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
                const Padding(padding: EdgeInsets.all(10)),
                FilledButton(
                  child: Row(
                    children: const [
                      Text('Envoyer'),
                      Padding(padding: EdgeInsets.all(5)),
                      Icon(FluentIcons.send)
                    ],
                  ),
                  onPressed: () {},
                )
              ],
            )
          ],
        ),
      ),
      content: PdfPreview(
        build: (format) => _generatePdf(format),
        allowSharing: false,
        canDebug: false,
        padding: const EdgeInsets.symmetric(horizontal: 45),
        pdfFileName: 'Attestation de travail_${employe.matricule}',
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
      build: (context) {
        var local = DateTime.now();
        return pw.Column(children: [
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 50, vertical: 25),
            margin: const pw.EdgeInsets.only(top: 20),
            color: PdfColor.fromHex('#FFF'),
            width: double.infinity,
            child: pw.Text(
              'Attestation de travail',
              style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 22,
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
                pw.Text('Je soussigne, Monsieur/Madame ${currentEmploye.nom} ${currentEmploye.prenom!}, agissant en qualite de' +
                    ' ${currentEmploye.role == Role.chargePersonnel ? 'charge du personnel' : 'Directeur'} de l\'Univesite de Douala'),
                pw.Padding(padding: const pw.EdgeInsets.all(10)),
                pw.Text('Certifie et atteste par la presente que :'),
                pw.Padding(padding: const pw.EdgeInsets.all(10)),
                pw.Text(
                    'Monsieur/Madame ${employe.nom} ${employe.prenom!}, ne le ${DateFormat.yMMMd('fr_FR').format(employe.dateNaissance)}, demeurant a *********'),
                pw.Padding(padding: const pw.EdgeInsets.all(10)),
                pw.Text('Est un salarie de notre Universite depuis le ${DateFormat.yMMMd('fr_FR').format(employe.contrats.first.dateSignature)},' +
                    ' en vertu d\'un contrat de travail a duree ${employe.contrats.any((element) => !element.estCDD) ? 'indeterminee' : 'determinee'}'),
                pw.Text(
                    'et qu\'il n\'est actuellement ni demissionnaire, ni en procedure de licenciement.'),
                pw.Padding(padding: const pw.EdgeInsets.all(10)),
                pw.Text('Il y exerce des fonctions decrites telles que suit: '),
                pw.Text(employe.contrats.map((e) => e.poste.descriptionPoste).join(', ')),
                pw.Padding(padding: const pw.EdgeInsets.all(20)),
                pw.Text(
                    'Cette attestation est delivree a la demande du Salarie pour servir et faire valoir ce que de droit;'),
                pw.Padding(padding: const pw.EdgeInsets.all(10)),
                pw.Text('Fait a Douala'),
                pw.Text(
                    'Le ${DateFormat.yMMMd('fr_FR').format(local)} a ${DateFormat.Hm('fr_FR').format(local)}'),
              ],
            ),
          ),
        ]);
      },
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
              Navigator.popAndPushNamed(context, '/espacechargedupersonnel');
            },
          )
        ],
      ),
    );
  }
}
