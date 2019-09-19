import 'user_story_class.dart';
import 'user_story_history.dart';
import 'user_story_state_enum.dart';

class UserStoryHistoryList {
  List<UserStoryHistory> _userStoryHistories;

  UserStoryHistoryList() {
    _userStoryHistories = new List();
  }

  UserStoryHistoryList.fromList(List<UserStoryHistory> history) {
    _userStoryHistories = history;
  }

  List<UserStoryHistory> get userStoryHistories => _userStoryHistories;

  int getTotalScoreAtIteration(int iteration) {
    return (getValidatedScoreAtIteration(iteration) -
        getRefusedScoreAtIteration(iteration));
  }

  int getRefusedScoreAtIteration(int iteration) {
    int score = 0;
    userStoryHistories.forEach((event) {
      if (event.iteration == iteration &&
          event.userStoryState == UserStoryState.REFUSED) {
        score += event.userStory.score;
      }
    });
    return score;
  }

  int getValidatedScoreAtIteration(int iteration) {
    int score = 0;
    userStoryHistories.forEach((event) {
      if (event.iteration == iteration &&
          event.userStoryState == UserStoryState.VALIDATED) {
        score += event.userStory.score;
      }
    });
    return score;
  }

  int getTotalScore() {
    return getValidatedScore() - getRefusedScore();
  }

  int getRefusedScore() {
    int score = 0;
    userStoryHistories.forEach((event) {
      if (event.userStoryState == UserStoryState.REFUSED) {
        score = score + event.userStory.score;
      }
    });
    return score;
  }

  int getValidatedScore() {
    int score = 0;
    userStoryHistories.forEach((event) {
      if (event.userStoryState == UserStoryState.VALIDATED) {
        score = score + event.userStory.score;
      }
    });
    return score;
  }

  int getRefusedScoreByIteration(int iteration) {
    int score = 0;
    userStoryHistories.forEach((event) {
      if (event.userStoryState == UserStoryState.REFUSED &&
          event.iteration == iteration) {
        score = score + event.userStory.score;
      }
    });
    return score;
  }

  int getValidatedScoreByIteration(int iteration) {
    int score = 0;
    userStoryHistories.forEach((event) {
      if (event.userStoryState == UserStoryState.VALIDATED &&
          event.iteration == iteration) {
        score = score + event.userStory.score;
      }
    });
    return score;
  }

  UserStoryHistory addAnEvent(
      UserStory userStory, UserStoryState userStoryState, int actualIteration) {
    UserStoryHistory userStoryHistory =
        new UserStoryHistory(userStory, userStoryState, actualIteration);
    _userStoryHistories.add(userStoryHistory);
    return userStoryHistory;
  }

  void removeAnEvent(UserStoryHistory userStoryHistory) {
    _userStoryHistories.remove(userStoryHistory);
  }

  int getNumberOfValidatedStory() {
    int nbr = 0;
    userStoryHistories.forEach((event) {
      if (event.userStoryState == UserStoryState.VALIDATED) {
        nbr++;
      }
    });
    return nbr;
  }

  int getNumberOfRefusedStory() {
    int nbr = 0;
    userStoryHistories.forEach((event) {
      if (event.userStoryState == UserStoryState.REFUSED) {
        nbr++;
      }
    });
    return nbr;
  }
}
