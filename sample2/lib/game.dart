import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class GamePage extends StatefulWidget {
  final ui.Image _uiImage;
  final ui.Image _croppedImage_nose;
  final ui.Image _croppedImage_rightEye;
  final ui.Image _croppedImage_leftEye;
  final ui.Image _croppedImage_mouth;
  final ui.Image _croppedImage_face;
  final List list_color;


  const GamePage(this._uiImage,
      this._croppedImage_nose,
      this._croppedImage_rightEye,
      this._croppedImage_leftEye,
      this._croppedImage_mouth,
      this._croppedImage_face,
      this.list_color,
      {Key? key})
      : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  Offset _image1Offset = Offset(40,490); // 鼻
  Offset _image2Offset = Offset(125,490); // 右目
  Offset _image3Offset = Offset(200,490); // 左目
  Offset _image4Offset = Offset(280,490); // 口
  Offset _startDragOffset = Offset.zero;
  int? _draggingImageIndex;
  bool _finish = false;
  ui.Image? _displayedNoseImage;
  ui.Image? _displayedLeftEyeImage;
  ui.Image? _displayedRightEyeImage;
  ui.Image? _displayedMouthImage;
  ui.Image? _resizedNoseImage;
  ui.Image? _resizedrightEyeImage;
  ui.Image? _resizedleftEyeImage;
  ui.Image? _resizedMouthImage;
  @override
  void initState() {
    super.initState();
    _initializeNoseImage();
    _resizeNoseImage();
  }

  Future<void> _resizeNoseImage() async {
    final resizedNoseImage = await resizeImage(widget._croppedImage_nose, 0.1);
    final resizedrightEyeImage = await resizeImage(widget._croppedImage_rightEye, 0.1);
    final resizedleftEyeImage = await resizeImage(widget._croppedImage_leftEye, 0.1);
    final resizedMouthImage = await resizeImage(widget._croppedImage_mouth, 0.1);

    setState(() {
      _resizedNoseImage=resizedNoseImage;
      _resizedMouthImage=resizedMouthImage;
      _resizedrightEyeImage=resizedrightEyeImage;
      _resizedleftEyeImage=resizedleftEyeImage;
    });

  }
  Future<ui.Image> resizeImage(ui.Image image, double scale) async {
    // 元の画像サイズを取得
    final int newWidth = (image.width * scale).toInt();
    final int newHeight = (image.height * scale).toInt();

    // PictureRecorderとCanvasを使って新しい画像を描画
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // 画像を指定したスケールで描画
    final paint = Paint();
    final srcRect = Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    final dstRect = Rect.fromLTWH(0, 0, newWidth.toDouble(), newHeight.toDouble());

    canvas.drawImageRect(image, srcRect, dstRect, paint);

    // PictureRecorderから画像を生成
    final picture = recorder.endRecording();
    final newImage = await picture.toImage(newWidth, newHeight);

    return newImage;
  }


  Future<void> _initializeNoseImage() async {
    // 最初は黒塗りの画像を表示

    if (widget.list_color!=null) {
      final obeject_nose = await _createBlackFilledImage(
          60, 60, widget.list_color![0]);
      final obeject_leftaEye = await _createBlackFilledImage(
          60, 60, widget.list_color![2]);
      final obeject_rightaEye = await _createBlackFilledImage(
          60, 60, widget.list_color![1]);
      final obeject_mouth = await _createBlackFilledImage(
          60, 60, widget.list_color![3]);

      setState(() {
        _displayedNoseImage = obeject_nose;
        _displayedLeftEyeImage =obeject_leftaEye;
        _displayedRightEyeImage=obeject_rightaEye;
        _displayedMouthImage=obeject_mouth;
      });
    }

    // widget._croppedImage_nose.width, widget._croppedImage_nose.height);

  }

  Future<ui.Image> _createBlackFilledImage(int width, int height,Color color) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()));
    final paint = Paint()..color = color;

    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), paint);

    final picture = recorder.endRecording();
    return await picture.toImage(width, height);
  }

  void _resetToOriginalNose() {
    setState(() {
      _displayedNoseImage = this._resizedNoseImage;
      _displayedLeftEyeImage=this._resizedleftEyeImage;// 鼻画像を元に戻す
      _displayedRightEyeImage=this._resizedrightEyeImage;
      _displayedMouthImage=this._resizedMouthImage;
    });
  }


  Future<ui.Image> fillImageWithColor(ui.Image image, Color color) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    // 塗りつぶし
    final paint = Paint()..color = color;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      paint,
    );

    // 新しい画像を生成
    final picture = pictureRecorder.endRecording();
    return await picture.toImage(image.width, image.height);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAEED1),
      appBar: AppBar(
        backgroundColor: Color(0xFFFAEED1),
        title: Text(
          "福笑い",
          style: TextStyle(
            fontSize: 25,
            // color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: const EdgeInsets.only(left: 20), // 画面下部からの余白
                    child: widget._croppedImage_face == null
                        ? Text('No image selected.')
                        : CustomPaint(
                      painter: ImagePainter(widget._croppedImage_face!),
                      // size: Size(widget._croppedImage_face!.width.toDouble(), widget._croppedImage_face!.height.toDouble()),
                    ),),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 370, // 四角形の幅
                    height: 100, // 四角形の高さ
                    margin: const EdgeInsets.only(bottom: 120), // 画面下部からの余白
                    color: Colors.white, // 四角形の色
                  ),
                ),
                // ドラッグ操作
                GestureDetector(
                  onPanStart: (details) {
                    final image_nose_Center = _image1Offset + Offset(
                      10,
                      10,
                      // widget._croppedImage_nose.width / 2,
                      // widget._croppedImage_nose.height / 2,
                    );
                    final image_rightEye_Center = _image2Offset + Offset(
                      10,10,
                      // widget._croppedImage_rightEye.width / 2,
                      // widget._croppedImage_rightEye.height / 2,
                    );
                    final image_leftEye_Center = _image3Offset + Offset(
                      10,10
                      // widget._croppedImage_leftEye.width / 2,
                      // widget._croppedImage_leftEye.height / 2,
                    );
                    final image_mouth_Center = _image4Offset + Offset(
                      10,10
                      // widget._croppedImage_mouth.width / 2,
                      // widget._croppedImage_mouth.height / 2,
                    );

                    if ((details.localPosition - image_nose_Center).distance < 50) {
                      _draggingImageIndex = 1;
                      _startDragOffset = details.localPosition - _image1Offset;
                    } else if ((details.localPosition - image_rightEye_Center).distance < 50) {
                      _draggingImageIndex = 2;
                      _startDragOffset = details.localPosition - _image2Offset;
                    } else if ((details.localPosition - image_leftEye_Center).distance < 50) {
                      _draggingImageIndex = 3;
                      _startDragOffset = details.localPosition - _image3Offset;
                    } else if ((details.localPosition - image_mouth_Center).distance < 50) {
                      _draggingImageIndex = 4;
                      _startDragOffset = details.localPosition - _image4Offset;
                    }
                  },
                  onPanUpdate: (details) {
                    setState(() {
                      if (_draggingImageIndex == 1) {
                        _image1Offset = details.localPosition - _startDragOffset;
                      } else if (_draggingImageIndex == 2) {
                        _image2Offset = details.localPosition - _startDragOffset;
                      } else if (_draggingImageIndex == 3) {
                        _image3Offset = details.localPosition - _startDragOffset;
                      } else if (_draggingImageIndex == 4) {
                        _image4Offset = details.localPosition - _startDragOffset;
                      }
                    });
                  },
                  onPanEnd: (details) {
                    _draggingImageIndex = null; // ドラッグ終了時にリセット
                  },
                  child: (_displayedNoseImage != null &&
                      _displayedRightEyeImage != null &&
                      _displayedLeftEyeImage != null &&
                      _displayedMouthImage != null)
                      ? CustomPaint(
                    painter: MultiImagePainter(
                      _displayedNoseImage!,
                      _displayedRightEyeImage!,
                      _displayedLeftEyeImage!,
                      _displayedMouthImage!,
                      _image1Offset,
                      _image2Offset,
                      _image3Offset,
                      _image4Offset,
                    ),
                    child: Container(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                    ),
                  )
                : CircularProgressIndicator(), // 画像がロードされていない場合のプレースホルダー
                ),
            Padding(
            padding: const EdgeInsets.only(bottom: 10.0), // 下から10px分のスペースを追加
            child:
                Align(
                  alignment: Alignment.bottomCenter,
                  // 背景画像を中央に配置
                  child: ElevatedButton(
                    child: _finish?
                    const Text(
                      'ゲーム終了!',
                      style: TextStyle(
                        fontSize: 35,
                      ),
                    )
                    :
                        const Text(
            '目隠しを撮る',
            style: TextStyle(
            fontSize: 35,
            ),
            ),
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(200, 100),
                      backgroundColor: Color(0xFFB2A59B),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      if (_finish==false){
                      print("pushed");
                      _resetToOriginalNose();
                      // 状態を更新して再描画
                      setState(() {
                        _finish=true;
                      });}
                      else{
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ),
            )

              ],
            );
          },
        ),
      ),
    );
  }
}

class MultiImagePainter extends CustomPainter {
  final ui.Image image1;
  final ui.Image image2;
  final ui.Image image3;
  final ui.Image image4;
  final Offset offset1;
  final Offset offset2;
  final Offset offset3;
  final Offset offset4;

  MultiImagePainter(this.image1, this.image2, this.image3, this.image4, this.offset1, this.offset2, this.offset3, this.offset4);

  @override
  void paint(Canvas canvas, Size size) {
    // double scale = 0.15; // 50%のサイズに縮小する場合
    //
    // // Canvasを縮小
    // canvas.save();
    // canvas.scale(scale, scale);

    canvas.drawImage(image1, offset1, Paint());
    canvas.drawImage(image2, offset2, Paint());
    canvas.drawImage(image3, offset3, Paint());
    canvas.drawImage(image4, offset4, Paint());

    // canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ImagePainter extends CustomPainter {
  final ui.Image image;

  ImagePainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    double scale = 0.1; // 50%のサイズに縮小する場合

    // Canvasを縮小
    canvas.save();
    canvas.scale(scale, scale);

    // 縮小後の画像を描画
    canvas.drawImage(image, Offset.zero, Paint());

    // Canvasの状態を元に戻す
    // canvas.scale(1, 1);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}