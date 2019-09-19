class TeamNameGenerator {
  String _alphabet;

  TeamNameGenerator() {
    _alphabet = "abcdefghijklmnopqrstuvxyz";
  }

  ///Build a list of team names to use depending on the given number of teams
  List<String> getTeamName(int numTeams) {
    List<String> res = new List();
    for (var i = 0; i < numTeams; i++) {
      res.add(_alphabet[i].toUpperCase());
    }
    return res;
  }
}
