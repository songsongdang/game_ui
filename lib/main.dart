import 'package:flutter/material.dart';
import 'game_screen.dart'; // 게임 메인 화면 위젯

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RPG 게임',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: GameScreen(), // 게임 메인 화면
      debugShowCheckedModeBanner: false,
    );
  }
}
