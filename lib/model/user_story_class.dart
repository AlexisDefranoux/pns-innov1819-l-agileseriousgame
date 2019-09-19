import 'acceptation_criteria_class.dart';

///Class which represents a user story for the Birdie Birdie game
class UserStory {
  String _title;
  int _iteration;
  String _specification;
  int _score;
  int _id;
  List<AcceptationCriteria> _criterias;

  UserStory(this._title, this._specification, this._score, this._criterias,
      this._id, this._iteration);

  String get title => _title;

  String get specification => _specification;

  int get score => _score;

  int get id => _id;

  int get iteration => _iteration;

  /// Getter for the criteria contents
  List<String> get criteria {
    List<String> contents = new List<String>();
    _criterias.forEach((c) => contents.add(c.content));
    return contents;
  }

  @override
  int get hashCode => _id.hashCode ^ _title.hashCode;

  @override
  bool operator ==(other) => other is UserStory && other._id == _id;
}
