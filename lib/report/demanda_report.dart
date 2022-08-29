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
  var titulo;
  var resumo;
  var status;
  var tempo;

  var marks;
  void initState() {
    setState(() {
      titulo = docid.get('titulo');
      resumo = docid.get('resumo');
      status = docid.get('status');
      tempo = docid.get('tempo');
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
      )
    );

  }

  Future<Uint8List> generateDocument(PdfPageFormat format) async {
    final doc = pw.Document(pageMode: PdfPageMode.outlines);
    final font1 = await PdfGoogleFonts.interRegular();
    final font2 = await PdfGoogleFonts.interBold();

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
          theme: pw.ThemeData.withFont(
            base: font1,
            bold: font2,
          ),
        ),
        build: (context) {
          return pw.Center(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  // pw.Flexible(
                  //   child: pw.Image(
                  //     Image(_logo).image
                  //   ),
                  // ),
                  pw.SizedBox(
                    height: 20,
                  ),
                  pw.Center(
                    child: pw.Text(
                      'Resumo da Demanda',
                      style: pw.TextStyle(
                        fontSize: 50,
                      ),
                    ),
                  ),
                  pw.SizedBox(
                    height: 20,
                  ),
                  pw.Divider(),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text(
                        'Título: ',
                        style: pw.TextStyle(
                          fontSize: 50,
                        ),
                      ),
                      pw.Text(
                        titulo,
                        style: pw.TextStyle(
                          fontSize: 50,
                        ),
                      ),
                    ],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text(
                        'Resumo: ',
                        style: pw.TextStyle(
                          fontSize: 50,
                        ),
                      ),
                      pw.Text(
                        resumo,
                        style: pw.TextStyle(
                          fontSize: 50,
                        ),
                      ),
                    ],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text(
                        'Status: ',
                        style: pw.TextStyle(
                          fontSize: 50,
                        ),
                      ),
                      pw.Text(
                        status,
                        style: pw.TextStyle(
                          fontSize: 50,
                        ),
                      ),
                    ],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text(
                        'Tempo: ',
                        style: pw.TextStyle(
                          fontSize: 50,
                        ),
                      ),
                      pw.Text(
                        tempo,
                        style: pw.TextStyle(
                          fontSize: 50,
                        ),
                      ),
                    ],
                  ),
                ],
              ));
        },
      ),
    );

    return doc.save();
  }
}