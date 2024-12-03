import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io' as io;
import "select.dart";

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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAEED1),
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Color(0xFFFAEED1),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0), // 上からの余白
              child: Text(
                '福笑い',
                style: TextStyle(
                  fontSize: 45,
                    color: Color(0xFFB2A59B),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  child: Image.asset(
                    'assets/22179350.png',
                    fit: BoxFit.cover,
                  ),
                ),
                ElevatedButton(
                  child: const Text(
                    'let\'s play',
                    style: TextStyle(
                      fontSize: 35,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(200, 100),
                    backgroundColor: Color(0xFFB2A59B), // ボタンの背景色
                    foregroundColor: Colors.white,      // テキストの色
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SelectPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//         backgroundColor: Color(0xFFFAEED1),
//         appBar: new AppBar(
//           title: new Text(''),
//           backgroundColor: Color(0xFFFAEED1),
//         ),
//         body:Center(
//           child:Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: <Widget>[
//                 Container(
//                   // width: 160,
//                   // height: 200,
//                   child:Image.asset('assets/22179350.png',fit: BoxFit.cover,),
//                 ),
//                 ElevatedButton(
//                   child: const Text(
//                     'let\'s play',
//                     style: TextStyle(
//                       fontSize: 35,
//                     ),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     fixedSize: Size(200, 100),
//                     backgroundColor: Color(0xFFB2A59B), // ボタンの背景色
//                     foregroundColor: Colors.white,      // テキストの色
//                   ),
//                   onPressed: () {
//                     Navigator.push(context, MaterialPageRoute(
//                       builder: (context) => SelectPage(),
//                     ));
//                   },
//                 ),
//               ]
//           ),
//         )
//     );
//   }
// }
