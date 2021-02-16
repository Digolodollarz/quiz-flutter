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
    );
  }
}
