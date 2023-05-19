import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Image_to_text extends StatefulWidget {
  const Image_to_text({Key? key}) : super(key: key);

  @override
  State<Image_to_text> createState() => _Image_to_textState();
}

class _Image_to_textState extends State<Image_to_text> {
  String result = "";
  File? image;
  late Future<File> imageFile;
  ImagePicker? imagePicker;

  performImageLabelling()async
  {
    final FirebaseVisionImage firebaseVisionImage =FirebaseVisionImage.fromFile(image);
    final TextRecognizer recognizer = FirebaseVision.instance.textRecognizer();
    VisionText visionText = await recognizer.processImage(firebaseVisionImage);
    result="";
    setState(() {
      for(TextBlock block in visionText.blocks)
      {
        // final String txt = block.text;
        for(TextLine line in block.lines)
        {
          result +="${line.text}\n";
          // for(TextElement element in line.elements)
          // {
          //   result +="${element.text} ";
          // }
        }
        // result += "\n\n";
      }
    });
  }
  pickImageFromGallary() async {
    XFile? pickedFile =await imagePicker?.pickImage(source: ImageSource.gallery);
    image = File(pickedFile!.path);
    setState(() {
      image;
      performImageLabelling();
    });
  }

  captureImageWithCamera() async {
    XFile? pickedFile =await imagePicker?.pickImage(source: ImageSource.camera);
    image = File(pickedFile!.path);
    setState(() {
      image;
      performImageLabelling();
    });
  }

  @override
  void initState()
  {
    super.initState();
    imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Image To Text Converter'),
          centerTitle: true,
          leading: const Icon(
            Icons.home,
            color: Colors.white,
            size: 30,
          ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.info,
                  color: Colors.white,
                  size: 27,
                ))
          ],
          backgroundColor: Colors.teal.shade800,
        ),
        bottomNavigationBar: CurvedNavigationBar(
            animationDuration: const Duration(milliseconds: 300),
            backgroundColor: Colors.white,
            color: Colors.teal.shade800,
            index: 1,
            onTap: (index) {
              if (index == 0) {
                pickImageFromGallary();
              } else if (index == 2) {
                captureImageWithCamera();
              }
            },
            items: const [
              Icon(
                Icons.image,
                size: 35,
                color: Colors.white,
              ),
              Icon(
                Icons.home,
                size: 35,
                color: Colors.white,
              ),
              Icon(
                Icons.camera_alt,
                size: 35,
                color: Colors.white,
              )
            ]),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.2,
              ),
            ),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                padding: const EdgeInsets.only(top: 30),
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/home.png'))),
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        child: image != null
                            ? Image.file(
                          image!,
                          fit: BoxFit.cover,
                        )
                            : const SizedBox(),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 115,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.teal.shade800,
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'translation',arguments: result);
                    },
                    child: const Text(
                      "Convert",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }
}
