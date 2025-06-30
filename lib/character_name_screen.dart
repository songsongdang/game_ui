import 'package:flutter/material.dart';
import 'game_screen.dart';

class CharacterNameScreen extends StatefulWidget {
  @override
  _CharacterNameScreenState createState() => _CharacterNameScreenState();
}

class _CharacterNameScreenState extends State<CharacterNameScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('캐릭터 이름 설정')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: '캐릭터 이름',
                  hintText: '이름을 입력하세요',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_nameController.text.isNotEmpty) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            GameScreen(characterName: _nameController.text),
                      ),
                    );
                  }
                },
                child: Text('게임 시작'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
