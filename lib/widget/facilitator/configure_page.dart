import 'dart:ui';

import 'package:agile_serious_game/data/color.dart';
import 'package:agile_serious_game/data/strings.dart';
import 'package:agile_serious_game/model/lobby_class.dart';
import 'package:agile_serious_game/service/lobby_service.dart';
import 'package:agile_serious_game/utils/frozen_circular_indicator.dart';
import 'package:agile_serious_game/utils/timer_singleton.dart';
import 'package:agile_serious_game/widget/administration_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConfigurePage extends StatefulWidget {
  @override
  _ConfigurePageState createState() => _ConfigurePageState();
}

class _ConfigurePageState extends State<ConfigurePage> {
  Lobby lobby;

  var selected = '1';
  List<DropdownMenuItem<String>> listDrop = [];
  var listString = Strings.numberOfPlayer;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    lobby = Lobby();
    TimerSingleton.reset();
  }

  @override
  Widget build(BuildContext context) {
    listDrop = listString
        .map((val) => new DropdownMenuItem<String>(
              child: new Text(val),
              value: val,
            ))
        .toList();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(AppColors.background),
      appBar: AppBar(
        backgroundColor: Color(AppColors.background),
        title: Text(Strings.appBarTitleCreateLobby),
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
                                new Container(
                                  padding: const EdgeInsets.only(
                                      top: 40.0, bottom: 20.0),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 30.0),
                                        child: new Icon(Icons.lock_open),
                                      ),
                                      new Text(
                                        " Clé de la partie",
                                        style: new TextStyle(
                                          fontSize: 20.0,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 60.0),
                                        child: new IconButton(
                                            icon: Icon(Icons.content_copy),
                                            tooltip: 'copy',
                                            onPressed: () {
                                              TimerSingleton.reset();
                                              Clipboard.setData(
                                                  new ClipboardData(
                                                      text: lobby.key));
                                              _scaffoldKey.currentState
                                                  .showSnackBar(SnackBar(
                                                      duration: new Duration(
                                                          seconds: 1),
                                                      content: Text(
                                                          'La clé a été copié')));
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                                new Container(
                                  // Show the key of a lobby
                                  child: new Text(
                                    lobby == null ? "" : lobby.key,
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 23.0,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 40),
                                  child: new Row(
//                          mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Container(
                                        height: 3,
                                        width: 150,
                                        decoration: BoxDecoration(
                                            gradient:
                                                new LinearGradient(colors: [
                                          Colors.white10,
                                          Colors.amberAccent,
                                        ])),
                                      ),
                                      new Container(
                                        height: 3,
                                        width: 150,
                                        decoration: BoxDecoration(
                                            gradient:
                                                new LinearGradient(colors: [
                                          Colors.amberAccent,
                                          Colors.white10,
                                        ])),
                                      ),
                                    ],
                                  ),
                                ),
                                new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: new Icon(Icons.people),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                          top: 40.0, bottom: 40.0, right: 20.0),
                                      child: new Text(
                                        Strings.playerNumber,
                                        style: new TextStyle(
                                          fontSize: 20.0,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 45.0,
                                      child: new DropdownButton<String>(
                                        items: listDrop,
                                        iconSize: 24,
                                        onChanged: (String newValueSelected) {
                                          setState(() {
                                            this.selected = newValueSelected;
                                          });
                                        },
                                        value: selected,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              new Positioned(
                child: buildCreateButton(),
                top: 335,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _buildTeamsAndShare() async {
    var service = LobbyService();
    await service.createLobby(lobby);
    return Future.value();
  }

  Widget buildCreateButton() {
    return new Container(
      padding: EdgeInsets.only(bottom: 15.0),
      width: 200,
      height: 65,
      child: new RaisedButton(
        color: Colors.amberAccent,
        child: Text(
          Strings.appButtonCreate,
          style: new TextStyle(
            color: Color(AppColors.buttonColor),
            fontSize: 20.0,
          ),
        ),
        onPressed: () {
          lobby.createTeamAndUserStory(int.parse(selected));
          Future<void> callback = _buildTeamsAndShare();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => new FutureBuilder(
                    future: callback,
                    builder: (context, AsyncSnapshot<void> snapshot) {
                      if (snapshot.hasError) {
                        //TODO message d'erreur
                        //Scaffold.of(context).showSnackBar(SnackBar(content: Text("Error fetching lobby")));
                        return this.widget;
                      }
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return new FrozenCircularIndicatorWidget();
                        default:
                          return new AdministrationMenu(
                            lobby: lobby,
                            admin: true,
                          );
                      }
                    },
                  ),
            ),
          );
        },
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
      ),
    );
  }
}
