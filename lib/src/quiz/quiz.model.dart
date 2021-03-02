part of 'quiz.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Quiz {
  String id;
  DateTime created;
  DateTime updated;

  List<Question> questions;
  bool completed;
  int correct;

  int total;

  Quiz({
    this.id,
    this.created,
    this.updated,
    this.questions,
    this.completed,
    this.correct,
    this.total,
  });

  factory Quiz.fromSnapshot(DocumentSnapshot snapshot) {
    final _quiz = _$QuizFromJson(snapshot.data())..id = snapshot.id;
    _quiz.id = snapshot.id;
    return _quiz;
    // return Quiz(
    //   id: snapshot.id,
    //   created: snapshot.data()["created"] != null
    //       ? DateTime.fromMillisecondsSinceEpoch(
    //           snapshot.data()["created"] as int)
    //       : null,
    //   updated: snapshot.data()["updated"] != null
    //       ? DateTime.fromMillisecondsSinceEpoch(
    //           snapshot.data()["updated"] as int)
    //       : null,
    //   completed:
    //       snapshot.data()["completed"] != null && snapshot.data()["completed"],
    // );
  }

  Map<String, dynamic> toMap() {
    final val = _$QuizToJson(this);
    val["updated"] = DateTime.now().toIso8601String();
    return val;
  }

  @override
  String toString() {
    return _$QuizToJson(this).toString();
  }
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Question {
  String id;
  String title;
  String description;
  String image;
  String localImagePath;
  DateTime created;
  DateTime updated;

  List<Option> answers;
  bool correct;

  Question({
    this.id,
    this.title,
    this.description,
    this.image,
    this.localImagePath,
    this.created,
    this.updated,
    this.answers,
    this.correct,
  }) {
    this.correct = correct ?? false;
  }

  factory Question.fromSnapshot(DocumentSnapshot snapshot) {
    final json = snapshot.data();
    return Question(
      id: snapshot.id,
      title: json["title"],
      description: json["description"],
      image: json["image"],
      created: json["created"] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              (json["created"] as Timestamp).millisecondsSinceEpoch)
          : null,
      updated: json["updated"] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              (json["updated"] as Timestamp).millisecondsSinceEpoch)
          : null,
    );
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    return _$QuestionFromJson(json);
  }

  Map<String, dynamic> toJson() => _$QuestionToJson(this);

  @override
  String toString() => 'Question: $title';
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Option {
  String id;
  dynamic ref;
  String title;
  String description;
  String imageUrl;
  String localImagePath;
  DateTime created;
  DateTime updated;

  bool correct;
  bool selected;
  bool cancelled;
  String option;

  Option({
    this.id,
    this.ref,
    this.title,
    this.description,
    this.imageUrl,
    this.created,
    this.updated,
    this.localImagePath,
    this.selected,
    this.cancelled,
    this.correct,
    this.option,
  }) {
    this.correct = correct ?? false;
    this.selected = selected ?? false;
    this.cancelled = cancelled ?? false;
  }

  factory Option.fromSnapshot(DocumentSnapshot snapshot) {
    final option = Option.fromJson(snapshot.data());
    option.id = snapshot.id;
    option.ref = snapshot.reference;
    return option;
    // return Option(
    //   id: snapshot.id,
    //   title: json["title"],
    //   description: json["description"],
    //   imageUrl: json["imageUrl"],
    //   created: json["created"] != null
    //       ? DateTime.fromMillisecondsSinceEpoch(
    //           (json["created"] as Timestamp).millisecondsSinceEpoch)
    //       : null,
    //   updated: json["updated"] != null
    //       ? DateTime.fromMillisecondsSinceEpoch(
    //           (json["updated"] as Timestamp).millisecondsSinceEpoch)
    //       : null,
    //   selected: json["selected"] != null && json["selected"] as bool,
    //   correct: json["correct"] != null && json["correct"] as bool,
    //   option: json["option"],
    // );
  }

  factory Option.fromJson(Map<String, dynamic> json) => _$OptionFromJson(json);

  Map<String, dynamic> toJson() => _$OptionToJson(this);

  // Map<String, dynamic> toJson() => {
  //       "id": id,
  //       "title": title,
  //       "description": description,
  //       "imageUrl": imageUrl,
  //       "created": this.created?.millisecondsSinceEpoch,
  //       "updated": this.updated?.millisecondsSinceEpoch,
  //       "localImagePath": localImagePath,
  //       "selected": selected,
  //       "correct": correct,
  //       "option": option,
  //     };

  @override
  String toString() {
    return '$option. $title';
  }
}
