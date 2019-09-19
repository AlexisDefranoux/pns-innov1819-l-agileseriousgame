import 'package:agile_serious_game/model/lobby_class.dart';
import 'package:agile_serious_game/model/team_class.dart';
import 'package:agile_serious_game/model/user_story_factory_class.dart';
import 'package:agile_serious_game/service/team_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agile_serious_game/service/history_service.dart';
import 'package:agile_serious_game/service/user_story_service.dart';

class LobbyService {
  LobbyService();

  ///Gets the teams in a given lobby
  Future<Lobby> getHistories(Lobby lobby) async {
    lobby.teams.forEach((team) async {
      team.userStoryHistoryList =
          await HistoryService().getUserHistoryList(lobby, team);
    });
    return lobby;
  }

  ///Get the lobby object given a lobby key
  Future<Lobby> getLobby(String lobbyKey) async {
    var document =
        await Firestore.instance.collection("lobby").document(lobbyKey).get();
    return new Lobby.fromFirebase(document.documentID, document["name"]);
  }

  ///Creates a simple lobby with the key given by firebase
  Future<void> createLobby(Lobby lobby) async {
    await Firestore.instance
        .collection("lobby")
        .document(lobby.key)
        .setData({"name": lobby.game, "timer": false});
    await pushTeams(lobby);
    lobby.teams.forEach((t) async {
      await UserStoryService().pushUserStories(lobby, t);
    });
    return Future.value();
  }

  ///Gets the teams in a given lobby
  Future<List<Team>> getTeams(Lobby lobby) async {
    List<Team> teams = new List();
    var ref = await Firestore.instance
        .collection("lobby")
        .document(lobby.key)
        .collection("team")
        .getDocuments();
    ref.documents
        .forEach((doc) => teams.add(Team.fromFirebase(doc.documentID)));
    return teams;
  }

  ///Push the set of teams for a given lobby
  Future<void> pushTeams(Lobby lobby) {
    lobby.teams.forEach((t) async {
      var ref = Firestore.instance
          .collection("lobby")
          .document(lobby.key)
          .collection("team")
          .document(t.name);
      await ref.setData({"name": t.name});
    });
    return Future.value();
  }

  ///Gets the teams and their user stories
  Future<List<Team>> getTeamsAndStories(Lobby lobby) async {
    List<Team> teams = await getTeams(lobby);
    for (var team in teams) {
      team.availableStories =
          await TeamService().getUserStoriesOfTeam(lobby, team);
    }
    return teams;
  }

  ///Gets the teams of a lobby as a stream
  Stream<Team> getTeamsAsStream(Lobby lobby) async* {
    var ref = await Firestore.instance
        .collection("lobby")
        .document(lobby.key)
        .collection("team")
        .getDocuments();
    for (var doc in ref.documents) {
      yield Team.fromFirebase(doc.documentID);
    }
  }

  ///Get teams and user stories as stream
  Stream<Team> getTeamsAndStoriesAsStream(Lobby lobby) async* {
    var ref = await Firestore.instance
        .collection("lobby")
        .document(lobby.key)
        .collection("team")
        .getDocuments();

    ref.documents.forEach((doc) {
      return doc.reference.snapshots().map((team) {
        return Team(
            team.data["id"],
            team.reference.snapshots().map((userStory) {
              return UserStoryFactory().buildFromFirebase(userStory.data["id"]);
            }));
      });
    });
  }

  ///Changes the value of the chronometer of the lobby, true is running
  Future<void> setChronometer(Lobby lobby, bool state) async {
    await Firestore.instance
        .collection("lobby")
        .document(lobby.key)
        .setData({"timer": state});
    return Future.value();
  }

  ///Gets the chronometer value for a given lobby as a stream
  /// On every value change the stream is updated
  Stream<bool> getChronometer(Lobby lobby) {
    var doc =
        Firestore.instance.collection("lobby").document(lobby.key).snapshots();
    return doc.map((val) {
      return val["timer"];
    });
  }
}
