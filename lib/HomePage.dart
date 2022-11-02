import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:ipfs_rpc/ipfs_rpc.dart';

import 'package:connecwalletflutter/pinata.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ipfs = IPFS();

// Optional - Configuration

uploadToIpfs() async{
  // Optional - Configuration
  ipfs.client.init(
    scheme: 'http',
    host: 'ipfs.infura.io',
    port: 5001,
    verbose: true,
  );

  debugPrint('requesting...');
  final result = await ipfs.files.ls();

  result.fold(
        (error) { // ERROR
      debugPrint(error.toJson().toString());
    },
        (response) { // SUCCESS
      debugPrint(response.toJson().toString());
    },
  );

  debugPrint('request done');
}

  File? image;
  final _picker = ImagePicker();

  // Pick an image
  pikImage() async{
    final XFile? selectedImage = await _picker.pickImage(source: ImageSource.gallery);
    if(selectedImage!=null){
      setState(() {
        image =File(selectedImage.path);
        // uploadImage(selectedImage.path);
        // uploadPinateImage(image.path)

      });
    }else{
      print("Error at pik image");
    }

  }


  pickerFile()async{
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        print(result);
        uploadPinateImage(result.files.single);
        setState(() {
          // image =(result.files.single)[0];
          // uploadImage(selectedImage.path);
          // uploadPinateImage(image.path)

        });

      });
      // File file = File(result.files.single);
    } else {
      // User canceled the picker
    }

  }

  static Future<String> uploadPinateImage(PlatformFile image) async {
    try {
      final imageBytes = image.bytes;
      PinataClient pinataClient = PinataClient();
      await pinataClient.setHeaders();
      String url =
      await pinataClient.uploadFileToPinata(imageBytes!, image.name);
      print("url urlurl $url");
      return url;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  //IPFS upload image
  final nftStorageKey="5246faece5a85cca47ffd4001842d482";


  Future<String> uploadImage(String imgPath) async {
    try {
      final bytes = File(imgPath).readAsBytesSync();

      final response = await http.post(
        Uri.parse('https://api.nft.storage/upload'),
        headers: {
          'Authorization': 'Bearer $nftStorageKey',
          'content-type': 'image/*'
        },
        body: bytes,
      );

      final data = jsonDecode(response.body);
      print("data $data");

      final cid = data['value']['cid'];

      debugPrint('CID OF IMAGE -> $cid');

      return cid;
    } catch (e) {
      debugPrint('Error at IPFS Service - uploadImage: $e');

      rethrow;
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
                uploadToIpfs();
              }, child: Text("Ipfs Uplaod")),
              TextButton(onPressed: (){
                setState(() {

                });
                pickerFile();
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
