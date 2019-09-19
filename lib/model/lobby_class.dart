import 'package:agile_serious_game/utils/team_name_generator.dart';

import 'team_class.dart';
import 'user_story_class.dart';
import 'user_story_factory_class.dart';
import 'package:agile_serious_game/utils/lobby_name_generator.dart';

class Lobby {
  String _key;
  String _game;
  List<Team> teams;
  int _actualIteration;

  Lobby() {
    var gen = LobbyNameGenerator();
    _key = gen.getLobbyName(6);
    _game = "Birdie-Birdie";
    teams = new List();
    _actualIteration = 0;
  }

  String get game => _game;

  String get key => _key;

  int get actualIteration => _actualIteration;

  Lobby.fromFirebase(String id, String game) {
    _key = id;
    _game = game;
    teams = new List();
    _actualIteration = 0;
  }

  void createTeamAndUserStory(int nbrTeam) {
    List<UserStory> userStories = (new UserStoryFactory()).buildFromStatic();
    var generator = TeamNameGenerator();
    generator
        .getTeamName(nbrTeam)
        .forEach((c) => teams.add(new Team(c, userStories)));
  }

  void nextIteration() {
    _actualIteration++;
    teams.forEach((team) => team.nextIteration(_actualIteration, this));
  }

  /// Get total score by team
  Map<String, int> getScores() {
    Map<String, int> scores = new Map();
    teams.forEach((team) {
      scores[team.name] = team.userStoryHistoryList.getTotalScore();
    });
    return scores;
  }

  /// Get refused score by team
  Map<String, int> getRefusedScore(int iteration) {
    Map<String, int> scores = new Map();
    teams.forEach((team) {
      scores[team.name] =
          team.userStoryHistoryList.getRefusedScoreByIteration(iteration);
    });
    return scores;
  }

  /// Get validated score by team
  Map<String, int> getValidatedScore(int iteration) {
    Map<String, int> scores = new Map();
    teams.forEach((team) {
      scores[team.name] =
          team.userStoryHistoryList.getValidatedScoreByIteration(iteration);
    });
    return scores;
  }

  Map<String, Map<int, int>> getIterationScore() {
    Map<String, Map<int, int>> score = new Map();
    this.teams.forEach((team) {
      Map<int, int> iterations = new Map();
      for (int i = 0; i <= actualIteration; i++) {
        iterations[i] = team.userStoryHistoryList.getTotalScoreAtIteration(i);
      }
      score[team.name] = iterations;
    });
    return score;
  }
}
