import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class AddFuncPage extends StatefulWidget {
  final ui.Image _uiImage;
  final ui.Image _croppedImage_nose;
  final ui.Image _croppedImage_rightEye;
  final ui.Image _croppedImage_leftEye;
  final ui.Image _croppedImage_mouth;
  final ui.Image _croppedImage_face;
  final List list_color;
  final ui.Image _black;


  const AddFuncPage(this._uiImage,
      this._croppedImage_nose,
      this._croppedImage_rightEye,
      this._croppedImage_leftEye,
      this._croppedImage_mouth,
      this._croppedImage_face,
      this.list_color,
      this._black,
      {Key? key})
      : super(key: key);

  @override
  _AddFuncPageState createState() => _AddFuncPageState();
}

class _AddFuncPageState extends State<AddFuncPage> {
  Offset _image1Offset = Offset(40,590); // 鼻
  Offset _image2Offset = Offset(125,590); // 右目
  Offset _image3Offset = Offset(200,590); // 左目
  Offset _image4Offset = Offset(280,590); // 口
  Offset _startDragOffset = Offset.zero;
  int? _draggingImageIndex;
  bool _finish = false;
  ui.Image? _displayedNoseImage;
  ui.Image? _displayedLeftEyeImage;
  ui.Image? _displayedRightEyeImage;
  ui.Image? _displayedMouthImage;
  ui.Image? _displayedImage_face;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 2), () {
      _initializeNoseImage();
      setState(() {
        _displayedImage_face=widget._black;
      });
    });
    _initializeNoseImage();
    // 最初の表示を設定
    setState(() {
      _displayedImage_face=widget._uiImage;
      // _displayedNoseImage = widget._uiImage;
      // _displayedLeftEyeImage = widget._uiImage; // 必要に応じて他の部分も _uiImage に
      // _displayedRightEyeImage = widget._uiImage;
      // _displayedMouthImage = widget._uiImage;
    });

  }

  Future<ui.Image> _createBlackFilledImage(int width, int height,Color color) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()));
    final paint = Paint()..color = color;

    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), paint);

    final picture = recorder.endRecording();
    return await picture.toImage(width, height);
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



  void _resetToOriginalNose() {
    setState(() {
      _displayedNoseImage = widget._croppedImage_nose;
      _displayedLeftEyeImage=widget._croppedImage_leftEye;// 鼻画像を元に戻す
      _displayedRightEyeImage=widget._croppedImage_rightEye;
      _displayedMouthImage=widget._croppedImage_mouth;
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
                    child: this._displayedImage_face == null
                        ? Text('No image selected.')
                        : CustomPaint(
                      painter: ImagePainter(this._displayedImage_face!),
                      // size: Size(this._displayedImage_face!.width.toDouble(), this._displayedImage_face!.height.toDouble()),
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
                      widget._croppedImage_nose.width / 2,
                      widget._croppedImage_nose.height / 2,
                    );
                    final image_rightEye_Center = _image2Offset + Offset(
                      widget._croppedImage_rightEye.width / 2,
                      widget._croppedImage_rightEye.height / 2,
                    );
                    final image_leftEye_Center = _image3Offset + Offset(
                      widget._croppedImage_leftEye.width / 2,
                      widget._croppedImage_leftEye.height / 2,
                    );
                    final image_mouth_Center = _image4Offset + Offset(
                      widget._croppedImage_mouth.width / 2,
                      widget._croppedImage_mouth.height / 2,
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
                            _displayedImage_face=widget._croppedImage_face;
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
    canvas.drawImage(image1, offset1, Paint());
    canvas.drawImage(image2, offset2, Paint());
    canvas.drawImage(image3, offset3, Paint());
    canvas.drawImage(image4, offset4, Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ImagePainter extends CustomPainter {
  final ui.Image image;

  ImagePainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    double scale = 0.8; // 50%のサイズに縮小する場合

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