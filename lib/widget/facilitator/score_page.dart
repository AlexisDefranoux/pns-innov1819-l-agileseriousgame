import 'package:agile_serious_game/data/strings.dart';
import 'package:agile_serious_game/model/lobby_class.dart';
import 'package:agile_serious_game/model/team_class.dart';
import 'package:agile_serious_game/widget/chart/continuity_chart.dart';
import 'package:agile_serious_game/widget/chart/performance_chart.dart';
import 'package:agile_serious_game/widget/chart/ranking_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ScorePage extends StatefulWidget {
  final Lobby lobby;
  final Team team;

  ScorePage({this.lobby, this.team});

  @override
  _ScorePageState createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  Material card(IconData icon, String heading, int color) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      shadowColor: Color(0x802196F3),
      borderRadius: BorderRadius.circular(24.0),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              // children: <Widget>[
              //ICON
              Material(
                color: new Color(color),
                borderRadius: BorderRadius.circular(24.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 30.0,
                  ),
                ),
              ),
              //TEXT
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  heading,
                  style: TextStyle(
                    color: new Color(color),
                    fontSize: 20.0,
                  ),
                ),
              ),
            ],
            //  )
            //  ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StaggeredGridView.count(
        crossAxisCount: 1,
        mainAxisSpacing: 12.0,
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        children: <Widget>[
          GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PerformanceChart(widget.lobby))),
            child: card(Icons.call_missed_outgoing, Strings.scorePerformance,
                0xff26cb3c),
          ),
          GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RankingChart(widget.lobby))),
            child: card(Icons.done_all, Strings.scoreRanking, 0xffff622F74),
          ),
          GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ContinuityChart(lobby: widget.lobby))),
            child: card(Icons.timeline, Strings.scoreContinuity, 0xff3399fe),
          ),
        ],
        staggeredTiles: [
          StaggeredTile.extent(1, 150.0),
          StaggeredTile.extent(1, 150.0),
          StaggeredTile.extent(1, 150.0),
        ],
      ),
    );
  }

  @override
  ScorePage get widget => super.widget;
}
