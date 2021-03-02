part of 'home.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: 'logout',
                  child: Text('Log Out'),
                )
              ];
            },
            onSelected: (String choice) {
              switch (choice) {
                case 'logout':
                  Provider.of<AuthController>(context, listen: false).signOut();
              }
            },
          ),
        ],
      ),
      body: Consumer<QuizController>(builder: (context, quizController, child) {
        return Container(
          child: Column(
            children: [
              Visibility(
                child: LinearProgressIndicator(),
                visible: quizController.loading,
              ),
              Container(
                height: 256,
                child: charts.BarChart(
                  quizController.getHistoryGraph(),
                  animate: true,
                  defaultRenderer: new charts.BarRendererConfig(
                      // By default, bar renderer will draw rounded bars with a constant
                      // radius of 100.
                      // To not have any rounded corners, use [NoCornerStrategy]
                      // To change the radius of the bars, use [ConstCornerStrategy]
                      cornerStrategy: const charts.ConstCornerStrategy(8)),
                ),
              ),
              RaisedButton(
                onPressed: () => random(context),
                child: Text('Take quick quiz'),
              ),
              RaisedButton(
                onPressed: () => result(context, quizController.lastResult),
                child: Text('Open last result'),
              ),
              RaisedButton(
                onPressed: open,
                child: Text('Manage Stuff'),
              ),
            ],
          ),
        );
      }),
    );
  }

  random(context) async {
    final quizUrl = await Provider.of<QuizController>(context, listen: false)
        .generateQuiz();
    // final quizUrl = 'users/tester/quizzes/2021-03-02T11:22:40.392107';
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TakeQuizPage(quiz: quizUrl),
        ));
  }

  result(BuildContext context, String quizUrl) async {
    print('Opening result');
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizResultPage(quizPath: quizUrl),
        ));
  }

  open() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SensorSetup()),
    );
  }
}
