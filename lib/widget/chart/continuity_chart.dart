import 'package:agile_serious_game/data/color.dart';
import 'package:agile_serious_game/data/strings.dart';
import 'package:agile_serious_game/model/lobby_class.dart';
import 'package:agile_serious_game/service/lobby_service.dart';
import 'package:agile_serious_game/utils/frozen_circular_indicator.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ContinuityChart extends StatefulWidget {
  final Lobby lobby;

  const ContinuityChart({Key key, this.lobby}) : super(key: key);

  @override
  _ContinuityChartState createState() => _ContinuityChartState();
}

class _ContinuityChartState extends State<ContinuityChart> {
  Future<Lobby> futureLobby;
  Lobby lobby;

  @override
  ContinuityChart get widget {
    return super.widget;
  }

  @override
  void initState() {
    super.initState();
    futureLobby = LobbyService().getHistories(widget.lobby);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Strings.scoreContinuity),
          backgroundColor: Color(AppColors.themeColor),
        ),
        body: new FutureBuilder(
            future: futureLobby,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return new Text("Error fetching data");
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
                        child: DashPatternLineChart.withSampleData(
                            lobby.getIterationScore()),
                      ),
                    ],
                    staggeredTiles: [
                      StaggeredTile.extent(1, 500.0),
                    ],
                  );
              }
            }));
  }
}

class DashPatternLineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  DashPatternLineChart(this.seriesList, {this.animate});

  /// Creates a [LineChart] with sample data and no transition.
  factory DashPatternLineChart.withSampleData(
      Map<String, Map<int, int>> iterationScore) {
    return new DashPatternLineChart(
      _createSampleData(iterationScore),
      // Disable animations for image tests.
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(
      seriesList,
      animate: animate,
      behaviors: [
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
        new charts.ChartTitle(Strings.chartTitleContinuity,
            behaviorPosition: charts.BehaviorPosition.top,
            titleOutsideJustification: charts.OutsideJustification.middle,
            // Set a larger inner padding than the default (10) to avoid
            // rendering the text too close to the top measure axis tick label.
            // The top tick label may extend upwards into the top margin region
            // if it is located at the top of the draw area.
            innerPadding: 30),
        new charts.ChartTitle(Strings.chartIterations,
            behaviorPosition: charts.BehaviorPosition.bottom,
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
        new charts.ChartTitle(Strings.chartPoints,
            behaviorPosition: charts.BehaviorPosition.start,
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
      ],
    );
  }

  /// Create three series with sample hard coded data.
  static List<charts.Series<LinearSales, int>> _createSampleData(
      Map<String, Map<int, int>> iterationScore) {
    List<charts.Series<LinearSales, int>> res = new List();

    iterationScore.forEach((name, scoreIteration) {
      List<LinearSales> values = new List();
      scoreIteration.forEach((iteration, score) {
        values.add(new LinearSales(iteration, score));
      });
      res.add(new charts.Series<LinearSales, int>(
          id: name,
          domainFn: (LinearSales sales, _) => sales.year,
          measureFn: (LinearSales sales, _) => sales.sales,
          data: values));
    });

    return res;
  }
}

/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}
