import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  File? image;
  final _picker = ImagePicker();

  // Pick an image
  pikImage() async{
    final XFile? selectedImage = await _picker.pickImage(source: ImageSource.gallery);
    if(selectedImage!=null){
      setState(() {
        image =File(selectedImage.path);
      });
    }else{
      print("Error at pik image");
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Uplod to Ipfs"),),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              TextButton(onPressed: (){
                setState(() {

                });
                pikImage();
              }, child: Text("Select Image")),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: image != null? Image.file(image!):Text("NO IMAGE SELECTED"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
