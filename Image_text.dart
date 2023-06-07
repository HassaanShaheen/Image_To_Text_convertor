import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageToText extends StatefulWidget {
  const ImageToText({Key? key}) : super(key: key);

  @override
  State<ImageToText> createState() => _ImageToTextState();
}

class _ImageToTextState extends State<ImageToText> {
  String result = "";
  File? image;
  List<File> imageHistory = [];
  CroppedFile? croppedFile;
  late Future<File> imageFile;
  ImagePicker? imagePicker;

  performImageLabeling() async {
    final FirebaseVisionImage firebaseVisionImage =
    FirebaseVisionImage.fromFile(image!);
    final TextRecognizer recognizer = FirebaseVision.instance.textRecognizer();
    VisionText visionText = await recognizer.processImage(firebaseVisionImage);
    result = "";
    setState(() {
      for (TextBlock block in visionText.blocks) {
        for (TextLine line in block.lines) {
          result += "${line.text}\n";
        }
      }
    });
  }

  pickImageFromGallery() async {
    XFile? pickedFile =
    await imagePicker?.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      CroppedFile? croppedFile = (await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.blueAccent,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
        ],
      ));
      if (croppedFile != null) {
        setState(() {
          image = File(croppedFile!.path);
          imageHistory.add(image!);
          performImageLabeling();
        });
      }
    }
  }

  captureImageWithCamera() async {
    XFile? pickedFile =
    await imagePicker?.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      croppedFile = (await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.blueAccent,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
        ],
      ));
      if (croppedFile != null) {
        setState(() {
          image = File(croppedFile!.path);
          imageHistory.add(image!);
          performImageLabeling();
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        title: const Text(
          'Image To Text Converter',
          style: TextStyle(fontSize: 25),
        ),
        leading: const Icon(
          Icons.home,
          color: Colors.white,
          size: 45,
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: 750,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 30),
                          width: 250,
                          height: 250,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/icon.png'),
                            ),
                          ),
                          child: image != null
                              ? Image.file(
                            image!,
                            fit: BoxFit.cover,
                          )
                              : const SizedBox(),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 135,
                          height: 55,
                          decoration: const BoxDecoration(
                            color: Colors.blueAccent,
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                'Converted',
                                arguments: result,
                              );
                            },
                            child: const Text(
                              "Convert",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 55,
                    color: Colors.blueAccent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () async{
                            Map<Permission, PermissionStatus> statuses = await [
                              Permission.storage, Permission.camera,
                            ].request();
                            if(statuses[Permission.storage]!.isGranted && statuses[Permission.camera]!.isGranted){
                              pickImageFromGallery();
                            }                   },
                          icon: const Icon(
                            Icons.image,
                            size: 45,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () async{
                            Map<Permission, PermissionStatus> statuses = await [
                              Permission.storage, Permission.camera,
                            ].request();
                            if(statuses[Permission.storage]!.isGranted && statuses[Permission.camera]!.isGranted){
                              pickImageFromGallery();
                            }                   },
                          icon: const Icon(
                            Icons.camera_alt,
                            size: 45,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Image History'),
                                content: SizedBox(
                                  width: double.maxFinite,
                                  height: 300,
                                  child: ListView.builder(
                                    itemCount: imageHistory.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        leading: Image.file(
                                          imageHistory[index],
                                          width: 50,
                                          height: 50,
                                        ),
                                        title: Text(
                                          'Image ${index + 1}',
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.history,
                            size: 45,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
