import 'package:flutter/material.dart';
import 'dart:developer';

// Amplify Flutter Packages
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

// Generated in previous step
import 'amplifyconfiguration.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amplify Kitchen Sink',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Amplify Kitchen Sink'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AuthUser _user;

  @override
  initState() {
    super.initState();
    _configureAmplify().then((_) {
      Amplify.Auth.getCurrentUser().then((user) {
        setState(() {
          _user = user;
        });
      }).catchError((error) {
        log((error as AuthException).message);
      });
    });
  }

  Future<void> _configureAmplify() async {
    // Add Amplify Plugins
    AmplifyAuthCognito authPlugin = AmplifyAuthCognito();
    Amplify.addPlugins([authPlugin]);

    // Once Plugins are added, configure Amplify
    // Note: Amplify can only be configured once.
    try {
      await Amplify.configure(amplifyconfig);
    } on AmplifyAlreadyConfiguredException {
      log("Tried to reconfigure Amplify; this can occur when your app restarts on Android.");
    }
  }

  void _onLoginPressed() async {
    try {
      await Amplify.Auth.signInWithWebUI();
      AuthUser authUser = await Amplify.Auth.getCurrentUser();

      setState(() {
        _user = authUser;
      });
    } on AuthException catch (e) {
      log(e.message);
    }
  }

  void _onLogoutPressed() async {
    try {
      await Amplify.Auth.signOut();
      setState(() {
        _user = null;
      });
    } on AuthException catch (e) {
      log(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_user != null ? _user.username : ""),
            new MaterialButton(
                child: _user != null ? Text("Sign Out") : Text("Sign In"),
                onPressed: _user != null ? _onLogoutPressed : _onLoginPressed),
          ],
        ),
      ),
    );
  }
}
