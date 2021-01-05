import 'dart:async';

import 'package:TaiwanGoGo/View.dart';
import 'package:TaiwanGoGo/api_service.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

Future<List<View>> futureViewList = fetchView();
bool futureDone = false;

class Album extends StatefulWidget {
  @override
  _AlbumState createState() => _AlbumState();
}

class _AlbumState extends State<Album> {
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
      padding: EdgeInsets.only(top: 10, left: 1, right: 1),
      child: FutureBuilder<List<View>>(
        future: futureViewList,
        builder: (context, snapshot) {
          // print(snapshot.hasData);
          if (snapshot.hasData) {
            // print(snapshot.data);

            return GridView.builder(
              itemCount: snapshot.data.length,
              padding: EdgeInsets.all(2),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 2, mainAxisSpacing: 3),
              itemBuilder: (context, index) {
                if (snapshot.data[index].Picture1 == '') {
                  snapshot.data[index].Picture1 =
                      'https://www.energy-bagua.com/topic/wp-content/uploads/sites/8/2020/10/no-image.png';
                }

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

                return Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Image.network(
                      snapshot.data[index].Picture1,
                      fit: BoxFit.cover,
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        color: Colors.black38,
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              fit: FlexFit.tight,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(snapshot.data[index].Name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16)),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          '${snapshot.data[index].Region} ${snapshot.data[index].Town}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12)),
                                      LikeButton(
                                        onTap: onLikeButtonTapped,
                                        likeBuilder: (bool isLiked) {
                                          return Icon(
                                            Icons.favorite,
                                            color: isLiked
                                                ? Colors.pink
                                                : Colors.grey[400],
                                            size: 30,
                                          );
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              },
            );
          }
          return Center(
            child: Container(
              width: 250,
              height: 50,
              child: LiquidLinearProgressIndicator(
                value: percent / 100, // Defaults to 0.5.
                valueColor: AlwaysStoppedAnimation(Colors
                    .blue[200]), // Defaults to the current Theme's accentColor.
                backgroundColor: Colors
                    .white, // Defaults to the current Theme's backgroundColor.
                borderColor: Colors.blue[200],
                borderWidth: 5.0,
                direction: Axis
                    .horizontal, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
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
