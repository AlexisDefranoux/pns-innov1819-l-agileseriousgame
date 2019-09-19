import 'package:agile_serious_game/data/strings.dart';
import 'package:agile_serious_game/model/user_story_class.dart';

import 'acceptation_criteria_class.dart';

class UserStoryFactory {
  ///Builds the list of user stories from the content in strings file
  List<UserStory> buildFromStatic() {
    List<UserStory> stories = new List<UserStory>();
    var index = 0;
    for (var story in UserStoryStrings.userStories) {
      List<AcceptationCriteria> criterias = new List<AcceptationCriteria>();
      for (var criteria in story[3]) {
        criterias.add(new AcceptationCriteria(criteria));
      }
      stories.add(new UserStory(
          story[0], story[1], story[2], criterias, index, story[4]));
      index++;
    }
    return stories;
  }

  UserStory buildFromFirebase(int id) {
    var strings = UserStoryStrings.userStories[id];
    List<AcceptationCriteria> criterias = new List();
    for (var criteria in strings[3]) {
      criterias.add(new AcceptationCriteria(criteria));
    }
    return new UserStory(
        strings[0], strings[1], strings[2], criterias, id, strings[4]);
  }
}
