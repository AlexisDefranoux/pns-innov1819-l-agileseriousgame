import 'package:agile_serious_game/data/strings.dart';
import 'package:agile_serious_game/model/timer_state_enum.dart';
import 'package:flutter/animation.dart';

class TimerSingleton {
  static final TimerSingleton _singleton = new TimerSingleton._internal();

  factory TimerSingleton() {
    return _singleton;
  }

  TimerSingleton._internal();

  static String titleTimer = Strings.titlePlanification;
  static TimerState state = TimerState.PLANIFICATION;
  static int timer = 30;
  static int phase = 1;
  static int iteration = 1;
  static bool ok = false;

  static void reset() {
    titleTimer = Strings.titlePlanification;
    state = TimerState.PLANIFICATION;
    timer = 30;
    phase = 1;
    iteration = 1;
    ok = false;
  }

  static void changePhaseAndIteration(AnimationController controller) {
    if (phase % 4 == 0) {
      iteration++;
    }
    phase++;
    _changeState(controller);
  }

  static void _changeState(AnimationController controller) {
    switch (state) {
      case TimerState.PLANIFICATION:
        state = TimerState.REALISATION;
        controller.duration = Duration(seconds: 10);
        titleTimer = Strings.titleRealisation;
        break;
      case TimerState.REALISATION:
        state = TimerState.REVUE;
        controller.duration = Duration(seconds: 30);
        titleTimer = Strings.titleRevue;
        break;
      case TimerState.REVUE:
        state = TimerState.RETROSPECTIVE;
        controller.duration = Duration(seconds: 10);
        titleTimer = Strings.titleRetrospective;
        break;
      case TimerState.RETROSPECTIVE:
        state = TimerState.PLANIFICATION;
        controller.duration = Duration(seconds: 30);
        titleTimer = Strings.titlePlanification;
        break;
      default:
        return null;
    }
  }
}
