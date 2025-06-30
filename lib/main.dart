import 'package:flutter/material.dart';
import 'character_name_screen.dart'; // 캐릭터 이름 입력 화면

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
      home: CharacterNameScreen(), // 캐릭터 이름 입력 화면으로 시작
      debugShowCheckedModeBanner: false,
    );
  }
}
