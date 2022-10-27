import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class DemandaReport extends StatefulWidget {
  final DocumentSnapshot docid;
  final List vetDadoSubcolecao;

  const DemandaReport({Key key, this.docid, this.vetDadoSubcolecao})
      : super(key: key);

  @override
  State<DemandaReport> createState() => _DemandaReportState();
}

class _DemandaReportState extends State<DemandaReport> {
  // final pdf = pw.Document();
  String titulo;
  String resumo;
  String status;
  String tempo;
  String equipeColaboradores;
  String dadosProponente;
  String empresaEnvolvida;
  String vinculo;
  String areaTematica;
  String propostaConjunto;
  String objetivo;
  String contrapartida;
  List vetAnexos;

  @override
  void initState() {
    setState(() {
      titulo = widget.docid.get('titulo');
      resumo = widget.docid.get('resumo');
      status = widget.docid.get('status');
      tempo = widget.docid.get('tempo');
      equipeColaboradores = widget.docid.get('equipe_colaboradores');
      dadosProponente = widget.docid.get('dados_proponente');
      empresaEnvolvida = widget.docid.get('empresa_envolvida');
      vinculo = widget.docid.get('vinculo');
      areaTematica = widget.docid.get('area_tematica');
      propostaConjunto = widget.docid.get('proposta_conjunto');
      objetivo = widget.docid.get('objetivo');
      contrapartida = widget.docid.get('contrapartida');
      vetAnexos = widget.vetDadoSubcolecao;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Gerando Relatório'),
          centerTitle: true,
        ),
        body: PdfPreview(
          // maxPageWidth: 1000,
          useActions: true,
          canChangePageFormat: false,
          canChangeOrientation: false,
          // pageFormats:pageformat,
          canDebug: false,

          build: (format) => generateDocument(
            format,
          ),
        ));
  }

  Future<Uint8List> generateDocument(PdfPageFormat format) async {
    final doc = pw.Document(pageMode: PdfPageMode.outlines);
    // final font1 = await PdfGoogleFonts.interRegular();
    // final font2 = await PdfGoogleFonts.interBold();
    //final logo = await rootBundle.loadString('lib/assets/svg/logo-dark.svg');
    final logo = pw.MemoryImage(
      (await rootBundle.load('lib/assets/img/logo-dark-version.png'))
          .buffer
          .asUint8List(),
    );

    var font1 = pw.Font.ttf(
        await rootBundle.load("lib/assets/fonts/inter/Inter-Regular.ttf"));
    var font2 = pw.Font.ttf(
        await rootBundle.load("lib/assets/fonts/inter/Inter-ExtraBold.ttf"));

    pw.Column conteudoVertical(String tituloAssunto, String conteudo) {
      return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(tituloAssunto,
                style: pw.TextStyle(font: font2, fontSize: 12)),
            pw.Paragraph(
                text: conteudo, style: pw.TextStyle(font: font1, fontSize: 11)),
          ]);
    }

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        // theme: pw.ThemeData.withFont(
        //   base: font1,
        //   bold: font2,
        // ),
        //pageFormat: format.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
        orientation: pw.PageOrientation.portrait,
        build: (pw.Context context) => <pw.Widget>[
          pw.Center(
            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Image(logo, width: 441, height: 50),
                  pw.SizedBox(height: 50),
                  pw.Text('PROPOSTA DE PROJETO',
                      style: pw.TextStyle(font: font2, fontSize: 15)),
                ]),
          ),
          pw.SizedBox(height: 50),
          conteudoVertical('TÍTULO DA PROPOSTA', titulo),
          conteudoVertical('AUTORES', equipeColaboradores),
          conteudoVertical('DADOS DO PROPONENTE', dadosProponente),
          conteudoVertical('INSTITUIÇÕES ENVOLVIDAS', empresaEnvolvida),
          pw.Container(
              padding: const pw.EdgeInsets.only(left: 16),
              child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    conteudoVertical('1.   RESUMO DA PROPOSTA', resumo),
                    conteudoVertical('2.   ÁREA TEMÁTICA', areaTematica),
                    conteudoVertical('3.   JUSTIFICATIVA', propostaConjunto),
                    conteudoVertical('4.   OBJETIVOS', objetivo),
                    conteudoVertical('5.   RECURSOS DISPONÍVEIS(CONTRAPARTIDA)',
                        contrapartida),
                    conteudoVertical('6. TEMPO DE EXECUÇÃO(ESTIMADO)', tempo),
                    pw.Text('7.  ANEXOS',
                        style: pw.TextStyle(font: font2, fontSize: 12)),
                    pw.ListView.builder(
                      itemCount: vetAnexos.length,
                      itemBuilder: (context, index) {
                        final url = vetAnexos[index]['file_url'];

                        return pw.Padding(
                            padding: const pw.EdgeInsets.only(bottom: 10),
                            child: _UrlText(url, url));
                      },
                    )
                  ]))
        ],
      ),
    );

    return doc.save();
  }
}

class _UrlText extends pw.StatelessWidget {
  _UrlText(this.text, this.url);

  final String text;
  final String url;

  @override
  pw.Widget build(pw.Context context) {
    return pw.UrlLink(
      destination: url,
      child: pw.Text(text,
          style: const pw.TextStyle(
            decoration: pw.TextDecoration.underline,
            color: PdfColors.blue,
          )),
    );
  }
}
