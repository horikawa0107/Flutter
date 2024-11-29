// import 'dart:typed_data';
//
// import 'package:crop_your_image/crop_your_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Crop Your Image Demo'),
//         ),
//         body: CropSample(),
//       ),
//     );
//   }
// }
//
// class CropSample extends StatefulWidget {
//   @override
//   _CropSampleState createState() => _CropSampleState();
// }
//
// class _CropSampleState extends State<CropSample> {
//   static const _images = const [
//     'assets/58.png'
//   ];
//
//   final _cropController = CropController();
//   final _imageDataList = <Uint8List>[];
//
//   var _loadingImage = false;
//   var _currentImage = 0;
//   set currentImage(int value) {
//     setState(() {
//       _currentImage = value;
//     });
//     _cropController.image = _imageDataList[_currentImage];
//   }
//
//   var _isSumbnail = false;
//   var _isCropping = false;
//   var _isCircleUi = false;
//   Uint8List? _croppedData;
//   var _statusText = '';
//
//   @override
//   void initState() {
//     _loadAllImages();
//     super.initState();
//   }
//
//   Future<void> _loadAllImages() async {
//     setState(() {
//       _loadingImage = true;
//     });
//     for (final assetName in _images) {
//       _imageDataList.add(await _load(assetName));
//     }
//     setState(() {
//       _loadingImage = false;
//     });
//   }
//
//   Future<Uint8List> _load(String assetName) async {
//     final assetData = await rootBundle.load(assetName);
//     return assetData.buffer.asUint8List();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       height: double.infinity,
//       child: Center(
//         child: Visibility(
//           visible: !_loadingImage && !_isCropping,
//           child: Column(
//             children: [
//               if (_imageDataList.length >= 4)
//                 Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Row(
//                     children: [
//                       _buildSumbnail(_imageDataList[0]),
//                       const SizedBox(width: 16),
//                       _buildSumbnail(_imageDataList[1]),
//                       const SizedBox(width: 16),
//                       _buildSumbnail(_imageDataList[2]),
//                       const SizedBox(width: 16),
//                       _buildSumbnail(_imageDataList[3]),
//                     ],
//                   ),
//                 ),
//               Expanded(
//                 child: Visibility(
//                   visible: _croppedData == null,
//                   child: Stack(
//                     children: [
//                       if (_imageDataList.isNotEmpty) ...[
//                         Crop(
//                           willUpdateScale: (newScale) => newScale < 5,
//                           controller: _cropController,
//                           image: _imageDataList[_currentImage],
//                           onCropped: (croppedData) {
//                             setState(() {
//                               _croppedData = croppedData;
//                               _isCropping = false;
//                             });
//                           },
//                           withCircleUi: _isCircleUi,
//                           onStatusChanged: (status) => setState(() {
//                             _statusText = <CropStatus, String>{
//                               CropStatus.nothing: 'Crop has no image data',
//                               CropStatus.loading:
//                               'Crop is now loading given image',
//                               CropStatus.ready: 'Crop is now ready!',
//                               CropStatus.cropping:
//                               'Crop is now cropping image',
//                             }[status] ??
//                                 '';
//                           }),
//                           initialSize: 0.5,
//                           maskColor: _isSumbnail ? Colors.white : null,
//                           cornerDotBuilder: (size, edgeAlignment) =>
//                           const SizedBox.shrink(),
//                           interactive: true,
//                           fixCropRect: true,
//                           radius: 20,
//                           initialRectBuilder: (viewportRect, imageRect) {
//                             return Rect.fromLTRB(
//                               viewportRect.left + 24,
//                               viewportRect.top + 24,
//                               viewportRect.right - 24,
//                               viewportRect.bottom - 24,
//                             );
//                           },
//                         ),
//                         IgnorePointer(
//                           child: Padding(
//                             padding: const EdgeInsets.all(24),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 border:
//                                 Border.all(width: 4, color: Colors.white),
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                       Positioned(
//                         right: 16,
//                         bottom: 16,
//                         child: GestureDetector(
//                           onTapDown: (_) => setState(() => _isSumbnail = true),
//                           onTapUp: (_) => setState(() => _isSumbnail = false),
//                           child: CircleAvatar(
//                             backgroundColor:
//                             _isSumbnail ? Colors.blue.shade50 : Colors.blue,
//                             child: Center(
//                               child: Icon(Icons.crop_free_rounded),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   replacement: Center(
//                     child: _croppedData == null
//                         ? SizedBox.shrink()
//                         : Image.memory(_croppedData!),
//                   ),
//                 ),
//               ),
//               if (_croppedData == null)
//                 Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           IconButton(
//                             icon: Icon(Icons.crop_7_5),
//                             onPressed: () {
//                               _isCircleUi = false;
//                               _cropController.aspectRatio = 16 / 4;
//                             },
//                           ),
//                           IconButton(
//                             icon: Icon(Icons.crop_16_9),
//                             onPressed: () {
//                               _isCircleUi = false;
//                               _cropController.aspectRatio = 16 / 9;
//                             },
//                           ),
//                           IconButton(
//                             icon: Icon(Icons.crop_5_4),
//                             onPressed: () {
//                               _isCircleUi = false;
//                               _cropController.aspectRatio = 4 / 3;
//                             },
//                           ),
//                           IconButton(
//                             icon: Icon(Icons.crop_square),
//                             onPressed: () {
//                               _isCircleUi = false;
//                               _cropController
//                                 ..withCircleUi = false
//                                 ..aspectRatio = 1;
//                             },
//                           ),
//                           IconButton(
//                               icon: Icon(Icons.circle),
//                               onPressed: () {
//                                 _isCircleUi = true;
//                                 _cropController.withCircleUi = true;
//                               }),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       Container(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           onPressed: () {
//                             setState(() {
//                               _isCropping = true;
//                             });
//                             _isCircleUi
//                                 ? _cropController.cropCircle()
//                                 : _cropController.crop();
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 16),
//                             child: Text('CROP IT!'),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 40),
//                     ],
//                   ),
//                 ),
//               const SizedBox(height: 16),
//               Text(_statusText),
//               const SizedBox(height: 16),
//             ],
//           ),
//           replacement: const CircularProgressIndicator(),
//         ),
//       ),
//     );
//   }
//
//   Expanded _buildSumbnail(Uint8List data) {
//     final index = _imageDataList.indexOf(data);
//     return Expanded(
//       child: InkWell(
//         onTap: () {
//           _croppedData = null;
//           currentImage = index;
//         },
//         child: Container(
//           height: 100,
//           decoration: BoxDecoration(
//             border: index == _currentImage
//                 ? Border.all(
//               width: 8,
//               color: Colors.blue,
//             )
//                 : null,
//           ),
//           child: Image.memory(
//             data,
//             fit: BoxFit.cover,
//           ),
//         ),
//       ),
//     );
//   }
// }
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

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hatch Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
  ui.Image? _croppedImage;
  ui.Image? _uiImage;
  File? _image;
  Image? _image2;
  String? _path;
  final picker = ImagePicker();
  double? gxs;
  double? gys;
  double? height;
  double? width;
  List<double> xy = [];



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


  Future<ui.Image>? loadImageFromAssets(String path) async {
    ByteData data = await rootBundle.load(path);
    return decodeImageFromList(data.buffer.asUint8List());
  }

  Future<ui.Image> convertFileToImage(File file) async {
    // ファイルデータをバイトリストに変換
    final Uint8List imageBytes = await file.readAsBytes();

    // バイトリストからui.Imageにデコード
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(imageBytes, (ui.Image img) {
      completer.complete(img);
    });
    print("変換された画像の型は${completer.runtimeType}");
    return completer.future;
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
    print("_loadImage2 start");
    print(width);
    print(height);

    // 切り抜き範囲
    final cropRect2 = Rect.fromLTWH(gxs!, gys!, width!, height!);
    print(cropRect2);

    // 画像を切り抜き
    final cropped = await cropImage(_uiImage!, cropRect2);

    print("cropped ok");

    // 状態を更新
    setState(() {
      _croppedImage = cropped;
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
    int xs=10000;
    int xe=0;
    int ys=10000;
    int ye=0;


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

      if (noseBridge != null && noseBottom != null) {
        text += '鼻の座標:\n';
        final nosePoints = [...noseBridge.points, ...noseBottom.points]; // 鼻全体の座標
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
              gxs = double.parse(xs.toStringAsFixed(2));
              height = double.parse(ye.toStringAsFixed(2))-double.parse(ys.toStringAsFixed(2));
              gys = double.parse(ys.toStringAsFixed(2));
              width = double.parse(xe.toStringAsFixed(2))-double.parse(xs.toStringAsFixed(2));
            });
      }
      // if (leftEyeContour != null) {
      //   text += '左目の座標:\n';
      //   for (var point in leftEyeContour.points) {
      //     text += '(${point.x.toStringAsFixed(2)}, ${point.y.toStringAsFixed(2)})\n';
      //
      //     // 最小値と最大値を計算
      //     if (point.x < xs) xs = point.x;
      //     if (point.x > xe) xe = point.x;
      //     if (point.y < ys) ys = point.y;
      //     if (point.y > ye) ye = point.y;
      //
      //   }
      //   text += '\n左目領域のX範囲: xs=${xs.toStringAsFixed(2)}, xe=${xe.toStringAsFixed(2)}\n';
      //   text += '左目領域のY範囲: ys=${ys.toStringAsFixed(2)}, ye=${ye.toStringAsFixed(2)}\n';
      //   setState(() {
      //     gxs = double.parse(xs.toStringAsFixed(2));
      //     height = double.parse(ye.toStringAsFixed(2))-double.parse(ys.toStringAsFixed(2));
      //     gys = double.parse(ys.toStringAsFixed(2));
      //     width = double.parse(xe.toStringAsFixed(2))-double.parse(xs.toStringAsFixed(2));
      //   });
      //   print("幅は${width}");
      //   print("高さは${height}");
      // }

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
      appBar: AppBar(
        title: Text('Image Picker Demo'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
                child:
              Container(
                width: 300,
                child: _croppedImage == null
                    ? Text('No image selected.')
                    : CustomPaint(
                                  painter: ImagePainter(_croppedImage!),
                                  size: Size(_croppedImage!.width.toDouble(), _croppedImage!.height.toDouble()),
                                ),),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FloatingActionButton(
                  onPressed: _getImage,
                  tooltip: 'Pick Image From Gallery',
                  child: Icon(Icons.photo_library),
                ),
                FloatingActionButton(
                  onPressed: _loadImage2,
                  tooltip: 'crop image From assets',
                  child: Icon(Icons.android),
                ),
                FloatingActionButton(
                  onPressed:(){ Navigator.push(
                      context, MaterialPageRoute(builder: (builder) => GamePage(_croppedImage!,_croppedImage!)));},
                  tooltip: 'crop image From assets',
                  child: Icon(Icons.home),
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
