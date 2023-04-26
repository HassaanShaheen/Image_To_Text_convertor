import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Image_to_text extends StatefulWidget {
  const Image_to_text({Key? key}) : super(key: key);

  @override
  State<Image_to_text> createState() => _Image_to_textState();
}

class _Image_to_textState extends State<Image_to_text> {

  String result ="";
   File ?image;
   late Future<File> imageFile;
   ImagePicker? imagePicker;

   PerformImageLabelling()async
   {
     final FirebaseVisionImage firebaseVisionImage =FirebaseVisionImage.fromFile(image);
     final TextRecognizer recognizer = FirebaseVision.instance.textRecognizer();
     VisionText visionText = await recognizer.processImage(firebaseVisionImage);
     result="";
     setState(() {
       for(TextBlock block in visionText.blocks)
         {
           final String txt = block.text;
           for(TextLine line in block.lines)
             {
               for(TextElement element in line.elements)
                 {
                   result +="${element.text} ";
                 }
             }
           result += "\n\n";
         }
     });
   }

  pickImageFromGallary()async
  {
    PickedFile? pickedFile= await imagePicker?.getImage(source: ImageSource.gallery);
    image =File(pickedFile!.path);
    setState(() {
      image;

      PerformImageLabelling();
    });
  }


  captureImageWithCamera()async
  {
    PickedFile? pickedFile= await imagePicker?.getImage(source: ImageSource.camera);
    image =File(pickedFile!.path);
    setState(() {
      image;

      PerformImageLabelling();
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
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/pic.jpg'),
              fit: BoxFit.cover,
            )
        ),
        child: Column(
          children: [
            const SizedBox(width: 100,),
            Container(
              height: 280,
              width: 380,
              margin: const EdgeInsets.only(top: 50),
              padding: const EdgeInsets.only(left: 8, bottom: 5, right: 18),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/book.jpeg'),
                  )
              ),
              child:  SingleChildScrollView(
                child: Padding(padding: const EdgeInsets.all(12.0),
                  child:Text(
                    result,
                    style: const TextStyle(
                      fontSize:16.0,
                    ),
                    textAlign: TextAlign.justify,
                  )
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: TextButton(
                    onPressed: (){},
                    child: const SizedBox(
                      width: 45.0,
                      height: 30.0,
                      child: Icon(
                        Icons.cut,
                        size: 30.0,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: TextButton(
                    onPressed: (){},
                    child: const SizedBox(
                      width: 45.0,
                      height: 30.0,
                      child: Icon(
                        Icons.copy,
                        size: 30.0,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: (){},
                  child: const SizedBox(
                    width: 45.0,
                    height: 30.0,
                    child: Icon(
                      Icons.paste,
                      size: 30.0,
                      color: Colors.blueGrey,
                    ),
                  ),
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, right: 140),
              child: Stack(
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Image.asset('assets/clipboard.jpeg',
                          height: 240,
                          width: 240,
                        ),
                      )
                    ],
                  ),
                  Center(
                    child:TextButton(
                      onPressed: ()
                      {
                        pickImageFromGallary();
                      },
                      onLongPress: ()
                        {
                          captureImageWithCamera();
                        },
                      child: Container(
                        margin: const EdgeInsets.only(top: 25),
                        child: image!=null
                          ? Image.file(image! , width: 140, height: 140, fit: BoxFit.cover)
                            :const SizedBox(
                          width: 250,
                          height: 200,
                          child: Icon(
                            Icons.camera_front,
                            size: 100,
                            color: Colors.blueGrey,
                          ),
                        )
                      ),
                    )
                  ),
                ],
              ),

            )
          ],
        ),
        ),
      );
  }
}
