import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class DemandaReport extends StatefulWidget {
  DocumentSnapshot docid;
  DemandaReport({this.docid});

  @override
  State<DemandaReport> createState() => _DemandaReportState(docid: docid);
}

class _DemandaReportState extends State<DemandaReport> {
  DocumentSnapshot docid;
  _DemandaReportState({this.docid});

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
  List anexos;

  @override
  void initState() {
    setState(() {
      titulo = docid.get('titulo');
      resumo = docid.get('resumo');
      status = docid.get('status');
      tempo = docid.get('tempo');
      equipeColaboradores = docid.get('equipe_colaboradores');
      dadosProponente = docid.get('dados_proponente');
      empresaEnvolvida = docid.get('empresa_envolvida');
      vinculo = docid.get('vinculo');
      areaTematica = docid.get('area_tematica');
      propostaConjunto = docid.get('proposta_conjunto');
      objetivo = docid.get('objetivo');
      contrapartida = docid.get('contrapartida');
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
    //final font2 = await PdfGoogleFonts.interBold();
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
            pw.Header(level: 2, text: tituloAssunto),
            //pw.SizedBox(width: 5),
            pw.Paragraph(text: conteudo),
          ]);
    }

    doc.addPage(
      pw.Page(
        pageTheme: pw.PageTheme(
          pageFormat: format.copyWith(
            marginBottom: 0,
            marginLeft: 0,
            marginRight: 0,
            marginTop: 0,
          ),
          orientation: pw.PageOrientation.portrait,
          // theme: pw.ThemeData.withFont(
          //   base: font1,
          //   bold: font2,
          // ),
        ),
        build: (context) {
          return pw.Padding(
              padding: const pw.EdgeInsets.all(16),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SvgImage(svg: logo, width: 200),
                  pw.Container(
                      padding: const pw.EdgeInsets.all(30),
                      child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Center(
                                child: pw.Header(
                                    level: 2, text: 'PROPOSTA DE PROJETO')),
                            pw.SizedBox(height: 10),
                            pw.Container(
                                child: pw.Column(children: [
                              conteudoHorizontal('Título da proposta:', titulo),
                              conteudoHorizontal(
                                  'Autores:', equipeColaboradores),
                              conteudoHorizontal(
                                  'Dados do proponente:', dadosProponente),
                              conteudoHorizontal(
                                  'Instituições envolvidas:', empresaEnvolvida),
                            ])),
                            pw.SizedBox(height: 10),
                            pw.Container(
                                child: pw.Column(children: [
                              conteudoVertical('RESUMO DA PROPOSTA', resumo),
                              conteudoVertical('ÁREA TEMÁTICA', areaTematica),
                              conteudoVertical(
                                  'JUSTIFICATIVA', propostaConjunto),
                              conteudoVertical('OBJETIVOS', objetivo),
                              conteudoVertical(
                                  'RECURSOS DISPONÍVEIS(CONTRAPARTIDA)',
                                  contrapartida),
                              conteudoVertical(
                                  'TEMPO DE EXECUÇÃO(ESTIMADO)', tempo),
                            ]))
                          ]))
                ],
              ));
        },
      ),
    );

    return doc.save();
  }
}
