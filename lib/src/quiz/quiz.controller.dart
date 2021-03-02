part of 'quiz.dart';

class QuizController with ChangeNotifier {
  final _db = FirebaseFirestore.instance;
  final uuid = FirebaseAuth.instance.currentUser.uid;

  bool loading = false;

  generateQuiz() async {
    this.loading = true;
    this.notifyListeners();
    try {
      final questions = await _db.collection('questions').get();
      final _lQs = questions.docs
          .map<Question>((e) => Question.fromSnapshot(e))
          .toList();
      _lQs.shuffle();
      final quizQuestions = _lQs.take(25);
      for (var question in quizQuestions) {
        List<Option> options =
            await _db.collection('questions/${question.id}/options').get().then(
                  (snap) => snap.docs
                      .map<Option>(
                        (e) => Option.fromSnapshot(e),
                      )
                      .toList(),
                );
        options.shuffle();
        for (int i = 0; i < options.length; i++)
          options[i].option = ['A', 'B', 'C', 'D'][i];
        question.answers = options;

        print(question);
        options.forEach(print);
      }

      final now = DateTime.now().millisecondsSinceEpoch;
      //final quiz = await
      _db.doc('users/$uuid/quizzes/$now').set({'created': now});

      // await Future.wait(quizQuestions.map((e) {
      //   return _db.doc('users/tester/quizzes/$now/questions/${e.id}').set(e.toJson());
      // }));
      _db
          .doc('users/$uuid/quizzes/$now')
          .set({'questions': quizQuestions.map((e) => e.toJson()).toList()});
      return 'users/$uuid/quizzes/$now';
    } catch (e) {
      print(e);
      throw e;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Stream<Quiz> fetchQuiz(String path) {
    final quizRef = _db.doc(path);

    return quizRef.snapshots().map((event) => Quiz.fromSnapshot(event));
  }

  save(Quiz quiz, String path) async {
    print("About to now");

    quiz.total = quiz.questions.length;
    quiz.correct = 0;
    quiz.questions.forEach((question) {
      if (question.answers.any((o) => o.selected)) {
        question.correct = question.answers
            .firstWhere((element) => element.selected == true)
            .correct;
        if (question.correct) quiz.correct++;
      } else {
        question.correct = false;
        quiz.completed = false;
      }
    });

    await _db.doc(path).update(quiz.toMap());
    print('Saved');
    return;
  }
}
