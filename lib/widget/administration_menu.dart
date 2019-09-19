import 'package:agile_serious_game/data/color.dart';
import 'package:agile_serious_game/data/strings.dart';
import 'package:agile_serious_game/model/lobby_class.dart';
import 'package:agile_serious_game/model/team_class.dart';
import 'package:agile_serious_game/utils/timer_singleton.dart';
import 'package:agile_serious_game/widget/facilitator/score_page.dart';
import 'package:agile_serious_game/widget/facilitator/user_story_validation.dart';
import 'package:agile_serious_game/widget/player/score_for_player.dart';
import 'package:agile_serious_game/widget/player/user_story_selection.dart';
import 'package:agile_serious_game/widget/timer_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdministrationMenu extends StatefulWidget {
  final bool admin;
  final Lobby lobby;
  final Team team;

  AdministrationMenu({this.lobby, this.team, this.admin});

  @override
  _AdministrationMenuState createState() => _AdministrationMenuState();
}

class _AdministrationMenuState extends State<AdministrationMenu>
    with TickerProviderStateMixin {
  TabController _tabController;
  List tabs = [
    Strings.appBarSubTitle1,
    Strings.appBarSubTitle2,
    Strings.appBarSubTitle3
  ];

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  AnimationController controller;

  @override
  AdministrationMenu get widget => super.widget;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(() {});
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: TimerSingleton.timer),
    );
  }

  Widget _appBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Container(
        height: 45,
        child: new Row(
          children: <Widget>[
            Text(
              "Clé: ",
              style: new TextStyle(
                fontSize: 20,
              ),
            ),
            Text(
              widget.lobby.key,
              style: new TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Container(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                      icon: Icon(Icons.content_copy),
                      onPressed: () {
                        Clipboard.setData(
                            new ClipboardData(text: widget.lobby.key));
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                            duration: new Duration(seconds: 1),
                            content: Text('La clé a été copié')));
                      }),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Text _appBarTitle() {
    if (widget.admin) return Text(Strings.appBarTitleAdmin);
    return Text(Strings.appBarTitle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(AppColors.themeColor),
        title: _appBarTitle(),
        bottom: TabBar(
            controller: _tabController,
            tabs: tabs.map((e) => Tab(text: e)).toList()),
      ),
      bottomNavigationBar: new BottomAppBar(
        child: _appBar(),
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: _method(),
      ),
    );
  }

  List<Widget> _method() {
    List<Widget> widgetList;
    if (widget.admin) {
      widgetList = [
        TimerPage(widget.admin, controller, lobby: widget.lobby),
        UserStoryValidation(lobby: widget.lobby),
        ScorePage(lobby: widget.lobby, team: widget.team),
      ];
    } else {
      widgetList = [
        TimerPage(widget.admin, controller, lobby: widget.lobby),
        UserStorySelection(controller, lobby: widget.lobby, team: widget.team),
        ScoreForPlayer(lobby: widget.lobby, team: widget.team)
      ];
    }

    return widgetList;
  }
}
