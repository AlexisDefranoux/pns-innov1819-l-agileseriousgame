import 'package:agile_serious_game/data/color.dart';
import 'package:agile_serious_game/model/lobby_class.dart';
import 'package:agile_serious_game/model/team_class.dart';
import 'package:agile_serious_game/model/timer_state_enum.dart';
import 'package:agile_serious_game/model/user_story_class.dart';
import 'package:agile_serious_game/model/user_story_state_enum.dart';
import 'package:agile_serious_game/service/team_service.dart';
import 'package:agile_serious_game/service/user_story_service.dart';
import 'package:agile_serious_game/utils/frozen_circular_indicator.dart';
import 'package:agile_serious_game/utils/timer_singleton.dart';
import 'package:flutter/material.dart';

class UserStorySelection extends StatefulWidget {
  final Lobby lobby;
  final Team team;
  final AnimationController controller;

  UserStorySelection(this.controller, {this.lobby, this.team});

  @override
  _UserStorySelectionState createState() =>
      _UserStorySelectionState(controller);
}

class _UserStorySelectionState extends State<UserStorySelection> {
  AnimationController controller;
  _UserStorySelectionState(this.controller);

  List<bool> switchList;
  Future<Map<UserStory, UserStoryState>> availableStories;

  @override
  UserStorySelection get widget => super.widget;

  @override
  void initState() {
    super.initState();
    setState(() {
      switchList = new List();
      availableStories =
          TeamService().getUserStoriesOfTeam(widget.lobby, widget.team);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: FutureBuilder(
          future: availableStories,
          builder: (context,
              AsyncSnapshot<Map<UserStory, UserStoryState>> snapshot) {
            if (snapshot.hasError) {
              return AlertDialog(
                title: new Text("Error fetching data"),
              );
            }
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return FrozenCircularIndicatorWidget();
              default:
                widget.team.availableStories = snapshot.data;
                return ListView(
                  children: _buildStoryTile(widget.team.availableStories),
                );
            }
          },
        ),
      ),
    );
  }

  List<Widget> _buildStoryTile(
      Map<UserStory, UserStoryState> availableStories) {
    List<Widget> storyWidgetList = new List<Widget>();
    int index = 0;
    switchList.clear();
    availableStories.forEach((k, v) {
      if (v == UserStoryState.SELECTED) {
        switchList.add(true);
        storyWidgetList.add(_myUserStoryContainer(k, index));
        index++;
      } else if (v == UserStoryState.UNSELECTED) {
        switchList.add(false);
        storyWidgetList.add(_myUserStoryContainer(k, index));
        index++;
      }
    });
    return storyWidgetList;
  }

  Widget _myUserStoryContainer(UserStory userStory, int index) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            userStory.score.toString(),
            style: new TextStyle(color: Color(AppColors.buttonColor)),
          ),
          backgroundColor: Color(AppColors.themeColor),
        ),
        title: Text(userStory.title),
        subtitle: Text(userStory.specification),
        trailing: Switch(
          value: switchList[index],
          onChanged: (value) {
            if (controller.value != 0 &&
                TimerSingleton.state == TimerState.PLANIFICATION) {
              setState(() {
                switchList[index] = value;
                if (value) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                      duration: new Duration(seconds: 1),
                      content: Text(
                          "User story \"${userStory.title}\" sélectionné !")));
                  widget.team.selectUserStory(userStory);
                  UserStoryService().pushState(widget.lobby, widget.team,
                      userStory, UserStoryState.SELECTED);
                } else {
                  Scaffold.of(context).showSnackBar(SnackBar(
                      duration: new Duration(seconds: 1),
                      content: Text(
                          "User story \"${userStory.title}\" désélectionné !")));
                  widget.team.unSelectUserStory(userStory);
                  UserStoryService().pushState(widget.lobby, widget.team,
                      userStory, UserStoryState.UNSELECTED);
                }
              });
            } else {
              Scaffold.of(context).showSnackBar(SnackBar(
                  duration: new Duration(seconds: 1),
                  content: Text("Le chronomètre est terminé")));
            }
          },
        ),
      ),
    );
  }
}
