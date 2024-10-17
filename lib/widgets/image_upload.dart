import 'dart:typed_data';
import 'dart:html' as html;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({
    super.key,
    required this.onTapHandler,
  });
  final List<int>? Function(List<int>? SF) onTapHandler;

  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  List<int>? _selectedFile;
  Uint8List? _bytesData;

  startWebFilePicker() async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = true;
    uploadInput.draggable = true;
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final files = uploadInput.files;
      final file = files![0];
      final reader = html.FileReader();

      reader.onLoadEnd.listen((event) {
        setState(() {
          _bytesData = const Base64Decoder()
              .convert(reader.result.toString().split(",").last);
          _selectedFile = _bytesData;
          var ex = reader.result.toString().split(".").last;
          widget.onTapHandler(_selectedFile);
          print("BOTAN: $ex");
        });
      });
      reader.readAsDataUrl(file);
    });
  }

  Future uploadImage() async {
    var url = Uri.parse("API URL HERE...");
    var request = http.MultipartRequest("POST", url);
    request.files.add(http.MultipartFile.fromBytes('file', _selectedFile!,
        contentType: MediaType('application', 'json'), filename: "Any_name"));

    request.send().then((response) {
      if (response.statusCode == 200) {
        print("File uploaded successfully");
      } else {
        print('file upload failed');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          const Text('Let\'s upload Image'),
          const SizedBox(height: 20),
          MaterialButton(
            color: Colors.pink,
            elevation: 8,
            highlightElevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            textColor: Colors.white,
            child: const Text("Select Photo"),
            onPressed: () {
              startWebFilePicker();
            },
          ),
          const Divider(
            color: Colors.teal,
          ),
          _bytesData != null
              ? Image.memory(_bytesData!, width: 200, height: 200)
              : Container(),
          MaterialButton(
            color: Colors.purple,
            elevation: 8,
            highlightElevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            textColor: Colors.white,
            child: const Text("Send file to server"),
            onPressed: () {
              uploadImage();
            },
          ),
        ],
      )),
    );
  }
}
