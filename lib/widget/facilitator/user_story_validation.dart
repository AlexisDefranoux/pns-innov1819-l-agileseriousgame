import 'package:agile_serious_game/data/color.dart';
import 'package:agile_serious_game/model/lobby_class.dart';
import 'package:agile_serious_game/model/team_class.dart';
import 'package:agile_serious_game/model/user_story_class.dart';
import 'package:agile_serious_game/model/user_story_history.dart';
import 'package:agile_serious_game/model/user_story_state_enum.dart';
import 'package:agile_serious_game/service/history_service.dart';
import 'package:agile_serious_game/service/lobby_service.dart';
import 'package:agile_serious_game/service/user_story_service.dart';
import 'package:agile_serious_game/utils/custom_expansion_tile.dart' as custom;
import 'package:agile_serious_game/utils/frozen_circular_indicator.dart';
import 'package:flutter/material.dart';

class UserStoryValidation extends StatefulWidget {
  final Lobby lobby;

  UserStoryValidation({this.lobby});

  @override
  UserStoryValidationState createState() => UserStoryValidationState();
}

class UserStoryValidationState extends State<UserStoryValidation> {
  Future<List<Team>> teams;
  List<Widget> storyWidgetList;

  @override
  void initState() {
    super.initState();
    setState(() {
      teams = LobbyService().getTeamsAndStories(widget.lobby);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: FutureBuilder(
          future: teams,
          builder: (context, AsyncSnapshot<List<Team>> snapshot) {
            if (snapshot.hasError) {
              return AlertDialog(
                title: new Text("Error fetching data"),
              );
            }
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return FrozenCircularIndicatorWidget();
              default:
                widget.lobby.teams = snapshot.data;
                return ListView.builder(
                  itemCount: widget.lobby.teams.length,
                  itemBuilder: (context, index) {
                    final team = widget.lobby.teams[index];
                    return custom.ExpansionTile(
                      headerBackgroundColor: Colors.grey[200],
                      backgroundColor: Colors.grey[200],
                      iconColor: Colors.black,
                      key: PageStorageKey(team),
                      title: _teamList(team),
                      children: _buildStoryTile(widget.lobby, team),
                    );
                  },
                );
            }
          },
        ),
      ),
    );
  }

  List<Widget> _buildStoryTile(Lobby lobby, Team team) {
    storyWidgetList = new List<Widget>();
    team.availableStories.forEach((k, v) {
      if (v == UserStoryState.SELECTED) {
        storyWidgetList.add(_storyTitle(k, team));
      }
    });
    return storyWidgetList;
  }

  Widget _storyTitle(UserStory userStory, Team team) {
    return Dismissible(
      key: PageStorageKey(userStory.title + team.name),
      child: _myListContainer(userStory.title, userStory.specification,
          userStory.score, userStory.criteria),
      background: Container(
        color: Colors.red,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Icon(
            Icons.close,
            color: Colors.white,
          ),
        ),
        alignment: Alignment.centerLeft,
      ),
      secondaryBackground: Container(
        color: Colors.green,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Icon(
            Icons.check,
            color: Colors.white,
          ),
        ),
        alignment: Alignment.centerRight,
      ),
      onDismissed: (direction) {
        var service = HistoryService();
        UserStoryHistory userStoryHistory;
        if (direction == DismissDirection.endToStart) {
          Scaffold.of(context).showSnackBar(SnackBar(
            duration: new Duration(seconds: 3),
            content: Text("User story \"${userStory.title}\" validé !"),
            action: new SnackBarAction(
              label: 'UNDO',
              onPressed: () =>
                  _undoValidation(team, userStory, userStoryHistory),
            ),
          ));
          userStoryHistory =
              team.validate(userStory, widget.lobby.actualIteration);
          service.pushUserStoryToHistoryForTeam(widget.lobby, team, userStory,
              UserStoryState.VALIDATED, userStoryHistory);
        } else if (direction == DismissDirection.startToEnd) {
          Scaffold.of(context).showSnackBar(SnackBar(
            duration: new Duration(seconds: 3),
            content: Text("User story \"${userStory.title}\" refusé !"),
            action: new SnackBarAction(
              label: 'UNDO',
              onPressed: () => _undoRefuse(team, userStory, userStoryHistory),
            ),
          ));
          userStoryHistory =
              team.refuse(userStory, widget.lobby.actualIteration);
          service.pushUserStoryToHistoryForTeam(widget.lobby, team, userStory,
              UserStoryState.REFUSED, userStoryHistory);
        }
        this.setState(() {
          storyWidgetList.remove(this);
        });
      },
    );
  }

  Widget _myListContainer(
      String title, String specification, int score, List<String> criteria) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        child: Text(
                          title,
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        child: Text(
                          specification,
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  child: IconButton(
                      icon: Icon(Icons.info),
                      color: Color(AppColors.themeColor),
                      onPressed: () => _showInfo(criteria)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showInfo(List<String> criteria) {
    String allCriteria = "";
    criteria.forEach((f) {
      allCriteria = allCriteria + "- " + f + "\n";
    });
    var alertDialog = AlertDialog(
      title: Text("Critères"),
      content: Text(allCriteria),
    );
    showDialog(
        context: context, builder: (BuildContext context) => alertDialog);
  }

  Widget _teamList(Team team) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(
          team.name,
          style: new TextStyle(color: Color(AppColors.buttonColor)),
        ),
        backgroundColor: Color(AppColors.themeColor),
      ),
      title: Text('Team ${team.name}'),
    );
  }

  @override
  UserStoryValidation get widget => super.widget;

  _undoValidation(
      Team team, UserStory userStory, UserStoryHistory userStoryHistory) {
    HistoryService().undoEvent(widget.lobby, team, userStoryHistory);
    UserStoryService()
        .pushUserStory(widget.lobby, team, userStory, UserStoryState.SELECTED);
    team.undoUserStory(userStory);
    setState(() {});
  }

  _undoRefuse(
      Team team, UserStory userStory, UserStoryHistory userStoryHistory) {
    HistoryService().undoEvent(widget.lobby, team, userStoryHistory);
    UserStoryService()
        .pushState(widget.lobby, team, userStory, UserStoryState.SELECTED);
    team.undoUserStory(userStory);
    setState(() {});
  }
}
