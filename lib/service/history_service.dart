import 'package:agile_serious_game/model/lobby_class.dart';
import 'package:agile_serious_game/model/team_class.dart';
import 'package:agile_serious_game/model/user_story_class.dart';
import 'package:agile_serious_game/model/user_story_factory_class.dart';
import 'package:agile_serious_game/model/user_story_history.dart';
import 'package:agile_serious_game/model/user_story_history_list.dart';
import 'package:agile_serious_game/model/user_story_state_enum.dart';
import 'package:agile_serious_game/utils/timer_singleton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryService {
  HistoryService();

  ///Get the user history list for a given lobby and a given team
  Future<UserStoryHistoryList> getUserHistoryList(
      Lobby lobby, Team team) async {
    List<UserStoryHistory> histories = new List();
    var docs = await Firestore.instance
        .collection("lobby")
        .document(lobby.key)
        .collection("team")
        .document(team.name)
        .collection("history")
        .getDocuments();
    for (var doc in docs.documents) {
      histories.add(UserStoryHistory(
          UserStoryFactory().buildFromFirebase(doc["id"]),
          UserStoryStateUtils().buildFromFirebase(doc["state"]),
          doc["iteration"]));
    }
    return UserStoryHistoryList.fromList(histories);
  }

  Future<void> undoEvent(Lobby lobby, Team team, UserStoryHistory story) async {
    var storyRef = Firestore.instance
        .collection("lobby")
        .document(lobby.key)
        .collection("team")
        .document(team.name)
        .collection("history")
        .document(story.ref);
    await storyRef.delete();
  }

  ///Push a user story depending of a state, of a team in a lobby; removes the story from the
  ///available stories if the state i validated
  Future<void> pushUserStoryToHistoryForTeam(
      Lobby lobby,
      Team team,
      UserStory story,
      UserStoryState state,
      UserStoryHistory userStoryHistory) async {
    var ref = Firestore.instance
        .collection("lobby")
        .document(lobby.key)
        .collection("team")
        .document(team.name)
        .collection("history")
        .document();

    if (state == UserStoryState.VALIDATED) {
      var storyRef = Firestore.instance
          .collection("lobby")
          .document(lobby.key)
          .collection("team")
          .document(team.name)
          .collection("user-story")
          .document(story.id.toString());
      await storyRef.delete();
    }

    if (state == UserStoryState.REFUSED) {
      var storyRef = Firestore.instance
          .collection("lobby")
          .document(lobby.key)
          .collection("team")
          .document(team.name)
          .collection("user-story")
          .document(story.id.toString());
      await storyRef.setData({
        "id": story.id,
        "state":
            UserStoryStateUtils().toFirebaseString(UserStoryState.UNSELECTED)
      });
    }

    userStoryHistory.ref = ref.documentID;

    return ref.setData({
      "id": story.id,
      "iteration": TimerSingleton.iteration,
      "state": UserStoryStateUtils().toFirebaseString(state)
    });
  }
}
