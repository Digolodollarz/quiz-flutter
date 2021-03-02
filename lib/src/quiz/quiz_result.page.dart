part of 'quiz.dart';

class QuizResultPage extends StatefulWidget {
  final String quizPath;

  const QuizResultPage({Key key, this.quizPath}) : super(key: key);

  @override
  _QuizResultPageState createState() => _QuizResultPageState();
}

class _QuizResultPageState extends State<QuizResultPage> {
  Future<Quiz> _quiz;

  String result = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _quiz = Provider.of<QuizController>(context, listen: false)
        .fetchQuiz(widget.quizPath)
        .first
        .then((value) {
      value.correct = 0;
      value.questions.forEach((question) {
        question.correct = question.answers
            .any((element) => element.correct && element.selected);
        if (question.correct) value.correct++;
      });
      return value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(title: Text('Your results')),
      body: FutureBuilder<Quiz>(
        future: _quiz,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          if (!snapshot.hasData) return Text('No Data');
          final quiz = snapshot.data;
          final int percentPass =
              (quiz.correct / quiz.questions.length * 100).toInt();
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 16),
                    color: percentPass >= 92
                        ? Colors.green
                        : percentPass >= 88
                            ? Colors.amber
                            : Colors.red,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 180,
                            height: 180,
                            child: Stack(
                              children: <Widget>[
                                charts.PieChart(
                                  chartResult(quiz.correct,
                                      quiz.questions.length - quiz.correct),
                                  animate: true,
                                  animationDuration:
                                      Duration(milliseconds: 1500),
                                  defaultRenderer: charts.ArcRendererConfig(
                                    arcWidth: 12,
                                    startAngle: 4 / 5 * 3.14,
                                    // arcLength: quiz.correct / quiz.questions.length * 1.4 * 3.14,
                                    arcLength: 7 / 5 * 3.14,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "${(quiz.correct / quiz.total * 100).toInt()} %",
                                    style: TextStyle(
                                        fontSize: 30.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (percentPass > 88)
                                Text(
                                  'PASS',
                                  style: Theme.of(context).textTheme.headline3,
                                )
                              else if (percentPass > 80)
                                Text('RETRY')
                              else
                                Text(
                                  'FAIL',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              Text('${quiz.correct} Correct answers'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: quiz.questions.length,
                    itemBuilder: (context, position) =>
                        _buildListItem(quiz.questions[position]),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  //TODO: Work on the performance of this listview
  Widget _buildListItem(Question question) {
    return Card(
      elevation: 0.2,
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.title,
              style: Theme.of(context).textTheme.headline6.copyWith(
                    fontFamily: 'TitilliumWeb',
                  ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: question.answers.length,
              itemBuilder: (context, position) {
                final option = question.answers[position];
                return Card(
                  elevation: 0.5,
                  clipBehavior: Clip.antiAlias,
                  margin: EdgeInsets.symmetric(vertical: 4),
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      border: (option.selected && !option.correct)
                          ? Border.all(color: Colors.red)
                          : (option.correct)
                              ? Border.all(color: Colors.green)
                              : null,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: !option.selected
                                ? Colors.black12
                                : option.correct
                                    ? Colors.green
                                    : Colors.red,
                            border: Border.all(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            option.option,
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              option.title,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        ),
                        if (option.selected)
                          Icon(
                            (option.correct ? Icons.check : Icons.clear),
                            color: option.correct ? Colors.green : Colors.red,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
            if (!question.correct) Text(question.description ?? 'Seriously?'),
          ],
        ),
      ),
    );
  }
}

List<charts.Series<LinearData, int>> chartResult(int correct, int wrong) {
  final data = [
    new LinearData(
        'Correct', correct, charts.ColorUtil.fromDartColor(Colors.white)),
    new LinearData(
        'Wrong', wrong, charts.ColorUtil.fromDartColor(Colors.white12)),
  ];

  return [
    new charts.Series<LinearData, int>(
      id: 'Results',
      domainFn: (LinearData sales, _) => sales.count,
      measureFn: (LinearData sales, _) => sales.count,
      data: data,
      colorFn: (LinearData data, _) => data.color,
    )
  ];
}

/// Sample linear data type.
class LinearData {
  final String name;
  final int count;
  final charts.Color color;

  LinearData(this.name, this.count, this.color);
}
