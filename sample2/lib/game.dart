import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class GamePage extends StatefulWidget {
  final ui.Image _croppedImage;
  final ui.Image _croppedImage2;

  const GamePage(this._croppedImage, this._croppedImage2, {Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  Offset _image1Offset = Offset.zero; // 1つ目の画像の現在位置
  Offset _image2Offset = Offset(100, 100); // 2つ目の画像の現在位置
  Offset _startDragOffset = Offset.zero; // ドラッグ開始時のオフセット
  int? _draggingImageIndex; // ドラッグ中の画像を特定するためのインデックス

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
            return GestureDetector(
              onPanStart: (details) {
                // 画像の中心点を基準にドラッグ対象を判定
                final image1Center = _image1Offset + Offset(
                  widget._croppedImage.width / 2,
                  widget._croppedImage.height / 2,
                );
                final image2Center = _image2Offset + Offset(
                  widget._croppedImage2.width / 2,
                  widget._croppedImage2.height / 2,
                );

                if ((details.localPosition - image1Center).distance < 50) {
                  _draggingImageIndex = 1;
                  _startDragOffset = details.localPosition - _image1Offset;
                } else if ((details.localPosition - image2Center).distance < 50) {
                  _draggingImageIndex = 2;
                  _startDragOffset = details.localPosition - _image2Offset;
                }
              },
              onPanUpdate: (details) {
                setState(() {
                  if (_draggingImageIndex == 1) {
                    _image1Offset = details.localPosition - _startDragOffset;
                  } else if (_draggingImageIndex == 2) {
                    _image2Offset = details.localPosition - _startDragOffset;
                  }
                });
              },
              onPanEnd: (details) {
                _draggingImageIndex = null; // ドラッグ終了時にリセット
              },
              child: CustomPaint(
                painter: MultiImagePainter(widget._croppedImage, widget._croppedImage2, _image1Offset, _image2Offset),
                child: Container(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                ),
              ),
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
  final Offset offset1;
  final Offset offset2;

  MultiImagePainter(this.image1, this.image2, this.offset1, this.offset2);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(image1, offset1, Paint());
    canvas.drawImage(image2, offset2, Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}