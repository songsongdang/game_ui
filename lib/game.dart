import 'dart:math';
import 'package:flutter/services.dart';

// 추상 클래스: 캐릭터와 몬스터의 공통 속성/메서드 정의
abstract class Entity {
  String name;
  int health;
  int defense;

  Entity(this.name, this.health, this.defense);

  void showStatus();
}

// 파일 읽기 함수 (rootBundle 사용)
Future<String> loadFile(String path) async {
  return await rootBundle.loadString(path);
}

// 캐릭터 클래스
class Character extends Entity {
  int attack;
  bool usedItem = false;

  Character(String name, int health, this.attack, int defense)
    : super(name, health, defense);

  int attackMonster(Monster monster) {
    int damage = max(0, attack - monster.defense);
    monster.health -= damage;
    return damage; // 데미지 반환 (UI에서 표시용)
  }

  void defend() {
    // UI에서 방어 메시지 표시
  }

  @override
  void showStatus() {
    // UI에서 상태 표시
  }
}

// 몬스터 클래스
class Monster extends Entity {
  int maxAttack;
  int _turnCount = 0;

  Monster(String name, int health, this.maxAttack)
    : super(name, health, 0); // 몬스터 방어력=0

  int attackCharacter(Character character) {
    _turnCount++;
    _checkDefenseIncrease();

    Random random = Random();
    int attackValue = max(character.defense, random.nextInt(maxAttack) + 1);
    int damage = max(0, attackValue - character.defense);
    character.health -= damage;
    return damage; // 데미지 반환 (UI에서 표시용)
  }

  void _checkDefenseIncrease() {
    if (_turnCount % 3 == 0) {
      defense += 2;
      // UI에서 방어력 증가 메시지 표시
    }
  }

  @override
  void showStatus() {
    // UI에서 상태 표시
  }
}

// 게임 클래스
class Game {
  Character? character;
  List<Monster> monsters = [];
  int defeatedCount = 0;
  Monster? currentMonster;
  List<String> messageLog = [];

  // 메시지 추가
  void addMessage(String message) {
    messageLog.add(message);
    if (messageLog.length > 30) messageLog.removeAt(0); // 메시지 로그 최대 길이 제한
  }

  // 전투 시작
  void startBattle() {
    if (character == null || monsters.isEmpty) return;
    currentMonster = _getRandomMonster();
    addMessage('💥 새로운 몬스터 ${currentMonster!.name} 등장!');
  }

  // 공격
  int attack() {
    if (currentMonster == null || character == null) return 0;
    int damage = character!.attackMonster(currentMonster!);
    addMessage(
      '${character!.name}이(가) ${currentMonster!.name}에게 $damage의 데미지를 입혔습니다!',
    );
    if (currentMonster!.health <= 0) {
      addMessage('✅ ${currentMonster!.name} 처치!');
      monsters.remove(currentMonster!);
      defeatedCount++;
      if (monsters.isNotEmpty) {
        addMessage('다음 몬스터와 대결하시겠습니까? (UI에서 버튼으로 처리)');
      }
      _handleGameEnd();
      return damage;
    }
    // 몬스터 반격
    int monsterDamage = currentMonster!.attackCharacter(character!);
    addMessage(
      '${currentMonster!.name}이(가) ${character!.name}에게 $monsterDamage의 데미지를 입혔습니다!',
    );
    if (character!.health <= 0) {
      addMessage('❌ 패배! ${character!.name}이(가) 사망했습니다');
      _handleGameEnd();
    }
    return damage;
  }

  // 방어
  void defend() {
    if (character == null) return;
    addMessage('${character!.name}이(가) 방어 자세를 취합니다!');
    if (currentMonster != null) {
      int monsterDamage = currentMonster!.attackCharacter(character!) ~/ 2;
      addMessage(
        '${currentMonster!.name}이(가) ${character!.name}에게 $monsterDamage의 데미지를 입혔습니다! (방어)',
      );
      if (character!.health <= 0) {
        addMessage('❌ 패배! ${character!.name}이(가) 사망했습니다');
        _handleGameEnd();
      }
    }
  }

  // 아이템 사용
  void useItem() {
    if (character == null || character!.usedItem) {
      addMessage('이미 아이템을 사용했습니다!');
      return;
    }
    character!.attack *= 2;
    character!.usedItem = true;
    addMessage('💊 아이템 사용! 공격력이 2배로 증가합니다 (현재 공격력: ${character!.attack})');
  }

  // 몬스터 랜덤 선택
  Monster _getRandomMonster() {
    return monsters[Random().nextInt(monsters.length)];
  }

  // 캐릭터 스탯 로드 (rootBundle 사용)
  Future<void> _loadCharacterStats({required String characterName}) async {
    try {
      String contents = await rootBundle.loadString('assets/characters.txt');
      List<String> stats = contents.split(',');
      if (stats.length != 3) throw FormatException('Invalid character data');
      int health = int.parse(stats[0]);
      int attack = int.parse(stats[1]);
      int defense = int.parse(stats[2]);
      character = Character(characterName, health, attack, defense);
      addMessage('캐릭터 생성 완료: ${character!.name}');
    } catch (e) {
      addMessage('캐릭터 데이터 불러오기 실패: $e');
      character = Character(characterName, 50, 10, 5);
    }
  }

  // 몬스터 스탯 로드 (rootBundle 사용)
  Future<void> _loadMonsterStats() async {
    try {
      String contents = await rootBundle.loadString('assets/monsters.txt');
      List<String> lines = contents.split('\n');
      monsters.clear();
      for (String line in lines) {
        List<String> stats = line.split(',');
        if (stats.length != 3) continue;
        monsters.add(
          Monster(stats[0], int.parse(stats[1]), int.parse(stats[2])),
        );
      }
      if (monsters.isEmpty) throw Exception('No monsters loaded');
      addMessage('몬스터 데이터 로드 완료');
    } catch (e) {
      addMessage('몬스터 데이터 불러오기 실패: $e');
      monsters = [
        Monster('Thanos', 30, 20),
        Monster('Kang the conqueror', 20, 30),
        Monster('Dr.Doom', 30, 10),
      ];
    }
  }

  // 게임 시작 (캐릭터 이름을 파라미터로 받음)
  Future<void> startGame({required String characterName}) async {
    messageLog.clear();
    addMessage('게임을 시작합니다!');
    await _loadCharacterStats(characterName: characterName);
    await _loadMonsterStats();

    // 30% 확률 체력 보너스
    if (Random().nextDouble() < 0.3) {
      character!.health += 10;
      addMessage('보너스 체력을 얻었습니다! 현재 체력: ${character!.health}');
    }
  }

  // 게임 종료 처리
  void _handleGameEnd() {
    if (character!.health <= 0) {
      addMessage('❌ 패배! ${character!.name}이(가) 사망했습니다');
    } else if (defeatedCount >= monsters.length) {
      addMessage('🎉 승리! 모든 몬스터를 처치했습니다');
    } else {
      addMessage('게임을 중단했습니다 (처치한 몬스터: $defeatedCount/${monsters.length})');
    }
  }

  // 결과 저장 (UI에서 처리)
  void saveResult() {
    addMessage('결과를 저장하시겠습니까? (UI에서 버튼으로 처리)');
  }
}
