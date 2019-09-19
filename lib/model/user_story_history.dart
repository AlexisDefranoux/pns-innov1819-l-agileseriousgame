import 'user_story_class.dart';
import 'user_story_state_enum.dart';

class UserStoryHistory {
  int _iteration;
  UserStory _userStory;
  UserStoryState _userStoryState;
  String ref;

  UserStoryHistory(this._userStory, this._userStoryState, this._iteration);

  UserStoryState get userStoryState => _userStoryState;

  UserStory get userStory => _userStory;

  int get iteration => _iteration;
}
