import 'dart:typed_data';

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
    final logo = await rootBundle.loadString('lib/assets/svg/logo-dark.svg');
    var font1 = pw.Font.ttf(
        await rootBundle.load("lib/assets/fonts/inter/Inter-Regular.ttf"));
    var font2 = pw.Font.ttf(
        await rootBundle.load("lib/assets/fonts/inter/Inter-ExtraBold.ttf"));

    pw.Row conteudoHorizontal(String tituloAssunto, String conteudo) {
      return pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Text(tituloAssunto),
        pw.SizedBox(width: 5),
        pw.Text(conteudo),
      ]);
    }

    pw.Column conteudoVertical(String tituloAssunto, String conteudo) {
      return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Header(level: 3, text: tituloAssunto),
            pw.Paragraph(text: conteudo),
          ]);
    }

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(
          base: font1,
          bold: font2,
        ),
        //pageFormat: format.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
        orientation: pw.PageOrientation.portrait,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        build: (pw.Context context) => <pw.Widget>[
          pw.Header(
              level: 0,
              title: 'PROPOSTA DE PROJETO',
              child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: <pw.Widget>[
                    pw.Text('PROPOSTA DE PROJETO'),
                    pw.SvgImage(svg: logo, width: 150),
                  ])),
          conteudoVertical('TÍTULO DA PROPOSTA', titulo),
          conteudoVertical('AUTORES', equipeColaboradores),
          conteudoVertical('DADOS DO PROPONENTE', dadosProponente),
          conteudoVertical('INSTITUIÇÕES ENVOLVIDAS', empresaEnvolvida),
          conteudoVertical('RESUMO DA PROPOSTA', resumo),
          conteudoVertical('ÁREA TEMÁTICA', areaTematica),
          conteudoVertical('JUSTIFICATIVA', propostaConjunto),
          conteudoVertical('OBJETIVOS', objetivo),
          conteudoVertical(
              'RECURSOS DISPONÍVEIS(CONTRAPARTIDA)', contrapartida),
          conteudoVertical('TEMPO DE EXECUÇÃO(ESTIMADO)', tempo),
          pw.Header(level: 2, text: 'ANEXOS'),
          pw.ListView.builder(
            itemCount: vetAnexos.length,
            itemBuilder: (context, index) {
              final url = vetAnexos[index]['file_url'];

             return pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 10),
                child: _UrlText(url, url)
              );
              //return pw.Bullet(text: url);

              //return pw.Link(destination: url, child: pw.Text('arquivo'));

              // return pw.UrlLink(destination: url, child: pw.Text('Arquivo'));
            },
          )
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
