import 'package:TaiwanGoGo/firestore.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:share/share.dart';

class PostDetail extends StatelessWidget {
  final Post post;
  PostDetail(this.post) : super();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[200],
          toolbarHeight: 65,
          // centerTitle: true,
          title: Text(
            post.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        body: ListView(
          children: [
            Card(
              borderOnForeground: true,
              shadowColor: Colors.black,
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  Image.network(post.picture1),
                  ListTile(
                    leading: Icon(
                      Icons.location_on,
                      color: Colors.blue,
                      size: 30,
                    ),
                    title: Text(
                      post.name,
                      style: TextStyle(fontSize: 16),
                    ),
                    subtitle: Text(
                      '${post.region} ${post.town}',
                      style: TextStyle(
                          fontSize: 14, color: Colors.black.withOpacity(0.6)),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.map,
                      color: Colors.blue,
                      size: 30,
                    ),
                    title: Text(
                      post.add,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.phone,
                      color: Colors.blue,
                      size: 30,
                    ),
                    title: Text(
                      post.tel,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.info,
                      color: Colors.blue,
                      size: 30,
                    ),
                    title: Text(
                      post.ticketinfo,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.web,
                      color: Colors.blue,
                      size: 30,
                    ),
                    title: Text(
                      post.website,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.class__rounded,
                      color: Colors.blue,
                      size: 30,
                    ),
                    title: Text(
                      post.classTypeText1,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 20, left: 10, right: 10, bottom: 20),
                    child: Text(
                      '${post.descript}',
                      style: TextStyle(
                        fontSize: 16,
                        letterSpacing: 1.05,
                        height: 1.5,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.blueGrey[100],
                    height: 20,
                    thickness: 2,
                    indent: 15,
                    endIndent: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          FlatButton(
                              textColor: Colors.grey,
                              onPressed: () {
                                
                              },
                              child: Column(
                                children: [
                                  LikeButton(size: 24),
                                  Text('Like'),
                                ],
                              )),
                        ],
                      ),
                      FlatButton(
                          textColor: Colors.grey,
                          onPressed: () {},
                          child: Column(
                            children: [
                              Icon(Icons.comment),
                              Text(
                                'Comment',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          )),
                      FlatButton(
                          textColor: Colors.grey,
                          onPressed: () {
                            Share.share(
                                "嘿，我從【Taiwan GO GO】發現了想跟你分享的好地方：${post.name}！ ${post.descript}");
                            // print("分享");
                          },
                          child: Column(
                            children: [
                              Icon(Icons.share),
                              Text(
                                'Share',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}