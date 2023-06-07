import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:semesterproject/pdf_view.dart';
import 'package:semesterproject/utils.dart';


class ConvertedText extends StatefulWidget {
  const ConvertedText({Key? key}) : super(key: key);

  @override
  State<ConvertedText> createState() => _ConvertedTextState();
}

class _ConvertedTextState extends State<ConvertedText> {


  var result = '';
   final pdf = pw.Document();
  String path = '';


  writeOnPdf() {
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Header(
              level: 0,
              child: pw.Text(result),
            ),
          ];
        },
      ),
    );

  }

  Future savePdf() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String documentPath = documentDirectory.path;
    File file = File("$documentPath/example.pdf");
    file.writeAsBytesSync(await pdf.save() );
    path = file.path;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueAccent,
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: const Text(
            'Converted Text',
            style: TextStyle(fontSize: 25),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      height: 750,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,

                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 650,
                            child: SingleChildScrollView(
                              child: Text(
                                result = ModalRoute.of(context)!.settings.arguments
                                    as String,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 15),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 135,
                                height: 55,
                                decoration: const BoxDecoration(
                                  color: Colors.blueAccent,
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, 'translation',
                                        arguments: result);
                                  },
                                  child: const Text(
                                    "Translate",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,fontSize: 20),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      color: Colors.blueAccent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () async{
                              await Clipboard.setData(ClipboardData(text: result)).then((value){
                                Utils.toastMessage("Text Copied");
                              }).onError((error, stackTrace){
                                Utils.toastMessage("Text Not Copied");
                              });
                            },
                            child: const Icon(
                              Icons.copy,
                              size: 45,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                              onPressed: () async {
                                writeOnPdf();
                                await savePdf();

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PdfPreviewScreen(path: path),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.picture_as_pdf_outlined,
                                color: Colors.white,
                                size: 45,
                              ))
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
