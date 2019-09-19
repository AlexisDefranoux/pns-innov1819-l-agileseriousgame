import 'package:agile_serious_game/data/color.dart';
import 'package:agile_serious_game/data/strings.dart';
import 'package:agile_serious_game/model/lobby_class.dart';
import 'package:agile_serious_game/model/team_class.dart';
import 'package:agile_serious_game/service/lobby_service.dart';
import 'package:agile_serious_game/service/team_service.dart';
import 'package:agile_serious_game/utils/frozen_circular_indicator.dart';
import 'package:agile_serious_game/utils/timer_singleton.dart';
import 'package:agile_serious_game/widget/administration_menu.dart';
import 'package:flutter/material.dart';

class RejoinPage extends StatefulWidget {
  RejoinPage();

  @override
  _RejoinPageState createState() => _RejoinPageState();
}

class _RejoinPageState extends State<RejoinPage> {
  final TextEditingController _lobbyController =
      new TextEditingController(text: '');
  final TextEditingController _teamController =
      new TextEditingController(text: '');
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void setState(fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(AppColors.background),
      appBar: AppBar(
        backgroundColor: Color(AppColors.background),
        title: Text(Strings.appBarTitleJoinLobby),
      ),
      body: new SafeArea(
        child: Container(
          height: 440,
          child: new Stack(
            alignment: Alignment.center,
            overflow: Overflow.visible,
            fit: StackFit.expand,
            children: <Widget>[
              new Stack(
                alignment: Alignment.center,
                overflow: Overflow.visible,
                children: <Widget>[
                  new SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50, bottom: 80),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            decoration: new BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              gradient: const LinearGradient(colors: [
                                Colors.white,
                                Colors.white,
                              ]),
                            ),
                            width: 315,
                            height: 310,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 40, bottom: 10.0),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 25.0, right: 5.0),
                                        child: new Icon(Icons.lock_open),
                                      ),
                                      new Text(
                                        Strings.lobbyKey,
                                        style: new TextStyle(
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 40.0),
                                  child: Container(
                                    width: 250,
                                    child: new TextField(
                                      controller: _lobbyController,
                                      decoration: new InputDecoration(),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 25.0, right: 5.0),
                                      child: new Icon(Icons.person_add),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: new Text(
                                        Strings.teamKey,
                                        style: new TextStyle(
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 50.0),
                                  child: Container(
                                    width: 250,
                                    child: new TextFormField(
                                      controller: _teamController,
                                      decoration: new InputDecoration(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  new Positioned(
                    child: buildRejoinButton(),
                    top: 335,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRejoinButton() {
    return Container(
      padding: EdgeInsets.only(bottom: 15.0),
      width: 200,
      height: 65,
      child: new RaisedButton(
        color: Colors.amberAccent,
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        child: Text(
          Strings.appButtonJoin,
          style: new TextStyle(
              fontSize: 20.0, color: Color(AppColors.buttonColor)),
        ),
        onPressed: () {
          TimerSingleton.reset();
          Future<Lobby> lobby = LobbyService().getLobby(_lobbyController.text);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => new FutureBuilder(
                    future: lobby,
                    builder: (context, AsyncSnapshot<Lobby> snapshot) {
                      if (snapshot.hasError) {
                        _callSnackBar();
                        return errorPage();
                      }
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return new FrozenCircularIndicatorWidget();
                        default:
                          Future<Team> team = TeamService().getTeam(
                              _lobbyController.text,
                              _teamController.text.toUpperCase());
                          return new FutureBuilder(
                            future: team,
                            builder: (context, AsyncSnapshot<Team> teamSnap) {
                              if (teamSnap.hasError) {
                                return this.widget;
                              }
                              switch (teamSnap.connectionState) {
                                case ConnectionState.waiting:
                                  return new Stack(
                                    children: <Widget>[
                                      FrozenCircularIndicatorWidget()
                                    ],
                                  );
                                default:
                                  return AdministrationMenu(
                                    lobby: snapshot.data,
                                    team: teamSnap.data,
                                    admin: false,
                                  );
                              }
                            },
                          );
                      }
                    },
                  ),
            ),
          );
        },
      ),
    );
  }

  void _callSnackBar() {
    Future.delayed(Duration(milliseconds: 200)).then((e) {
      setState(() {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
            duration: new Duration(seconds: 1), content: Text('Erreur')));
      });
    });
  }

  Widget errorPage() {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(AppColors.background),
      appBar: AppBar(
        backgroundColor: Color(AppColors.background),
        title: Text(Strings.appBarTitleJoinLobby),
      ),
      body: new SafeArea(
        child: Container(
          height: 420,
          child: new Stack(
            alignment: Alignment.center,
            overflow: Overflow.visible,
            fit: StackFit.expand,
            children: <Widget>[
              new Stack(
                alignment: Alignment.center,
                overflow: Overflow.visible,
                children: <Widget>[
                  new SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50, bottom: 80),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            decoration: new BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              gradient: const LinearGradient(colors: [
                                Colors.white,
                                Colors.white,
                              ]),
                            ),
                            width: 315,
                            height: 310,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 40, bottom: 10.0),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 25.0, right: 5.0),
                                        child: new Icon(Icons.lock_open),
                                      ),
                                      new Text(
                                        Strings.lobbyKey,
                                        style: new TextStyle(
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 40.0),
                                  child: Container(
                                    width: 250,
                                    child: new TextField(
                                      controller: _lobbyController,
                                      decoration: new InputDecoration(),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 25.0, right: 5.0),
                                      child: new Icon(Icons.person_add),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: new Text(
                                        Strings.teamKey,
                                        style: new TextStyle(
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 50.0),
                                  child: Container(
                                    width: 250,
                                    child: new TextFormField(
                                      controller: _teamController,
                                      decoration: new InputDecoration(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  new Positioned(
                    child: buildRejoinButton(),
                    top: 335,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
