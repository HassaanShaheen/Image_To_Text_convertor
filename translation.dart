import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:semesterproject/pdf_view.dart';
import 'package:semesterproject/utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:translator/translator.dart';

class TranslationOfText extends StatefulWidget {
  const TranslationOfText({Key? key}) : super(key: key);

  @override
  State<TranslationOfText> createState() => _TranslationOfTextState();
}

class _TranslationOfTextState extends State<TranslationOfText> {
  GoogleTranslator translator = GoogleTranslator();

  var output = '';
  var result = '';
  String? dropdownValue;
  final pdf = pw.Document();
  String path = '';

  static const Map<String, String> lang = {
    "Arabic": "ar",
    "Bengali": "bn",
    "Chinese": "zh-cn",
    "Danish": "da",
    "Dutch": "nl",
    "English": "en",
    "French": "fr",
    "German": "de",
    "Greek": "el",
    "Hindi": "hi",
    "Indonesian": "id",
    "Irish": "ga",
    "Italian": "it",
    "Japanese": "ja",
    "Korean": "ko",
    "Latin": "la",
    "Malay": "ms",
    "Nepali": "ne",
    "Persian": "fa",
    "Polish": "pl",
    "Punjabi": "pa",
    "Pushtu": "ps",
    "Portuguese": "pt",
    "Romanian": "ro",
    "Russian": "ru",
    "Thai": "th",
    "Urdu": "ur",
    "Uzbek": "uz",
  };

  trans() {
    result = ModalRoute.of(context)!.settings.arguments as String;
    translator.translate(result, to: "$dropdownValue").then((value) {
      setState(() {
        output = value.text;
      });
    });
  }

  writeOnPdf() {
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Header(
              level: 0,
              child: pw.Text(output),
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
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          'Translation',
          style: TextStyle(fontSize: 25),
        ),
      ),
      backgroundColor: Colors.blueAccent,
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
                    children: [
                      const Text(
                        'Select Language',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      DropdownButton<String>(
                        value: dropdownValue,
                        icon: const Icon(
                          Icons.arrow_downward,
                          color: Colors.black,
                        ),
                        iconSize: 35,
                        elevation: 25,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600),
                        underline: Container(
                          height: 5,
                          color: Colors.black,
                        ),
                        onChanged: (newValue) {
                          setState(() {
                            dropdownValue = newValue;
                            trans();
                          });
                        },
                        items: lang
                            .map((string, value) {
                              return MapEntry(
                                string,
                                DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(string),
                                ),
                              );
                            })
                            .values
                            .toList(),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            output == null
                                ? "Please Select Language"
                                : output.toString(),
                            style: const TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
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
                        onTap: () async {
                          await Clipboard.setData(ClipboardData(text: output))
                              .then((value) {
                            Utils.toastMessage("Text Copied");
                          }).onError((error, stackTrace) {
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
                            Icons.picture_as_pdf,
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
      )),
    );
  }
}
