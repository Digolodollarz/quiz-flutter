part of 'quiz.dart';

class QuizController with ChangeNotifier {
  final _db = FirebaseFirestore.instance;
  final uuid = FirebaseAuth.instance.currentUser.uid;

  bool loading = false;

  List<Quiz> historyData = [];

  QuizController() {
    this.fetchHistoric();
  }

  String get lastResult {
    return 'users/$uuid/quizzes/${this.historyData.last?.id}';
  }

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

      await Future.wait(quizQuestions.map((question) async {
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
        return;
      }));

      final now = DateTime.now().millisecondsSinceEpoch;
      _db.doc('users/$uuid/quizzes/$now').set(
        {
          'created': DateTime.now().toIso8601String(),
          'questions': quizQuestions.map((e) => e.toJson()).toList(),
        },
      );
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
    _db.doc(path).update(quiz.toMap());
    return;
  }

  fetchHistoric() async {
    final uuid = FirebaseAuth.instance.currentUser.uid;
    final historicSnapshots = _db
        .collection('users/$uuid/quizzes')
        .orderBy('id')
        .limit(10)
        .snapshots();
    historicSnapshots.listen((snap) {
      final data = snap.docs.map<Quiz>((e) {
        final quiz = Quiz.fromSnapshot(e);
        return quiz;
      });
      this.historyData = data.toList();
      this.notifyListeners();
    });
  }

  List<charts.Series<Quiz, String>> getHistoryGraph() {
    return [
      charts.Series<Quiz, String>(
          id: 'Previous results',
          data: this.historyData,
          domainFn: (quiz, _) => quiz.created.toString(),
          measureFn: (quiz, _) => quiz.correct * 4,
          colorFn: (quiz, _) =>
              ((quiz.correct ?? 0) / (quiz.total ?? 25)) > 0.88
                  ? charts.MaterialPalette.green.shadeDefault
                  : ((quiz.correct ?? 0) / (quiz.total ?? 25)) > 0.64
                      ? charts.MaterialPalette.yellow.shadeDefault
                      : charts.MaterialPalette.red.shadeDefault)
    ];
  }
}
