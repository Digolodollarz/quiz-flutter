// GENERATED CODE - DO NOT MODIFY BY HAND

part of quiz;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Quiz _$QuizFromJson(Map<String, dynamic> json) {
  return Quiz(
    id: json['id'] as String,
    created: json['created'] == null
        ? null
        : DateTime.parse(json['created'] as String),
    updated: json['updated'] == null
        ? null
        : DateTime.parse(json['updated'] as String),
    questions: (json['questions'] as List)
        ?.map((e) =>
            e == null ? null : Question.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    completed: json['completed'] as bool,
    correct: json['correct'] as int,
    total: json['total'] as int,
  );
}

Map<String, dynamic> _$QuizToJson(Quiz instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('created', instance.created?.toIso8601String());
  writeNotNull('updated', instance.updated?.toIso8601String());
  writeNotNull(
      'questions', instance.questions?.map((e) => e?.toJson())?.toList());
  writeNotNull('completed', instance.completed);
  writeNotNull('correct', instance.correct);
  writeNotNull('total', instance.total);
  return val;
}

Question _$QuestionFromJson(Map<String, dynamic> json) {
  return Question(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    image: json['image'] as String,
    localImagePath: json['localImagePath'] as String,
    created: json['created'] == null
        ? null
        : DateTime.parse(json['created'] as String),
    updated: json['updated'] == null
        ? null
        : DateTime.parse(json['updated'] as String),
    answers: (json['answers'] as List)
        ?.map((e) =>
            e == null ? null : Option.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    correct: json['correct'] as bool,
  );
}

Map<String, dynamic> _$QuestionToJson(Question instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('title', instance.title);
  writeNotNull('description', instance.description);
  writeNotNull('image', instance.image);
  writeNotNull('localImagePath', instance.localImagePath);
  writeNotNull('created', instance.created?.toIso8601String());
  writeNotNull('updated', instance.updated?.toIso8601String());
  writeNotNull('answers', instance.answers?.map((e) => e?.toJson())?.toList());
  writeNotNull('correct', instance.correct);
  return val;
}

Option _$OptionFromJson(Map<String, dynamic> json) {
  return Option(
    id: json['id'] as String,
    ref: json['ref'],
    title: json['title'] as String,
    description: json['description'] as String,
    imageUrl: json['imageUrl'] as String,
    created: json['created'] == null
        ? null
        : DateTime.parse(json['created'] as String),
    updated: json['updated'] == null
        ? null
        : DateTime.parse(json['updated'] as String),
    localImagePath: json['localImagePath'] as String,
    selected: json['selected'] as bool,
    cancelled: json['cancelled'] as bool,
    correct: json['correct'] as bool,
    option: json['option'] as String,
  );
}

Map<String, dynamic> _$OptionToJson(Option instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('ref', instance.ref);
  writeNotNull('title', instance.title);
  writeNotNull('description', instance.description);
  writeNotNull('imageUrl', instance.imageUrl);
  writeNotNull('localImagePath', instance.localImagePath);
  writeNotNull('created', instance.created?.toIso8601String());
  writeNotNull('updated', instance.updated?.toIso8601String());
  writeNotNull('correct', instance.correct);
  writeNotNull('selected', instance.selected);
  writeNotNull('cancelled', instance.cancelled);
  writeNotNull('option', instance.option);
  return val;
}
