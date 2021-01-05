import 'package:TaiwanGoGo/ViewCard.dart';
import 'package:TaiwanGoGo/homeBody.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                accountEmail: Text(''), // keep blank text because email is required
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
            ],
          ),
        ),
        body: HomeBody(),
      ),
    );
  }
}

