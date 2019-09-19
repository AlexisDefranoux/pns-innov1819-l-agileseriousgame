import 'dart:io';
import 'dart:math';

import 'package:agile_serious_game/model/lobby_class.dart';
import 'package:agile_serious_game/model/timer_state_enum.dart';
import 'package:agile_serious_game/service/lobby_service.dart';
import 'package:agile_serious_game/utils/timer_singleton.dart';
import 'package:flutter/material.dart';

class TimerPage extends StatefulWidget {
  final bool admin;
  final Lobby lobby;
  final AnimationController controller;

  TimerPage(this.admin, this.controller, {this.lobby});

  @override
  _TimerPageState createState() => _TimerPageState(controller);
}

class _TimerPageState extends State<TimerPage> with TickerProviderStateMixin {
  Icon icon;
  AnimationController controller;

  _TimerPageState(this.controller);

  @override
  TimerPage get widget => super.widget;

  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    icon = new Icon(controller.isAnimating ? Icons.pause : Icons.play_arrow);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: _buildChronometer(),
          /*children: <Widget>[
            Text(titleTimer,
            style: DefaultTextStyle.of(context)
                .style
                .apply(fontSizeFactor: 3.0)),

            ],*/
        ),
      ),
    );
  }

  Widget button(bool admin) {
    if (admin) {
      return Container(
        margin: EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FloatingActionButton(
              backgroundColor: Colors.black,
              child: AnimatedBuilder(
                animation: controller,
                builder: (BuildContext context, Widget child) {
                  return icon;
                },
              ),
              onPressed: () {
                var service = LobbyService();
                if (controller.isAnimating) {
                  service.setChronometer(widget.lobby, false);
                  controller.stop();
                  icon = new Icon(Icons.play_arrow);
                } else {
                  service.setChronometer(widget.lobby, true);
                  controller.reverse(
                      from: controller.value == 0.0 ? 1.0 : controller.value);
                  icon = new Icon(Icons.pause);
                  if (TimerSingleton.state == TimerState.PLANIFICATION)
                    widget.lobby.nextIteration();
                }
              },
            )
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget timer() {
    return Expanded(
      child: Align(
        alignment: FractionalOffset.center,
        child: AspectRatio(
          aspectRatio: 1.0,
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: controller,
                  builder: (BuildContext context, Widget child) {
                    return new CustomPaint(
                      painter: TimerPainter(
                        animation: controller,
                        backgroundColor: Colors.black12,
                        color: Colors.black,
                      ),
                    );
                  },
                ),
              ),
              Align(
                alignment: FractionalOffset.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    AnimatedBuilder(
                      animation: controller,
                      builder: (BuildContext context, Widget child) {
                        return new Text(TimerSingleton.titleTimer,
                            style: DefaultTextStyle.of(context)
                                .style
                                .apply(fontSizeFactor: 2.5));
                      },
                    ),
                    /*Text(titleTimer,
                        style: DefaultTextStyle.of(context)
                            .style
                            .apply(fontSizeFactor: 3.0)),*/
                    AnimatedBuilder(
                      animation: controller,
                      builder: (BuildContext context, Widget child) {
                        if (controller.value > 0 && controller.value <= 0.01) {
                          sleep(const Duration(seconds: 1));
                          icon = new Icon(Icons.play_arrow);
                          TimerSingleton.changePhaseAndIteration(controller);
                        }
                        if (controller.value == 0 && widget.admin) {
                          sleep(const Duration(seconds: 1));
                          icon = new Icon(Icons.play_arrow);
                          LobbyService().setChronometer(widget.lobby, false);
                        }
                        return new Text(timerString,
                            style: DefaultTextStyle.of(context)
                                .style
                                .apply(fontSizeFactor: 8.0));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildChronometer() {
    List<Widget> widgets = new List();
    widgets.add(
      AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget child) {
          return new Text("Itération " + TimerSingleton.iteration.toString(),
              style: DefaultTextStyle.of(context)
                  .style
                  .apply(fontSizeFactor: 2.0));
        },
      ),
    );

    if (widget.admin) {
      widgets.add(timer());
      widgets.add(button(widget.admin));
      return widgets;
    }
    var service = LobbyService();
    service.getChronometer(widget.lobby).listen((val) {
      if (val) {
        icon = new Icon(Icons.pause);
      } else {
        controller.stop();
        icon = new Icon(Icons.play_arrow);
      }
    });

    widgets.add(new StreamBuilder(
      stream: service.getChronometer(widget.lobby),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return new Text("Error");
        }
        if (snapshot.data != null) {
          if (snapshot.data) {
            controller.reverse(
                from: controller.value == 0.0 ? 1.0 : controller.value);
            icon = new Icon(Icons.pause);
          } else {
            controller.stop();
            icon = new Icon(Icons.play_arrow);
          }
        }
        return timer();
      },
    ));
    return widgets;
  }
}

class TimerPainter extends CustomPainter {
  TimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * pi;
    canvas.drawArc(Offset.zero & size, pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(TimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
