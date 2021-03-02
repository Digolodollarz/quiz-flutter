part of 'quiz.dart';

class TakeQuizPage extends StatefulWidget {
  final String quiz;

  const TakeQuizPage({Key key, @required this.quiz}) : super(key: key);

  @override
  _TakeQuizPageState createState() => _TakeQuizPageState();
}

class _TakeQuizPageState extends State<TakeQuizPage> {
  Future<Quiz> _quiz;
  double _screenWidth;
  double _screenHeight;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _quiz = Provider.of<QuizController>(context, listen: false)
        .fetchQuiz(widget.quiz)
        .first;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.deepPurple,
      child: SafeArea(
        bottom: false,
        left: false,
        right: false,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: SingleChildScrollView(
            child: FutureBuilder<Quiz>(
                future: _quiz,
                builder: (context, snapshot) {
                  if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
                  if (!snapshot.hasData) return Text('No Data');
                  final quiz = snapshot.data;
                  return Column(
                    children: [
                      Row(
                        children: [
                          IconButton(icon: Icon(Icons.clear), onPressed: () {}),
                          Spacer(),
                          TimerWidget(
                            onDone: () async {
                              await _saveResult();
                              _openQuizResult();
                            },
                          ),
                          Spacer(),
                          FlatButton.icon(
                            icon: Icon(Icons.check_circle_outline),
                            onPressed: () async {
                              await _saveResult();
                              _openQuizResult();
                            },
                            label: Text('Done'),
                          ),
                        ],
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: quiz.questions.length,
                        itemBuilder: (context, position) =>
                            _buildListItem(quiz.questions[position]),
                      ),
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(Question question) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ' ${question.title}',
              style: Theme.of(context).textTheme.headline6.copyWith(
                    fontFamily: 'TitilliumWeb',
                  ),
            ),
            if (question.image != null)
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints.loose(
                    Size(
                      MediaQuery.of(context).size.shortestSide,
                      MediaQuery.of(context).size.shortestSide,
                    ),
                  ),
                  child: CachedNetworkImage(
                    fit: BoxFit.contain,
                    imageUrl: question.image,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            CircularProgressIndicator(
                                value: downloadProgress.progress),
                    errorWidget: (context, url, error) {
                      print(error);
                      return Icon(Icons.error);
                    },
                  ),
                ),
              ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: question.answers.length,
              itemBuilder: (context, position) {
                final option = question.answers[position];
                return InkWell(
                  onTap: () {
                    if (question.answers.any((element) => element.selected)) {
                      if (question.answers.any((element) => element.cancelled))
                        return;
                      setState(() {
                        final canceled = question.answers
                            .firstWhere((element) => element.selected);
                        canceled.cancelled = true;
                        canceled.selected = false;
                        option.selected = true;
                      });
                    } else
                      setState(() {
                        option.selected = true;
                      });
                  },
                  child: Card(
                    elevation: option.selected
                        ? 0
                        : option.cancelled
                            ? 1
                            : 2,
                    clipBehavior: Clip.antiAlias,
                    margin: EdgeInsets.symmetric(vertical: 4),
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: option.selected
                          ? BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(4))
                          : option.cancelled
                              ? BoxDecoration(
                                  border: Border.all(
                                      color: Theme.of(context).accentColor),
                                  borderRadius: BorderRadius.circular(4))
                              : null,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            decoration: BoxDecoration(
                              color: option.selected
                                  ? Theme.of(context).primaryColor
                                  : Colors.black12,
                              border: Border.all(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              option.option,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                option.title,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  _saveResult() async {
    Provider.of<QuizController>(context, listen: false)
        .save((await _quiz), widget.quiz);
    return;
  }

  _openQuizResult() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => QuizResultPage(quizPath: widget.quiz)));
  }
}

class TimerWidget extends StatefulWidget {
  final VoidCallback onDone;

  const TimerWidget({Key key, this.onDone}) : super(key: key);

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  int _start = 8;
  String current = '08:00';

  @override
  Widget build(BuildContext context) {
    return Text(
      current,
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: Theme.of(context).primaryTextTheme.bodyText1.color),
    );
  }

  CountdownTimer countDownTimer;
  StreamSubscription<CountdownTimer> sub;

  @override
  void initState() {
    super.initState();
    this.startTimer();

    countDownTimer = new CountdownTimer(
      new Duration(minutes: _start),
      new Duration(seconds: 1),
    );

    sub = countDownTimer.listen(null);
    sub.onData((time) {
      setState(() {
        String twoDigits(int n) => n.toString().padLeft(2, "0");
        String twoDigitMinutes =
        twoDigits(time.remaining.inMinutes.remainder(60));
        String twoDigitSeconds =
        twoDigits(time.remaining.inSeconds.remainder(60));
        current = '$twoDigitMinutes:$twoDigitSeconds';
      });
    });
    sub.onDone(widget.onDone);
  }

  void startTimer() {

  }

  @override
  void dispose() {
    if(sub != null){
      sub.cancel();
    }
    super.dispose();
  }
}
