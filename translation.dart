import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:semesterproject/utils.dart';
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

  static const Map<String, String> lang = {
    "Arabic": "ar",
    "Bengali": "bn",
    "Chinese": "zh-cn",
    "Danish": "da",
    "Dutch": "nl",
    "English" :"en",
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
    "Polish":"pl",
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
    translator
        .translate(result, to: "$dropdownValue")
        .then((value) {
      setState(() {
        output = value.text;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade800,
        title: const Text(
          'Text Translation',
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children:  [
              GestureDetector(
                onTap: () async{
                  await Clipboard.setData(ClipboardData(text: result)).then((value){
                    Utils.toastMessage("Text Copied");
                  }).onError((error, stackTrace){
                    Utils.toastMessage("Text Not Copied Successfully ");
                  });
                },
                child: const Icon(
                  Icons.copy,
                  size: 50.0,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Processed Text',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 200,
                child: SingleChildScrollView(
                  child: Text(
                    ModalRoute.of(context)!.settings.arguments as String,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15
                    ),
                  ),
                ),
              ),
              const Text('Select Language Here',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.black
                ),
              ),

              DropdownButton<String>(
                value: dropdownValue,
                icon: const Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: ( newValue) {
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
                }
                )
                    .values
                    .toList(),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async{
                  await Clipboard.setData(ClipboardData(text: output)).then((value){
                    Utils.toastMessage("Text Copied");
                  }).onError((error, stackTrace){
                    Utils.toastMessage("Text Not Copied Successfully ");
                  });
                },
                child: const Icon(
                  Icons.copy,
                  size: 50.0,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Translated Text',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    output == null ? "Please Select Language" : output.toString(),
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
        ],
      ),
    );
  }
}