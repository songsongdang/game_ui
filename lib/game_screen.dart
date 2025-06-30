import 'package:flutter/material.dart';
import 'game.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Game? game;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  Future<void> _initGame() async {
    setState(() => isLoading = true);
    game = Game();
    try {
      await game!.startGame();
      setState(() => isLoading = false);
    } catch (e) {
      setState(() {
        game!.addMessage('게임 초기화 중 오류: $e');
        isLoading = false;
      });
    }
  }

  // 전투 시작
  void _startBattle() {
    game!.startBattle();
    setState(() {});
  }

  // 공격
  void _attack() {
    game!.attack();
    setState(() {});
  }

  // 방어
  void _defend() {
    game!.defend();
    setState(() {});
  }

  // 아이템 사용
  void _useItem() {
    game!.useItem();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('게임 로딩 중...')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('간단한 RPG 게임')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 캐릭터 상태
            if (game!.character != null)
              CharacterWidget(character: game!.character!),
            SizedBox(height: 10),
            // 몬스터 상태
            if (game!.currentMonster != null)
              MonsterWidget(monster: game!.currentMonster!),
            SizedBox(height: 20),
            // 메시지 로그
            Expanded(
              child: ListView.builder(
                itemCount: game!.messageLog.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.0),
                  child: Text(game!.messageLog[index]),
                ),
              ),
            ),
            SizedBox(height: 10),
            // 전투 시작/공격/방어/아이템 버튼
            if (game!.currentMonster != null && game!.character!.health > 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: _attack, child: Text('공격')),
                  ElevatedButton(onPressed: _defend, child: Text('방어')),
                  ElevatedButton(onPressed: _useItem, child: Text('아이템')),
                ],
              ),
            if (game!.currentMonster == null ||
                game!.character!.health <= 0 ||
                game!.defeatedCount >= game!.monsters.length)
              ElevatedButton(onPressed: _startBattle, child: Text('새로운 전투 시작')),
          ],
        ),
      ),
    );
  }
}

// 캐릭터 상태 위젯
class CharacterWidget extends StatelessWidget {
  final Character character;

  CharacterWidget({required this.character});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('이름: ${character.name}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('체력: ${character.health}', style: TextStyle(fontSize: 16)),
            Text('공격력: ${character.attack}', style: TextStyle(fontSize: 16)),
            Text('방어력: ${character.defense}', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

// 몬스터 상태 위젯
class MonsterWidget extends StatelessWidget {
  final Monster monster;

  MonsterWidget({required this.monster});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red[100],
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('이름: ${monster.name}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('체력: ${monster.health}', style: TextStyle(fontSize: 16)),
            Text('공격력: ${monster.maxAttack}', style: TextStyle(fontSize: 16)),
            Text('방어력: ${monster.defense}', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
