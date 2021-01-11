import 'dart:async';

import 'package:TaiwanGoGo/Album.dart';
import 'package:TaiwanGoGo/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

Future<List<DocumentSnapshot>> post = Post.getLike();
RefreshController _refreshController = RefreshController(initialRefresh: true);

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  void initState() {
    super.initState();
  }

  void _onRefresh() async {
    post = Post.getLike();
    if (mounted) setState(() {});
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: post,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SmartRefresher(
            enablePullDown: true,
            enablePullUp: false,
            controller: _refreshController,
            header: WaterDropMaterialHeader(),
            onRefresh: _onRefresh,
            child: GridView.builder(
              itemCount: snapshot.data.length,
              padding: EdgeInsets.all(2),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 2, mainAxisSpacing: 3),
              itemBuilder: (context, index) {
                return Album(
                  post: Post(snapshot.data[index]),
                );
              },
            ),
          );
        } else {
          return Center(
            child: ProgressBar(),
          );
        }
      },
    );
  }
}

class ProgressBar extends StatefulWidget {
  @override
  _ProgressBarState createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  int percent = 0;
  Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 25), (_) {
      if (mounted) {
        setState(() {
          percent += 1;
        });
      }
      if (percent >= 100) {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 50,
      child: LiquidLinearProgressIndicator(
        value: percent / 100,
        valueColor: AlwaysStoppedAnimation(Colors.blue[200]),
        backgroundColor: Colors.white,
        borderColor: Colors.blue[200],
        borderWidth: 5.0,
        direction: Axis.horizontal,
        center: Text(
          percent.toString() + "%",
          style: TextStyle(fontSize: 20, color: Colors.blue[900]),
        ),
      ),
    );
  }
}
