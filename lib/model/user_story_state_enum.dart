///Enum which represents the state of a user story
enum UserStoryState { IDLE, UNSELECTED, SELECTED, REFUSED, VALIDATED }

class UserStoryStateUtils {
  UserStoryState buildFromFirebase(String state) {
    if (state == toFirebaseString(UserStoryState.SELECTED)) {
      return UserStoryState.SELECTED;
    } else if (state == toFirebaseString(UserStoryState.VALIDATED)) {
      return UserStoryState.VALIDATED;
    } else if (state == toFirebaseString(UserStoryState.REFUSED)) {
      return UserStoryState.REFUSED;
    } else if (state == toFirebaseString(UserStoryState.UNSELECTED)) {
      return UserStoryState.UNSELECTED;
    } else if (state == toFirebaseString(UserStoryState.IDLE)) {
      return UserStoryState.IDLE;
    }
    return null;
  }

  String toFirebaseString(UserStoryState state) {
    if (state == UserStoryState.UNSELECTED) {
      return "unselected";
    } else if (state == UserStoryState.REFUSED) {
      return "refused";
    } else if (state == UserStoryState.VALIDATED) {
      return "validated";
    } else if (state == UserStoryState.SELECTED) {
      return "selected";
    } else if (state == UserStoryState.IDLE) {
      return "idle";
    }
    return "";
  }
}
