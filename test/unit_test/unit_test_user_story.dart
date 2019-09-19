import 'package:agile_serious_game/model/lobby_class.dart';
import 'package:agile_serious_game/model/user_story_class.dart';
import 'package:agile_serious_game/model/user_story_factory_class.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  //Create lobby and 2 teams
  final Lobby mockLobby = new Lobby();
  mockLobby.createTeamAndUserStory(2);
  UserStory userStory1 = ((new UserStoryFactory()).buildFromStatic())[0];
  UserStory userStory2 = ((new UserStoryFactory()).buildFromStatic())[1];
  UserStory userStory3 = ((new UserStoryFactory()).buildFromStatic())[2];
  UserStory userStory4 = ((new UserStoryFactory()).buildFromStatic())[3];

  test('test the score in a team', () async{
    //Team A select 4 user stories
    mockLobby.teams[0].selectUserStory(userStory1);
    mockLobby.teams[0].selectUserStory(userStory2);
    mockLobby.teams[0].selectUserStory(userStory3);
    mockLobby.teams[0].selectUserStory(userStory4);

    mockLobby.teams[0].validate(userStory1, 1);
    mockLobby.teams[0].refuse(userStory2, 1);
    mockLobby.teams[0].validate(userStory3, 1);
    mockLobby.teams[0].validate(userStory4, 1);

    //get the score of validated user story
    int nbValidate = mockLobby.teams[0].userStoryHistoryList.getNumberOfValidatedStory();
    int scoreValidate = mockLobby.teams[0].userStoryHistoryList.getValidatedScore();
    expect(nbValidate, 3);
    expect(scoreValidate, 700);

    //get the score of refused user story
    int nbRefuse = mockLobby.teams[0].userStoryHistoryList.getNumberOfRefusedStory();
    int scoreRefuse = mockLobby.teams[0].userStoryHistoryList.getRefusedScore();
    expect(nbRefuse, 1);
    expect(scoreRefuse, 200);

    //get the total score(total = validated - refused)
    int scoreTotal = mockLobby.teams[0].userStoryHistoryList.getTotalScore();
    expect(scoreTotal, 500);

  });
}