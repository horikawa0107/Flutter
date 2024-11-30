import 'dart:io';
import 'package:crop_your_image/crop_your_image.dart';
import 'dart:async' show Future;
import 'dart:ui' as ui;
import 'dart:async';
import 'dart:typed_data';
import "game.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:flutter/services.dart';




enum ScreenMode { liveFeed, gallery }



class SelectPage extends StatefulWidget {
  @override
  _SelectPageState createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
    ),
  );
  bool _canProcess = true;
  bool _isBusy = false;
  String? _text;
  String imageUrl = '';
  ui.Image? _croppedImage_nose;
  ui.Image? _croppedImage_rightEye;
  ui.Image? _croppedImage_mouth;
  ui.Image? _croppedImage_leftEye;
  ui.Image? _uiImage;
  File? _image;
  Image? _image2;
  String? _path;
  final picker = ImagePicker();
  //xy[gxs,gys,height,width]
  List<double> xy_nose = [];
  List<double> xy_rightEye = [];
  List<double> xy_leftEye = [];
  List<double> xy_mouth = [];





  /// File型からui.Image型に変換
  Future<ui.Image?> _convertToUiImage(File file) async {
    try {
      final Uint8List bytes = await file.readAsBytes();
      final completer = Completer<ui.Image>();
      ui.decodeImageFromList(bytes, (ui.Image img) {
        completer.complete(img);
      });
      return await completer.future;
    } catch (e) {
      print("エラー: $e");
      return null;
    }
  }

  /// 画像を取得して処理
  Future<void> _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      print("No pickFile");
      return;
    }

    final file = File(pickedFile.path);
    setState(() {
      _image2 = Image.file(file); // Image.fileに格納
    });

    print("ダウンロードした画像の型は${_image2.runtimeType}");

    // Fileからui.Image型に変換
    final uiImage = await _convertToUiImage(file);

    if (uiImage != null) {
      await _processPickedFile(pickedFile);
      setState(() {
        _uiImage = uiImage; // ui.Image型を格納
      });
      print("ui.Imageに変換成功: 幅 ${uiImage.width}, 高さ ${uiImage.height}");
    } else {
      print("ui.Imageへの変換に失敗しました");
    }
  }




  /// File型からui.Image型に変換する関数
  Future<ui.Image?> fileToUiImage(XFile file) async {
    try {
      // 1. Fileからバイトデータを読み取る
      final Uint8List bytes = await file.readAsBytes();

      // 2. バイトデータをui.Imageに変換
      final completer = Completer<ui.Image>();
      ui.decodeImageFromList(bytes, (ui.Image img) {
        completer.complete(img);
      });

      return await completer.future;
    } catch (e) {
      print("エラー: $e");
      return null;
    }
  }



  Future<void> _loadImage2() async {
    if (_uiImage == null) return;
    print(xy_nose);
    print("_loadImage2 start");
    print(xy_nose[3]);
    print(xy_nose[2]);

    // 切り抜き範囲
    final cropRect_nose = Rect.fromLTWH(xy_nose[0]!, xy_nose[1]!, xy_nose[3]!, xy_nose[2]!);
    final cropRect_rightEye = Rect.fromLTWH(xy_rightEye[0]!, xy_rightEye[1]!, xy_rightEye[3]!, xy_rightEye[2]!);
    final cropRect_leftEye = Rect.fromLTWH(xy_leftEye[0]!, xy_leftEye[1]!, xy_leftEye[3]!, xy_leftEye[2]!);
    final cropRect_mouth = Rect.fromLTWH(xy_mouth[0]!, xy_mouth[1]!, xy_mouth[3]!, xy_mouth[2]!);

    print(cropRect_nose);

    // 画像を切り抜き
    final cropped_nose = await cropImage(_uiImage!, cropRect_nose);
    final cropped_righEye = await cropImage(_uiImage!, cropRect_rightEye);
    final cropped_leftEye = await cropImage(_uiImage!, cropRect_leftEye);
    final cropped_mouth = await cropImage(_uiImage!, cropRect_mouth);

    print("cropped ok");

    // 状態を更新
    setState(() {
      _croppedImage_nose = cropped_nose;
      _croppedImage_rightEye = cropped_righEye;
      _croppedImage_leftEye = cropped_leftEye;
      _croppedImage_mouth=cropped_mouth;

    });
    print("setStates ok");
  }

  Future<ui.Image> cropImage(
      ui.Image image, // 元の画像
      Rect cropRect,  // 切り抜きたい領域
      ) async {
    // 新しい画像の幅と高さ
    print(cropRect);
    final int newWidth = cropRect.width.toInt();
    final int newHeight = cropRect.height.toInt();
    print("画像の幅は${newWidth}です");
    print("画像の高さは${newHeight}です");

    // PictureRecorderを使用して描画
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // 切り抜く範囲を描画
    final paint = Paint();
    canvas.drawImageRect(
      image,
      cropRect, // 元画像の切り抜き範囲
      Rect.fromLTWH(0, 0, newWidth.toDouble(), newHeight.toDouble()), // 新しい画像の描画範囲
      paint,
    );

    // 新しい画像を生成
    final picture = recorder.endRecording();
    return await picture.toImage(newWidth, newHeight);
  }


  Future _processPickedFile(XFile? pickedFile) async {
    final path = pickedFile?.path;
    if (path == null) {
      return;
    }
    setState(() {
      _image = File(path);
      _path = path;
    });
    print(_path);

    final inputImage = InputImage.fromFilePath(path);
    processImage(inputImage);
    print("inputimageの型は${_image.runtimeType}");
    // widget.onImage(inputImage);
  }

  Future<void> processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });



    print("画像の型は${inputImage.runtimeType}");
    final faces = await _faceDetector.processImage(inputImage);
    print(faces.runtimeType);
    String text = '検出された顔の数: ${faces.length}\n\n';

    for (final face in faces) {
      text += 'smilingProbabilityの値: ${(face.smilingProbability! * 100).floor()}%\n\n';
      final nose = face.contours[FaceContourType.noseBottom];
      final leftEyeContour = face.contours[FaceContourType.leftEye];
      final rightEyeContour = face.contours[FaceContourType.rightEye];
      final noseBridge = face.contours[FaceContourType.noseBridge];
      final noseBottom = face.contours[FaceContourType.noseBottom];
      final upperLipTop = face.contours[FaceContourType.upperLipTop];
      final lowerLipBottom = face.contours[FaceContourType.lowerLipBottom];

      if (upperLipTop != null && lowerLipBottom != null) {
        text += '口の座標:\n';

        // 上唇と下唇の全座標を結合
        final lipPoints = [...upperLipTop.points, ...lowerLipBottom.points];

        int xs = 10000;
        int xe = 0;
        int ys = 10000;
        int ye = 0;

        for (var point in lipPoints) {
          text += '(${point.x.toStringAsFixed(2)}, ${point.y.toStringAsFixed(2)})\n';

          // 最小値と最大値を計算
          if (point.x < xs) xs = point.x;
          if (point.x > xe) xe = point.x;
          if (point.y < ys) ys = point.y;
          if (point.y > ye) ye = point.y;
        }

        text += '\n口領域のX範囲: xs=${xs.toStringAsFixed(2)}, xe=${xe.toStringAsFixed(2)}\n';
        text += '口領域のY範囲: ys=${ys.toStringAsFixed(2)}, ye=${ye.toStringAsFixed(2)}\n';

        setState(() {
          xy_mouth = [
            double.parse(xs.toStringAsFixed(2)),
            double.parse(ys.toStringAsFixed(2)),
            double.parse(ye.toStringAsFixed(2)) - double.parse(ys.toStringAsFixed(2)),
            double.parse(xe.toStringAsFixed(2)) - double.parse(xs.toStringAsFixed(2))
          ];
        });
      }
      if (noseBridge != null && noseBottom != null) {
        text += '鼻の座標:\n';
        final nosePoints = [...noseBridge.points, ...noseBottom.points]; // 鼻全体の座標
        int xs=10000;
        int xe=0;
        int ys=10000;
        int ye=0;
        for (var point in nosePoints) {
          text += '(${point.x.toStringAsFixed(2)}, ${point.y.toStringAsFixed(2)})\n';

          // 最小値と最大値を計算
          if (point.x < xs) xs = point.x;
          if (point.x > xe) xe = point.x;
          if (point.y < ys) ys = point.y;
          if (point.y > ye) ye = point.y;
        }
        text += '\n鼻領域のX範囲: xs=${xs.toStringAsFixed(2)}, xe=${xe.toStringAsFixed(2)}\n';
        text += '鼻領域のY範囲: ys=${ys.toStringAsFixed(2)}, ye=${ye.toStringAsFixed(2)}\n';
        setState(() {
          xy_nose=[double.parse(xs.toStringAsFixed(2)),double.parse(ys.toStringAsFixed(2)),double.parse(ye.toStringAsFixed(2))-double.parse(ys.toStringAsFixed(2)),double.parse(xe.toStringAsFixed(2))-double.parse(xs.toStringAsFixed(2))];

        });
      }
      if (rightEyeContour != null) {
        text += '右目の座標:\n';
        int xs=10000;
        int xe=0;
        int ys=10000;
        int ye=0;
        for (var point in rightEyeContour.points) {
          text += '(${point.x.toStringAsFixed(2)}, ${point.y.toStringAsFixed(2)})\n';

          // 最小値と最大値を計算
          if (point.x < xs) xs = point.x;
          if (point.x > xe) xe = point.x;
          if (point.y < ys) ys = point.y;
          if (point.y > ye) ye = point.y;

        }
        text += '\n右目領域のX範囲: xs=${xs.toStringAsFixed(2)}, xe=${xe.toStringAsFixed(2)}\n';
        text += '右目領域のY範囲: ys=${ys.toStringAsFixed(2)}, ye=${ye.toStringAsFixed(2)}\n';
        setState(() {
          xy_rightEye=[double.parse(xs.toStringAsFixed(2)),
            double.parse(ys.toStringAsFixed(2)),
            double.parse(ye.toStringAsFixed(2))-double.parse(ys.toStringAsFixed(2)),
            double.parse(xe.toStringAsFixed(2))-double.parse(xs.toStringAsFixed(2))];

        });
      }
      if (leftEyeContour != null) {
        text += '左目の座標:\n';
        int xs=10000;
        int xe=0;
        int ys=10000;
        int ye=0;
        for (var point in leftEyeContour.points) {
          text += '(${point.x.toStringAsFixed(2)}, ${point.y.toStringAsFixed(2)})\n';

          // 最小値と最大値を計算
          if (point.x < xs) xs = point.x;
          if (point.x > xe) xe = point.x;
          if (point.y < ys) ys = point.y;
          if (point.y > ye) ye = point.y;

        }
        text += '\n左目領域のX範囲: xs=${xs.toStringAsFixed(2)}, xe=${xe.toStringAsFixed(2)}\n';
        text += '左目領域のY範囲: ys=${ys.toStringAsFixed(2)}, ye=${ye.toStringAsFixed(2)}\n';
        setState(() {
          xy_leftEye=[double.parse(xs.toStringAsFixed(2)),
            double.parse(ys.toStringAsFixed(2)),
            double.parse(ye.toStringAsFixed(2))-double.parse(ys.toStringAsFixed(2)),
            double.parse(xe.toStringAsFixed(2))-double.parse(xs.toStringAsFixed(2))];

        });
      }

      _text = text;
      print(_text);
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFF98),
      appBar: AppBar(
        title: Text('福笑い'),
        backgroundColor: Color(0xFFFFFF98),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
              Container(
                width: 200.0,
                height: 200.0,
                decoration: BoxDecoration(border: Border.all(
                  // color: Color(0xFF89A64B),
                  width: 8.0,
                ),
                ),
                child: _image2 == null ?
                const Text('画像がありません')
                    : _image2,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  child: const Text('写真選択',
                    style: TextStyle(
                      fontSize: 35,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(200, 100),
                    // primary: Color(0xFF89A64B),
                    // onPrimary: Colors.white,
                  ),
                  onPressed: _getImage,
                ),
                ElevatedButton(
                  child: const Text('start!',
                    style: TextStyle(
                      fontSize: 35,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(200, 100),
                    // primary: Color(0xFF89A64B),
                    // onPrimary: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => GamePage(_croppedImage_nose!,_croppedImage_rightEye!,_croppedImage_leftEye!,_croppedImage_mouth!)
                    ));
                  },
                ),

                FloatingActionButton(
                  onPressed: _loadImage2,
                  tooltip: 'crop image From assets',
                  child: Icon(Icons.android),
                ),

              ],
            )
          ],
        ),
      ),
    );
  }
}
class ImagePainter extends CustomPainter {
  final ui.Image image;

  ImagePainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(image, Offset.zero, Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
