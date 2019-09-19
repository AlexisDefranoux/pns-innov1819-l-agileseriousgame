import 'dart:math';

import 'package:agile_serious_game/data/strings.dart';
import 'package:agile_serious_game/model/lobby_class.dart';
import 'package:agile_serious_game/model/team_class.dart';
import 'package:agile_serious_game/model/user_story_history_list.dart';
import 'package:agile_serious_game/service/history_service.dart';
import 'package:agile_serious_game/utils/frozen_circular_indicator.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ScoreForPlayer extends StatefulWidget {
  final Team team;
  final Lobby lobby;

  ScoreForPlayer({this.lobby, this.team});

  @override
  _ScoreForPlayerState createState() => _ScoreForPlayerState();
}

class _ScoreForPlayerState extends State<ScoreForPlayer> {
  Future<UserStoryHistoryList> userStoryHistoryList;

  _ScoreForPlayerState();

  static List<GaugeSegment> createData(int refusedScore, int acceptedScore) {
    final List<GaugeSegment> data = [];
    data.add(new GaugeSegment('Acceptés :', acceptedScore,
        charts.MaterialPalette.green.shadeDefault));
    data.add(new GaugeSegment(
        'Refusés :', refusedScore, charts.MaterialPalette.red.shadeDefault));
    return data;
  }

  static List<charts.Series<GaugeSegment, String>> _createData(
      List<GaugeSegment> data) {
    return [
      new charts.Series<GaugeSegment, String>(
        id: 'Segments',
        domainFn: (GaugeSegment segment, _) => segment.segment,
        measureFn: (GaugeSegment segment, _) => segment.size,
        colorFn: (GaugeSegment segment, _) => segment.color,
        data: data,
      )
    ];
  }

  @override
  ScoreForPlayer get widget => super.widget;

  @override
  void initState() {
    super.initState();
    setState(() {
      userStoryHistoryList =
          HistoryService().getUserHistoryList(widget.lobby, widget.team);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: FutureBuilder(
          future: userStoryHistoryList,
          builder: (context, AsyncSnapshot<UserStoryHistoryList> snapshot) {
            if (snapshot.hasError) {
              return AlertDialog(
                title: new Text("Error fetching data"),
              );
            }
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return FrozenCircularIndicatorWidget();
              default:
                widget.team.userStoryHistoryList = snapshot.data;

                return StaggeredGridView.count(
                  crossAxisCount: 1,
                  mainAxisSpacing: 12.0,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: GaugeChart(
                          Strings.chartTitlePlayerPoints,
                          "points",
                          _createData(createData(
                              widget.team.userStoryHistoryList
                                  .getRefusedScore(),
                              widget.team.userStoryHistoryList
                                  .getValidatedScore())),
                          animate: true),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: GaugeChart(
                          Strings.chartTitlePlayerUserStory,
                          "stories",
                          _createData(createData(
                              widget.team.userStoryHistoryList
                                  .getNumberOfRefusedStory(),
                              widget.team.userStoryHistoryList
                                  .getNumberOfValidatedStory())),
                          animate: true),
                    ),
                  ],
                  staggeredTiles: [
                    StaggeredTile.extent(1, 220.0),
                    StaggeredTile.extent(1, 220.0),
                  ],
                );
            }
          },
        ),
      ),
    );
  }
}

class GaugeChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  final String title;
  final String legend;

  GaugeChart(this.title, this.legend, this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(
      seriesList,
      animate: animate,
      // Configure the width of the pie slices to 30px. The remaining space in
      // the chart will be left as a hole in the center. Adjust the start
      // angle and the arc length of the pie so it resembles a gauge.
      defaultRenderer: new charts.ArcRendererConfig(
          arcWidth: 30, startAngle: pi, arcLength: pi),
      behaviors: [
        new charts.DatumLegend(
          // Positions for "start" and "end" will be left and right respectively
          // for widgets with a build context that has directionality ltr.
          // For rtl, "start" and "end" will be right and left respectively.
          // Since this example has directionality of ltr, the legend is
          // positioned on the right side of the chart.
          position: charts.BehaviorPosition.bottom,
          // By default, if the position of the chart is on the left or right of
          // the chart, [horizontalFirst] is set to false. This means that the
          // legend entries will grow as new rows first instead of a new column.
          horizontalFirst: false,
          // This defines the padding around each legend entry.
          cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
          // Set [showMeasures] to true to display measures in series legend.
          showMeasures: true,
          // Configure the measure value to be shown by default in the legend.
          legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
          // Optionally provide a measure formatter to format the measure value.
          // If none is specified the value is formatted as a decimal.
          measureFormatter: (num value) {
            return value == null ? '-' : '$value $legend';
          },
        ),
        new charts.ChartTitle(title,
            behaviorPosition: charts.BehaviorPosition.top,
            titleOutsideJustification: charts.OutsideJustification.middle,
            innerPadding: 18),
      ],
    );
  }
}

/// Sample data type.
class GaugeSegment {
  final String segment;
  final int size;
  final charts.Color color;

  GaugeSegment(this.segment, this.size, this.color);
}
