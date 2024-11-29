import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class GamePage extends StatefulWidget {
  final ui.Image _croppedImage_nose;
  final ui.Image _croppedImage_rightEye;
  final ui.Image _croppedImage_leftEye;
  final ui.Image _croppedImage_mouth;

  const GamePage(this._croppedImage_nose, this._croppedImage_rightEye, this._croppedImage_leftEye, this._croppedImage_mouth, {Key? key})
      : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  Offset _image1Offset = Offset.zero; // 鼻
  Offset _image2Offset = Offset.zero; // 右目
  Offset _image3Offset = Offset.zero; // 左目
  Offset _image4Offset = Offset.zero; // 口
  Offset _startDragOffset = Offset.zero;
  int? _draggingImageIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF93c9ff),
        title: Text(
          "入室",
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                // 背景画像
                Positioned.fill(
                  child: Image.asset(
                    'assets/fukuwarai.png',
                    fit: BoxFit.cover,
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
                  child: CustomPaint(
                    painter: MultiImagePainter(
                      widget._croppedImage_nose,
                      widget._croppedImage_rightEye,
                      widget._croppedImage_leftEye,
                      widget._croppedImage_mouth,
                      _image1Offset,
                      _image2Offset,
                      _image3Offset,
                      _image4Offset,
                    ),
                    child: Container(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                    ),
                  ),
                ),
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