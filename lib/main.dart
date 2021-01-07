import 'package:TaiwanGoGo/ViewCard.dart';
import 'package:TaiwanGoGo/homeBody.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
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
  dynamic _user = _auth.getCurrentUser();

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
    // if(this._user != null) {
    //   return Home(flush: flushPage,);
    // }
    // else {
    //   return Login(flush: flushPage,);
    // }
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
                    Alert(
                      context: context,
                      title: "登入成功",
                      type: AlertType.success,
                    ).show();
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
                      backgroundImage: NetworkImage(
                          "https://avatars3.githubusercontent.com/u/40608845?s=460&v=4"),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '未登入的遊客',
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
                _auth.signOut().then(flush);
              },
            ),
          ],
        ),
      ),
      body: HomeBody(),
    );
  }
}
