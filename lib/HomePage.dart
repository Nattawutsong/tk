import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'dart:io';

class ImageClassificationPage extends StatefulWidget {
  @override
  _ImageClassificationPageState createState() =>
      _ImageClassificationPageState();
}

class _ImageClassificationPageState extends State<ImageClassificationPage> {
  File? _image;
  List? _predictions;
  final ImagePicker _picker = ImagePicker();
  bool _isModelLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    String? result = await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
    if (result != null) {
      setState(() {
        _isModelLoaded = true;
      });
    }
  }

  Future<void> _classifyImage(File image) async {
    var predictions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 5,
      threshold: 0.0, // แสดงผลลัพธ์ทั้งหมด
    );

    setState(() {
      _predictions = predictions;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      File image = File(pickedFile.path);
      setState(() {
        _image = image;
      });
      await _classifyImage(image);
    }
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Classification'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_image != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.file(
                  _image!,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
            if (_predictions != null)
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _predictions!.length,
                  itemBuilder: (context, index) {
                    final prediction = _predictions![index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                      child: ListTile(
                        title: Text(
                          prediction['label'],
                          style: TextStyle(fontSize: 18),
                        ),
                        subtitle: Text(
                          "Confidence: ${(prediction['confidence'] * 100).toStringAsFixed(2)}%",
                        ),
                        leading: CircleAvatar(
                          child: Text(
                            "#${index + 1}",
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.blueAccent,
                        ),
                      ),
                    );
                  },
                ),
              ),
            if (_image == null)
              Text(
                "กรุณาอัปโหลดหรือถ่ายภาพเพื่อทำการจำแนก",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: Icon(Icons.camera),
                  label: Text("กล้อง"),
                ),
                SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: Icon(Icons.photo),
                  label: Text("แกลเลอรี"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
