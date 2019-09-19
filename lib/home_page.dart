import 'dart:async';
import 'dart:ui';

import 'package:agile_serious_game/data/color.dart';
import 'package:agile_serious_game/data/strings.dart';
import 'package:agile_serious_game/widget/facilitator/configure_page.dart';
import 'package:agile_serious_game/widget/player/rejoin_page.dart';
import 'package:flutter/material.dart';

import 'model/lobby_class.dart';

void main() => runApp(HomePage());

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ButtonMenu(),
    );
  }
}

class ButtonMenu extends StatefulWidget {
  @override
  _ButtonMenuState createState() => new _ButtonMenuState();
}

class _ButtonMenuState extends State<ButtonMenu> {
  Future<Lobby> lobby;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(AppColors.background),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: new Text(
                Strings.appBarTitle,
                style: new TextStyle(
                  color: Colors.white,
                  fontFamily: "Anton-Regular",
                  fontSize: 40.0,
                ),
              ),
            ),
            new Container(
                padding: EdgeInsets.only(bottom: 15.0),
                width: 200,
                height: 65,
                child: new RaisedButton(
                  elevation: 0,
                  child: new Text(
                    Strings.appButtonFacilitator,
                    style: new TextStyle(
                        fontSize: 20.0,
                        color: Color(AppColors.buttonTextColor)),
                  ),
                  color: Color(AppColors.buttonColor),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ConfigurePage()),
                    );
                  },
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                )),
            new Container(
              padding: EdgeInsets.only(bottom: 15.0),
              width: 200,
              height: 65,
              child: new RaisedButton(
                elevation: 0,
                child: new Text(
                  Strings.appButtonPlayer,
                  style: new TextStyle(
                    fontSize: 20.0,
                    color: Color(AppColors.buttonTextColor),
                  ),
                ),
                color: Color(AppColors.buttonColor),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RejoinPage()),
                  );
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
