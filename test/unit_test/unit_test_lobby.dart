import 'package:agile_serious_game/model/lobby_class.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('get lobby', () async{
    //Create lobby and see if it has its key
    final Lobby mockLobby = new Lobby();
    expect(mockLobby.key, isNotEmpty);

    //Create 3 teams and name them
    mockLobby.createTeamAndUserStory(3);
    expect(mockLobby.teams.length, 3);
    expect(mockLobby.teams[0].name,"A");
    expect(mockLobby.teams[1].name,"B");
    expect(mockLobby.teams[2].name,"C");

  });
}