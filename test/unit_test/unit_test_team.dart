import 'package:agile_serious_game/model/lobby_class.dart';
import 'package:agile_serious_game/model/user_story_class.dart';
import 'package:agile_serious_game/model/user_story_factory_class.dart';
import 'package:agile_serious_game/model/user_story_state_enum.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  //Create lobby and 2 teams
  final Lobby mockLobby = new Lobby();
  mockLobby.createTeamAndUserStory(2);
  UserStory userStory1 = ((new UserStoryFactory()).buildFromStatic())[0];
  UserStory userStory2 = ((new UserStoryFactory()).buildFromStatic())[1];
  UserStory userStory3 = ((new UserStoryFactory()).buildFromStatic())[2];

  test('test the selection and unselection of un user story in a team', () async {
    int nbAvailableStory = mockLobby.teams[0].availableStories.length;
    expect(nbAvailableStory, 4);

    //Team A choose three user stories
    mockLobby.teams[0].selectUserStory(userStory1);
    mockLobby.teams[0].selectUserStory(userStory2);
    mockLobby.teams[0].selectUserStory(userStory3);

    UserStoryState selectedStory1 = mockLobby.teams[0]
        .availableStories[userStory1];
    UserStoryState selectedStory2 = mockLobby.teams[0]
        .availableStories[userStory2];
    UserStoryState selectedStory3 = mockLobby.teams[0]
        .availableStories[userStory3];
    UserStory story1 = mockLobby.teams[0].getUserStory("Nom d’oiseau");

    expect(story1, userStory1);
    expect(selectedStory1, UserStoryState.SELECTED);
    expect(selectedStory2, UserStoryState.SELECTED);
    expect(selectedStory3, UserStoryState.SELECTED);

    //Unselect one
    mockLobby.teams[0].unSelectUserStory(userStory3);
    selectedStory3 = mockLobby.teams[0]
        .availableStories[userStory3];
    UserStoryState state3 = mockLobby.teams[0].getUserStoryState("Bec");
    expect(state3, UserStoryState.UNSELECTED);
    expect(selectedStory3, UserStoryState.UNSELECTED);
  }
  );
  test('test the acception and refuse of un user story in a team', () async{

    //Facilitator refuse the first one
    mockLobby.teams[0].selectUserStory(userStory1);
    mockLobby.teams[0].selectUserStory(userStory2);
    mockLobby.teams[0].refuse(userStory1, 1);

    UserStoryState refuseStory1 = mockLobby.teams[0]
        .userStoryHistoryList.userStoryHistories.last.userStoryState;
    expect(refuseStory1, UserStoryState.REFUSED);

    //and accept the second one
    mockLobby.teams[0].validate(userStory2, 1);
    UserStoryState acceptStory2 = mockLobby.teams[0]
        .userStoryHistoryList.userStoryHistories.last.userStoryState;
    expect(acceptStory2, UserStoryState.VALIDATED);
  }
  );

}