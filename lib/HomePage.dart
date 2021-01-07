import 'dart:async';
import 'dart:math';

import 'package:TaiwanGoGo/ViewDetail.dart';
import 'package:flutter/material.dart';
import 'package:TaiwanGoGo/View.dart';
import 'package:TaiwanGoGo/api_service.dart';
import 'package:like_button/like_button.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:share/share.dart';
import 'ViewDetail.dart';

Future<List<View>> futureViewList = fetchView();
bool futureDone = false;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int percent = 0;

  @override
  void initState() {
    super.initState();
    if (!futureDone) {
      Timer timer;
      timer = Timer.periodic(Duration(milliseconds: 25), (_) {
        // print('Percent Update');
        setState(() {
          percent += 1;
        });
        if (percent >= 100 || futureDone) {
          timer.cancel();
          // percent=0;
        }
      });
      futureViewList.then((value) {
        futureDone = true;
      }); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: FutureBuilder<List<View>>(
        future: futureViewList,
        builder: (context, snapshot) {
          // print(snapshot.hasData);
          if (snapshot.hasData) {
            // print(snapshot.data);
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  Future<bool> onLikeButtonTapped(bool isLiked) async {
                    // print(isLiked);
                    final snackBar = new SnackBar(
                        duration: Duration(seconds: 2),
                        content: new Text(isLiked
                            ? '已將 ${snapshot.data[index].Name} 從收藏中移除：（'
                            : '已將 ${snapshot.data[index].Name} 加到收藏中：）'));
                    Scaffold.of(context).showSnackBar(snackBar);

                    return !isLiked;
                  }

                  return Card(
                    margin: EdgeInsets.only(top: 15),
                    borderOnForeground: true,
                    shadowColor: Colors.black,
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.location_on,
                            color: Colors.blue,
                            size: 30,
                          ),
                          title: Text(
                            snapshot.data[index].Name,
                            style: TextStyle(fontSize: 18),
                          ),
                          subtitle: Text(
                            '${snapshot.data[index].Region} ${snapshot.data[index].Town}',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black.withOpacity(0.6)),
                          ),
                        ),
                        Image.network(snapshot.data[index].Picture1),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            '${snapshot.data[index].Descript}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: TextStyle(
                              color: Colors.blueGrey[700],
                              fontSize: 16,
                              letterSpacing: 1.02,
                            ),
                          ),
                        ),
                        
                        ButtonBar(
                          alignment: MainAxisAlignment.spaceBetween,
                          children: [
                            new Wrap(spacing: 2, children: <Widget>[
                              Chip(
                                label: Text(
                                  snapshot.data[index].ClassTypeText1,
                                  style: TextStyle(
                                      color: Colors.blue[900], fontSize: 12),
                                ),
                                backgroundColor: Colors.blue[50],
                              ),
                            ]),
                            Wrap(
                              children: [
                                LikeButton(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  padding: EdgeInsets.all(10),
                                  size: 26,
                                  onTap: onLikeButtonTapped,
                                  likeBuilder: (bool isLiked) {
                                    return Icon(
                                      Icons.favorite,
                                      color:
                                          isLiked ? Colors.pink : Colors.grey,
                                      size: 26,
                                    );
                                  },
                                  likeCount: snapshot.data[index].Zipcode,
                                  countBuilder:
                                      (int count, bool isLiked, String text) {
                                    var color =
                                        isLiked ? Colors.pink : Colors.grey;
                                    Widget result;
                                    if (count == 0) {
                                      result = Text(
                                        "love",
                                        style: TextStyle(color: color),
                                      );
                                    } else
                                      result = Text(
                                        text,
                                        style: TextStyle(color: color),
                                      );
                                    return result;
                                  },
                                ),
                                FlatButton(
                                    textColor: Colors.blueGrey,
                                    onPressed: () {
                                      Share.share(
                                          "嘿，我從【Taiwan GO GO】發現了想跟你分享的好地方：${snapshot.data[index].Name}！ ${snapshot.data[index].Descript}");
                                      // print("分享");
                                    },
                                    child: Icon(Icons.share)),
                                FlatButton(
                                  textColor: Colors.blue,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ViewDetail(
                                                snapshot.data[index])));
                                  },
                                  child: Icon(Icons.open_in_new, size: 26),
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                });
          }
          return Center(
            child: Container(
              width: 200,
              height: 200,
              child: LiquidCircularProgressIndicator(
                value: percent / 100, // Defaults to 0.5.
                valueColor: AlwaysStoppedAnimation(Colors
                    .blue[200]), // Defaults to the current Theme's accentColor.
                backgroundColor: Colors
                    .white, // Defaults to the current Theme's backgroundColor.
                borderColor: Colors.blue[200],
                borderWidth: 5.0,
                direction: Axis
                    .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                center: Text(
                  percent.toString() + "%",
                  style: TextStyle(fontSize: 20, color: Colors.blue[900]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
