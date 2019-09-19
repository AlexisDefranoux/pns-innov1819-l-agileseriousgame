import 'dart:math';

class LobbyNameGenerator {
  String _alphabet;
  final _random = new Random();

  LobbyNameGenerator() {
    _alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
  }

  ///Build a list of team names to use depending on the given number of teams
  String getLobbyName(int size) {
    String name = "";
    for (var i = 0; i < size; i++) {
      name = name + _alphabet[_random.nextInt(33)];
    }
    return name;
  }
}
