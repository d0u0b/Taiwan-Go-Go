import 'dart:async';

import 'package:TaiwanGoGo/FavoritePage.dart';
import 'package:TaiwanGoGo/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:TaiwanGoGo/viewcard.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

final MyStream _post = Post.getStream();

Future<List<QueryDocumentSnapshot>> loading = _post.getData();

RefreshController _refreshController = RefreshController(initialRefresh: false);

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _onRefresh() async {
    _post.refresh();
    if (profile == null) profile = await Profile.getProfile();
    await _post.getData();
    if (mounted) setState(() {});
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    if (await _post.getData() == []) {
      return _refreshController.loadNoData();
    }
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loading,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              controller: _refreshController,
              header: WaterDropMaterialHeader(),
              footer: CustomFooter(
                builder: (BuildContext context, LoadStatus mode) {
                  Widget body;
                  if (mode == LoadStatus.idle) {
                    body = Text("pull up load");
                  } else if (mode == LoadStatus.loading) {
                    body = CupertinoActivityIndicator();
                  } else if (mode == LoadStatus.failed) {
                    body = Text("Load Failed!Click retry!");
                  } else if (mode == LoadStatus.canLoading) {
                    body = Text("release to load more");
                  } else {
                    body = Text("No more Data");
                  }
                  return Container(
                    height: 55.0,
                    child: Center(child: body),
                  );
                },
              ),
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: ListView.builder(
                itemBuilder: (content, index) =>
                    ViewCard(post: Post(_post.documents[index])),
                itemCount: _post.documents.length,
              ),
            );
          } else {
            return Center(
              child: ProgressBar(),
            );
          }
        });
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
    timer = Timer.periodic(Duration(microseconds: 650), (_) {
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
      width: 200,
      height: 200,
      child: LiquidCircularProgressIndicator(
        value: percent / 100, // Defaults to 0.5.
        valueColor: AlwaysStoppedAnimation(
            Colors.blue[200]), // Defaults to the current Theme's accentColor.
        backgroundColor:
            Colors.white, // Defaults to the current Theme's backgroundColor.
        borderColor: Colors.blue[200],
        borderWidth: 5.0,
        direction: Axis.vertical,
        center: Text(
          percent.toString() + "%",
          style: TextStyle(fontSize: 20, color: Colors.blue[900]),
        ),
      ),
    );
  }
}

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int percent = 0;

//   @override
//   void initState() {
//     super.initState();
//     if (!futureDone) {
//       Timer timer;
//       timer = Timer.periodic(Duration(milliseconds: 25), (_) {
//         // print('Percent Update');
//         setState(() {
//           percent += 1;
//         });
//         if (percent >= 100 || futureDone) {
//           timer.cancel();
//           // percent=0;
//         }
//       });
//       futureViewList.then((value) {
//         futureDone = true;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(10),
//       child: FutureBuilder<List<View>>(
//         future: futureViewList,
//         builder: (context, snapshot) {
//           // print(snapshot.hasData);
//           if (snapshot.hasData) {
//             // print(snapshot.data);
//             return ListView.builder(
//                 itemCount: snapshot.data.length,
//                 itemBuilder: (context, index) {
//                   Future<bool> onLikeButtonTapped(bool isLiked) async {
//                     // print(isLiked);
//                     final snackBar = new SnackBar(
//                         duration: Duration(seconds: 2),
//                         content: new Text(isLiked
//                             ? '已將 ${snapshot.data[index].Name} 從收藏中移除：（'
//                             : '已將 ${snapshot.data[index].Name} 加到收藏中：）'));
//                     Scaffold.of(context).showSnackBar(snackBar);

//                     return !isLiked;
//                   }

//                   return Card(
//                     margin: EdgeInsets.only(top: 15),
//                     borderOnForeground: true,
//                     shadowColor: Colors.black,
//                     clipBehavior: Clip.antiAlias,
//                     child: Column(
//                       children: [
//                         ListTile(
//                           leading: Icon(
//                             Icons.location_on,
//                             color: Colors.blue,
//                             size: 30,
//                           ),
//                           title: Text(
//                             snapshot.data[index].Name,
//                             style: TextStyle(fontSize: 18),
//                           ),
//                           subtitle: Text(
//                             '${snapshot.data[index].Region} ${snapshot.data[index].Town}',
//                             style: TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.black.withOpacity(0.6)),
//                           ),
//                         ),
//                         Image.network(snapshot.data[index].Picture1),
//                         Padding(
//                           padding: const EdgeInsets.all(10),
//                           child: Text(
//                             '${snapshot.data[index].Descript}',
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 3,
//                             style: TextStyle(
//                               color: Colors.blueGrey[700],
//                               fontSize: 16,
//                               letterSpacing: 1.02,
//                             ),
//                           ),
//                         ),

//                         ButtonBar(
//                           alignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             new Wrap(spacing: 2, children: <Widget>[
//                               Chip(
//                                 label: Text(
//                                   snapshot.data[index].ClassTypeText1,
//                                   style: TextStyle(
//                                       color: Colors.blue[900], fontSize: 12),
//                                 ),
//                                 backgroundColor: Colors.blue[50],
//                               ),
//                             ]),
//                             Wrap(
//                               children: [
//                                 LikeButton(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   padding: EdgeInsets.all(10),
//                                   size: 26,
//                                   onTap: onLikeButtonTapped,
//                                   likeBuilder: (bool isLiked) {
//                                     return Icon(
//                                       Icons.favorite,
//                                       color:
//                                           isLiked ? Colors.pink : Colors.grey,
//                                       size: 26,
//                                     );
//                                   },
//                                   likeCount: snapshot.data[index].Zipcode,
//                                   countBuilder:
//                                       (int count, bool isLiked, String text) {
//                                     var color =
//                                         isLiked ? Colors.pink : Colors.grey;
//                                     Widget result;
//                                     if (count == 0) {
//                                       result = Text(
//                                         "love",
//                                         style: TextStyle(color: color),
//                                       );
//                                     } else
//                                       result = Text(
//                                         text,
//                                         style: TextStyle(color: color),
//                                       );
//                                     return result;
//                                   },
//                                 ),
//                                 FlatButton(
//                                     textColor: Colors.blueGrey,
//                                     onPressed: () {
//                                       Share.share(
//                                           "嘿，我從【Taiwan GO GO】發現了想跟你分享的好地方：${snapshot.data[index].Name}！ ${snapshot.data[index].Descript}");
//                                       // print("分享");
//                                     },
//                                     child: Icon(Icons.share)),
//                                 FlatButton(
//                                   textColor: Colors.blue,
//                                   onPressed: () {
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) => ViewDetail(
//                                                 snapshot.data[index])));
//                                   },
//                                   child: Icon(Icons.open_in_new, size: 26),
//                                 )
//                               ],
//                             )
//                           ],
//                         ),
//                       ],
//                     ),
//                   );
//                 });
//           }
//           return Center(
//             child: Container(
//               width: 200,
//               height: 200,
//               child: LiquidCircularProgressIndicator(
//                 value: percent / 100, // Defaults to 0.5.
//                 valueColor: AlwaysStoppedAnimation(Colors
//                     .blue[200]), // Defaults to the current Theme's accentColor.
//                 backgroundColor: Colors
//                     .white, // Defaults to the current Theme's backgroundColor.
//                 borderColor: Colors.blue[200],
//                 borderWidth: 5.0,
//                 direction: Axis
//                     .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
//                 center: Text(
//                   percent.toString() + "%",
//                   style: TextStyle(fontSize: 20, color: Colors.blue[900]),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
