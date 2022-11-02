import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';


class PinataClient {
  final PINATA_API_KEY="2509619d906b00b56fa8";
  final PINATA_SECRET_KEY="70c0c4c16271cc081a8463e250adfcd4805f50062721eb3d06c561c2ada17c28";
  final PINATA_JWT="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySW5mb3JtYXRpb24iOnsiaWQiOiIyOWNjMjc0ZS1hYmMzLTRmMDItYTdjNC1jMWU1ZGExNDQzZTAiLCJlbWFpbCI6Im1iY29tcGFueTg4OEBnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwicGluX3BvbGljeSI6eyJyZWdpb25zIjpbeyJpZCI6IkZSQTEiLCJkZXNpcmVkUmVwbGljYXRpb25Db3VudCI6MX0seyJpZCI6Ik5ZQzEiLCJkZXNpcmVkUmVwbGljYXRpb25Db3VudCI6MX1dLCJ2ZXJzaW9uIjoxfSwibWZhX2VuYWJsZWQiOmZhbHNlLCJzdGF0dXMiOiJBQ1RJVkUifSwiYXV0aGVudGljYXRpb25UeXBlIjoic2NvcGVkS2V5Iiwic2NvcGVkS2V5S2V5IjoiMjUwOTYxOWQ5MDZiMDBiNTZmYTgiLCJzY29wZWRLZXlTZWNyZXQiOiI3MGMwYzRjMTYyNzFjYzA4MWE4NDYzZTI1MGFkZmNkNDgwNWY1MDA2MjcyMWViM2QwNmM1NjFjMmFkYTE3YzI4IiwiaWF0IjoxNjY2NjE2OTAxfQ.CIMGMJ7qMvMrxBG3tMH3OL8dhfhy1MedWP_Y-_DyBG0";
  late Dio dio;
  //Endpoint URls
  static String pinataEndPoint =
      "https://api.pinata.cloud/pinning/pinFileToIPFS";

  PinataClient() {
    dio = Dio();
  }

  Future<void> setHeaders() async {
    dio.options.headers['Authorization'] = "Bearer " + PINATA_JWT!;
    dio.options.headers['pinata_api_key'] = PINATA_API_KEY!;

    dio.options.headers['pinata_secret_api_key'] = PINATA_SECRET_KEY!;
    dio.options.headers['Content-Type'] = "multipart/form-data";


  }

  Future<String> uploadFileToPinata(
      Uint8List fileBytes, String fileName) async {
    try {
      FormData formData = FormData.fromMap({
        "file": MultipartFile.fromBytes(
          fileBytes,
          filename: fileName,
        ),
      });
      var result = await dio.post(pinataEndPoint, data: formData);
      debugPrint(result.data.toString());
      String url = "ipfs://ipfs/" + result.data['IpfsHash'];
      print("Url from pinata uplder $url");
      return url;
    } catch (e) {
      rethrow;
    }
  }
}