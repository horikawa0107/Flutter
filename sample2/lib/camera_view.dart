import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:image_picker/image_picker.dart';

enum ScreenMode { liveFeed, gallery }

class CameraView extends StatefulWidget {
  const CameraView({
    Key? key,
    this.text,
    required this.onImage,
  }) : super(key: key);

  final String? text;
  final Function(InputImage inputImage) onImage;

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  File? _image;
  // XFile? _image;
  String? _path;
  ImagePicker? _imagePicker;

  @override
  Widget build(BuildContext context) {
    // _imagePicker = ImagePicker();
    return _galleryBody();
  }
  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
  }

  Widget _galleryBody() {
    return ListView(shrinkWrap: true, children: [
      // ①選択された画像を表示
      _image != null
          ? SizedBox(height: 400, width: 400, child: Image.file(_image!))

      // ②画像未選択の場合はテキストを表示
          : const Padding(
        padding: EdgeInsets.symmetric(vertical: 80),
        child: Center(child: Text('画像を選択してください')),
      ),

      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ElevatedButton(
          child: const Text('From Gallery'),
          onPressed: () => _getImage(ImageSource.gallery),
        ),
      ),
      if (_image != null)
        Padding(
          padding: const EdgeInsets.all(16.0),

          // ③検出した顔の数と笑顔度を表示
          child: Text('${_path == null ? '' : ''}\n\n${widget.text ?? ''}'),
        ),
    ]);
  }

  // ④写真フォルダから画像を取得するための関数
  Future _getImage(ImageSource source) async {
    print("From Gallery button pressed");
    setState(() {
      _image = null;
      _path = null;
    });
    final pickedFile = await _imagePicker?.pickImage(source: source);
    if (pickedFile != null) {
      await _processPickedFile(pickedFile); // 非同期処理を待つ

      // _processPickedFile(pickedFile);
    }
    else{
      print("No pickFile");
    }
    setState(() {});
  }

  Future _processPickedFile(XFile? pickedFile) async {
    final path = pickedFile?.path;
    if (path == null) {
      return;
    }
    setState(() {
      _image = File(path);
    });
    _path = path;
    final inputImage = InputImage.fromFilePath(path);
    widget.onImage(inputImage);
  }
}