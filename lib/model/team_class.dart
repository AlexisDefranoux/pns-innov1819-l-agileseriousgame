import 'dart:collection';
import 'package:agile_serious_game/model/user_story_history.dart';
import 'package:agile_serious_game/service/user_story_service.dart';

import 'lobby_class.dart';
import 'user_story_class.dart';
import 'user_story_history_list.dart';
import 'user_story_state_enum.dart';

class Team {
  String _name;
  Map<UserStory, UserStoryState> availableStories;
  UserStoryHistoryList userStoryHistoryList;

  Team(this._name, userStories) {
    availableStories = new HashMap<UserStory, UserStoryState>();
    userStoryHistoryList = new UserStoryHistoryList();
    userStories.forEach(
        (userStory) => availableStories[userStory] = UserStoryState.IDLE);
  }

  Team.fromFirebase(String id) {
    _name = id;
    availableStories = new HashMap();
    userStoryHistoryList = new UserStoryHistoryList();
  }

  String get name => _name;

  nextIteration(int actualIteration, Lobby lobby) {
    availableStories.forEach((k, v) {
      if (k.iteration == actualIteration && UserStoryState.IDLE == v) {
        v = UserStoryState.UNSELECTED;
        UserStoryService().pushState(lobby, this, k, v);
      }
    });
  }

  ///Changes the state of the user story to selected
  bool selectUserStory(UserStory userStory) {
    if (availableStories[userStory] == UserStoryState.UNSELECTED) {
      availableStories[userStory] = UserStoryState.SELECTED;
      return true;
    }
    return false;
  }

  ///Changes the state of the user story to unselected
  bool unSelectUserStory(UserStory userStory) {
    if (availableStories[userStory] == UserStoryState.SELECTED) {
      availableStories[userStory] = UserStoryState.UNSELECTED;
      return true;
    }
    return false;
  }

  ///Changes the state of the user story to refused
  UserStoryHistory refuse(UserStory userStory, int actualIteration) {
    if (availableStories[userStory] == UserStoryState.SELECTED) {
      availableStories[userStory] = UserStoryState.UNSELECTED;
      return userStoryHistoryList.addAnEvent(
          userStory, UserStoryState.REFUSED, actualIteration);
    }
    return null;
  }

  ///Changes the state of the user story to validated
  UserStoryHistory validate(UserStory userStory, int actualIteration) {
    if (availableStories[userStory] == UserStoryState.SELECTED) {
      availableStories.remove(userStory);
      return userStoryHistoryList.addAnEvent(
          userStory, UserStoryState.VALIDATED, actualIteration);
    }
    return null;
  }

  bool undoUserStory(UserStory userStory) {
    availableStories[userStory] = UserStoryState.SELECTED;
    return true;
  }

  UserStory getUserStory(String title) {
    UserStory userStory;
    availableStories.forEach((k, v) {
      if (k.title == title) userStory = k;
    });
    return userStory;
  }

  UserStoryState getUserStoryState(String title) {
    UserStoryState userStoryState;
    availableStories.forEach((k, v) {
      if (k.title == title) userStoryState = v;
    });
    return userStoryState;
  }

  @override
  bool operator ==(other) => other is Team && other.name == name;

  @override
  int get hashCode => name.hashCode;
}
