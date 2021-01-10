import 'package:TaiwanGoGo/homeBody.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:TaiwanGoGo/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

final Auth _auth = Auth();

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User _user = _auth.getCurrentUser();

  void flushPage() {
    setState(() {
      while (!mounted) {}
      _user = _auth.getCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: this._user != null
            ? Home(
                flush: flushPage,
              )
            : Login(
                flush: flushPage,
              ));
  }
}

class Login extends StatelessWidget {
  dynamic flush;

  Login({this.flush}) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "登入",
              style: TextStyle(
                fontSize: 32,
              ),
            ),
            SignInButton(
              Buttons.Google,
              onPressed: () {
                _auth.signInWithGoogle().then((result) {
                  if (result != null) {
                    this.flush();
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Home extends StatelessWidget {
  dynamic flush;

  Home({this.flush}) : super();
  @override
  Widget build(BuildContext context) {
    User _user = _auth.getCurrentUser();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        toolbarHeight: 65,
        centerTitle: true,
        title: Text(
          "TAIWAN GO GO",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountEmail:
                  Text(''), // keep blank text because email is required
              accountName: Row(
                children: <Widget>[
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(_user.photoURL),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        _user.displayName,
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text(
                '我的帳戶',
                style: TextStyle(fontSize: 18),
              ),
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text(
                '景點討論區',
                style: TextStyle(fontSize: 18),
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(
                '登出',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                _auth.signOut().then((result) {
                  this.flush();
                });
              },
            ),
          ],
        ),
      ),
      body: HomeBody(),
    );
  }
}
