import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz/src/auth/auth.dart';
import 'package:quiz/src/quiz/quiz.dart';
import 'package:quiz/src/theme.dart';

import 'src/home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthController>(
          create: (_) => AuthController(FirebaseAuth.instance),
        ),
        ChangeNotifierProvider(create: (_) => QuizController()),
      ],
      child: MaterialApp(
        title: 'Flutter Quiz App',
        theme: getAppTheme(),
        home: Builder(
          builder: (context) => StreamBuilder<User>(
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data.uid != null)
                return HomePage();
              return AuthPage();
            },
            stream: Provider.of<AuthController>(context).authState,
          ),
        ),
      ),
    );
  }
}
