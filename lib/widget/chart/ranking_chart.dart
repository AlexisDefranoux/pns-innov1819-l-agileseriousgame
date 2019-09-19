import 'package:agile_serious_game/data/color.dart';
import 'package:agile_serious_game/data/strings.dart';
import 'package:agile_serious_game/model/lobby_class.dart';
import 'package:agile_serious_game/service/lobby_service.dart';
import 'package:agile_serious_game/utils/frozen_circular_indicator.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class RankingChart extends StatefulWidget {
  final Lobby lobby;

  RankingChart(this.lobby);
  @override
  _RankingChartState createState() => _RankingChartState(lobby);
}

class _RankingChartState extends State<RankingChart> {
  Lobby lobby;
  Future<Lobby> futureLobby;
  _RankingChartState(this.lobby);

  static List<OrdinalSales> createData(Map<String, int> scores) {
    final List<OrdinalSales> data = [];
    for (String key in scores.keys) {
      data.add(new OrdinalSales(key, scores[key]));
    }
    data.sort((a, b) => b.sales - a.sales);
    return data;
  }

  static List<charts.Series<OrdinalSales, String>> _createData(
      List<OrdinalSales> data) {
    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Points',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        fillColorFn: (_, __) =>
            charts.MaterialPalette.green.shadeDefault.lighter,
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
        //labelAccessorFn: (OrdinalSales sales, _) => '${sales.year.toString()} %'
      )
    ];
  }

  @override
  RankingChart get widget => super.widget;

  @override
  void initState() {
    super.initState();
    setState(() {
      futureLobby = LobbyService().getHistories(lobby);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.scoreRanking),
        backgroundColor: Color(AppColors.themeColor),
      ),
      body: FutureBuilder(
        future: futureLobby,
        builder: (context, AsyncSnapshot<Lobby> snapshot) {
          if (snapshot.hasError) {
            return AlertDialog(
              title: new Text("Error fetching data"),
            );
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return FrozenCircularIndicatorWidget();
            default:
              lobby = snapshot.data;

              return StaggeredGridView.count(
                crossAxisCount: 1,
                mainAxisSpacing: 12.0,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SlidingViewportOnSelection(
                        _createData(createData(lobby.getScores()))),
                  ),
                ],
                staggeredTiles: [
                  StaggeredTile.extent(1, 500.0),
                ],
              );
          }
        },
      ),
    );
  }
}

class SlidingViewportOnSelection extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SlidingViewportOnSelection(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: true,
      behaviors: [
        // Add the sliding viewport behavior to have the viewport center on the
        // domain that is currently selected.
        new charts.SlidingViewport(),
        // A pan and zoom behavior helps demonstrate the sliding viewport
        // behavior by allowing the data visible in the viewport to be adjusted
        // dynamically.
        new charts.PanAndZoomBehavior(),
        new charts.SeriesLegend(
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
          // Set show measures to true to display measures in series legend,
          // when the datum is selected.
          showMeasures: true,
          // Optionally provide a measure formatter to format the measure value.
          // If none is specified the value is formatted as a decimal.
          measureFormatter: (num value) {
            return value == null ? '-' : '$value points';
          },
        ),
        new charts.ChartTitle(Strings.chartTitleRanking,
            behaviorPosition: charts.BehaviorPosition.top,
            titleOutsideJustification: charts.OutsideJustification.middle,
            // Set a larger inner padding than the default (10) to avoid
            // rendering the text too close to the top measure axis tick label.
            // The top tick label may extend upwards into the top margin region
            // if it is located at the top of the draw area.
            innerPadding: 30),
        new charts.ChartTitle(Strings.chartTeams,
            behaviorPosition: charts.BehaviorPosition.bottom,
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
        new charts.ChartTitle(Strings.chartPoints,
            behaviorPosition: charts.BehaviorPosition.start,
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
      ],
      // Set an initial viewport to demonstrate the sliding viewport behavior on
      // initial chart load.
      //domainAxis: new charts.OrdinalAxisSpec(
      //   viewport: new charts.OrdinalViewport('2018', 4)),
    );
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}
