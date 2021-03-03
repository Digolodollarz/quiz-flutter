part of 'home.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColor,
      child:
          Consumer<QuizController>(builder: (context, quizController, child) {
        return SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                child: Row(
                  children: [
                    Text(
                      'Learn to Drive',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 36,
                      ),
                    ),
                    Spacer(),
                    PopupMenuButton(
                      icon: Icon(
                        Icons.account_circle_outlined,
                        size: 36,
                        color: Colors.white,
                      ),
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
                            Provider.of<AuthController>(context, listen: false)
                                .signOut();
                        }
                      },
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Visibility(
                      child: LinearProgressIndicator(),
                      visible: quizController.loading,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      height: 226,
                      margin: EdgeInsets.symmetric(vertical: 16),
                      child: charts.BarChart(
                        quizController.getHistoryGraph(),
                        animate: true,
                        defaultRenderer: new charts.BarRendererConfig(
                            cornerStrategy:
                                const charts.ConstCornerStrategy(8)),
                        primaryMeasureAxis: charts.NumericAxisSpec(
                            renderSpec: charts.NoneRenderSpec()),
                        domainAxis: charts.OrdinalAxisSpec(
                            renderSpec: charts.NoneRenderSpec()),
                      ),
                    ),
                    InkWell(
                      onTap: () => random(context),
                      child: Container(
                        margin: EdgeInsets.only(top: 8, bottom: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.alarm,
                                size: 48,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Text(
                              'Take quick quiz',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => result(context, quizController.lastResult),
                      child: Container(
                        margin: EdgeInsets.only(top: 8, bottom: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.history,
                                size: 48,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Text(
                              'Open last result',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // RaisedButton(
                    //   onPressed: open,
                    //   child: Text('Manage Stuff'),
                    // ),
                  ],
                ),
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
