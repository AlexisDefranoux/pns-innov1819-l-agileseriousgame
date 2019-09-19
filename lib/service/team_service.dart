import 'package:agile_serious_game/model/lobby_class.dart';
import 'package:agile_serious_game/model/team_class.dart';
import 'package:agile_serious_game/model/user_story_class.dart';
import 'package:agile_serious_game/model/user_story_factory_class.dart';
import 'package:agile_serious_game/model/user_story_state_enum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeamService {
  TeamService();

  ///Get the team object given a team key
  Future<Team> getTeam(String lobbyKey, String teamKey) async {
    var document = await Firestore.instance
        .collection("lobby")
        .document(lobbyKey)
        .collection("team")
        .document(teamKey)
        .get();
    return new Team.fromFirebase(document.documentID);
  }

  ///Get the user stories of a team in a given lobby
  Future<Map<UserStory, UserStoryState>> getUserStoriesOfTeam(
      Lobby lobby, Team team) async {
    Map<UserStory, UserStoryState> stories = new Map();
    var docs = await Firestore.instance
        .collection("lobby")
        .document(lobby.key)
        .collection("team")
        .document(team.name)
        .collection("user-story")
        .getDocuments();
    docs.documents.forEach((doc) => stories.putIfAbsent(
        UserStoryFactory().buildFromFirebase(int.parse(doc.documentID)),
        () => UserStoryStateUtils().buildFromFirebase(doc["state"])));
    return stories;
  }

  ///Gets the selected user stories of a team in a lobby
  Future<List<UserStory>> getSelectedUserStoriesOfTeam(
      Lobby lobby, Team team) async {
    List<UserStory> stories = new List();
    var document = await Firestore.instance
        .collection("lobby")
        .document(lobby.key)
        .collection("team")
        .document(team.name)
        .collection("user-story")
        .getDocuments();

    for (var doc in document.documents) {
      if (doc.data["state"] == "selected") {
        UserStory story = UserStoryFactory().buildFromFirebase(doc.data["id"]);
        stories.add(story);
      }
    }
    return stories;
  }
}
