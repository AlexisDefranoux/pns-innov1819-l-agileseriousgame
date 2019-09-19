import 'package:agile_serious_game/model/lobby_class.dart';
import 'package:agile_serious_game/model/team_class.dart';
import 'package:agile_serious_game/model/user_story_class.dart';
import 'package:agile_serious_game/model/user_story_factory_class.dart';
import 'package:agile_serious_game/model/user_story_state_enum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserStoryService {
  UserStoryService();

  ///Push the set of user stories for a given lobby and a given team
  Future<void> pushUserStories(Lobby lobby, Team team) {
    team.availableStories.forEach((story, state) async {
      var ref = Firestore.instance
          .collection("lobby")
          .document(lobby.key)
          .collection("team")
          .document(team.name)
          .collection("user-story")
          .document(story.id.toString());
      await ref.setData({
        "id": story.id,
        "state": UserStoryStateUtils().toFirebaseString(state)
      });
    });
    return Future.value();
  }

  ///Push the set of user stories for a given lobby and a given team
  Future<void> pushUserStory(
      Lobby lobby, Team team, UserStory story, UserStoryState state) async {
    var ref = Firestore.instance
        .collection("lobby")
        .document(lobby.key)
        .collection("team")
        .document(team.name)
        .collection("user-story")
        .document(story.id.toString());
    await ref.setData({
      "id": story.id,
      "state": UserStoryStateUtils().toFirebaseString(state)
    });
    return Future.value();
  }

  ///Push the set of user stories for a given lobby and a given team
  Future<void> pushState(
      Lobby lobby, Team team, UserStory userStory, UserStoryState state) async {
    var ref = Firestore.instance
        .collection("lobby")
        .document(lobby.key)
        .collection("team")
        .document(team.name)
        .collection("user-story")
        .document(userStory.id.toString());
    await ref.setData({
      "id": userStory.id,
      "state": UserStoryStateUtils().toFirebaseString(state)
    });
    return Future.value();
  }

  ///Gets the user stories of a team in a lobby as a stream
  Stream<UserStory> getUserStoriesOfTeamAsStream(
      Lobby lobby, Team team) async* {
    var document = await Firestore.instance
        .collection("lobby")
        .document(lobby.key)
        .collection("team")
        .document(team.name)
        .collection("user-story")
        .getDocuments();

    for (var doc in document.documents) {
      UserStory story = UserStoryFactory().buildFromFirebase(doc.data["id"]);
      yield story;
    }
  }
}
