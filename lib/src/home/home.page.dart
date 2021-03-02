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
      body: Container(
        child: Column(
          children: [
            Visibility(
              child: LinearProgressIndicator(),
              visible: Provider.of<QuizController>(context).loading,
            ),
            RaisedButton(
              onPressed: () => random(context),
              child: Text('Take quick quiz'),
            ),
            RaisedButton(
              onPressed: () => result(context),
              child: Text('Open last result'),
            ),
            RaisedButton(
              onPressed: open,
              child: Text('Manage Stuff'),
            ),
          ],
        ),
      ),
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

  result(context) async {
    final quizUrl = await Provider.of<QuizController>(context, listen: false)
        .generateQuiz();
    // final quizUrl = 'users/tester/quizzes/2021-03-02T11:22:40.392107';
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
