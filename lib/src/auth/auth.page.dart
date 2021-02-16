part of 'auth.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey();
  String error;
  bool isSignup = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isSignup ? 'Register' : 'Login'),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: QTextFormField(
                  controller: emailController,
                  hintText: 'Enter email',
                  labelText: 'Email',
                  validator: Validators.email,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: QTextFormField(
                  controller: passwordController,
                  hintText: 'Enter password',
                  labelText: 'Password',
                  validator: Validators.length,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                ),
              ),
              Visibility(
                visible: isSignup,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: QTextFormField(
                    controller: repeatPasswordController,
                    hintText: 'Enter password again',
                    labelText: 'Repeat Password',
                    validator: (val) =>
                        Validators.equality(passwordController.text, val),
                    keyboardType: TextInputType.text,
                    obscureText: true,
                  ),
                ),
              ),
              if (!isSignup)
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: FlatButton(
                        onPressed: flip,
                        child: Text('Sign Up'),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: RaisedButton(
                        onPressed: login,
                        child: Text('Log In'),
                      ),
                    ),
                  ],
                ),
              if (isSignup)
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: FlatButton(
                        onPressed: flip,
                        child: Text('Log in'),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: RaisedButton(
                        onPressed: signup,
                        child: Text('Sign Up'),
                      ),
                    ),
                  ],
                ),
              Spacer(),
              Row(
                children: [
                  Expanded(
                    child: RaisedButton(
                      onPressed: anon,
                      child: Text('Just take me to the app!'),
                    ),
                  ),
                ],
              ),
              if (error != null) Text(error),
            ],
          ),
        ),
      ),
    );
  }

  flip() {
    setState(() {
      isSignup = !isSignup;
    });
  }

  login() async {
    if (!formKey.currentState.validate()) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Lodhin\'i'),
        content: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
    try {
      await Provider.of<AuthController>(context, listen: false).signIn(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      error = e.message;
      print(e);
    } finally {
      Navigator.pop(context);
    }
  }

  signup() async {
    if (!formKey.currentState.validate()) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Lodhin\'i'),
        content: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
    try {
      await Provider.of<AuthController>(context, listen: false).signUp(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      error = e.message;
      print(e);
    } finally {
      Navigator.pop(context);
    }
  }

  anon() async {
    showDialog(
      context: context,
      builder: (_) => Center(child: CircularProgressIndicator()),
    );
    try {
      await Provider.of<AuthController>(context, listen: false).signInAnon();
    } on FirebaseAuthException catch (e) {
      print(e);
    } finally {
      Navigator.pop(context);
    }
  }
}

class QTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final Function validator;
  final TextInputType keyboardType;
  final bool obscureText;

  const QTextFormField({
    Key key,
    this.controller,
    this.hintText,
    this.labelText,
    this.validator,
    this.keyboardType,
    this.obscureText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
      ),
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText ?? false,
    );
  }
}

class Validators {
  static String email(String val) => val.contains('@') ? null : 'Invalid email';

  static String length(String val, [int length]) {
    return val != null && val.length >= (length ?? 6)
        ? null
        : 'Please enter at least ${(length ?? 6)}';
  }

  static String equality(dynamic val1, dynamic val2) =>
      val1 == val2 ? null : 'Values do not match';
}
