import 'package:TaiwanGoGo/ViewDetail.dart';
import 'package:TaiwanGoGo/firestore.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:share/share.dart';

class ViewCard extends StatefulWidget {
  final Post post;
  ViewCard({this.post}) : super();
  @override
  ViewCardState createState() => ViewCardState();
}

class ViewCardState extends State<ViewCard> {

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    if(isLiked) {
      widget.post.like -= 1;
      profile.dislike(widget.post.id, widget.post.like);

    } else {
      widget.post.like += 1;
      profile.like(widget.post.id, widget.post.like);
    }
    final snackBar = new SnackBar(
        duration: Duration(seconds: 2),
        content: new Text(isLiked
            ? '已將 ${widget.post.name} 從收藏中移除：（'
            : '已將 ${widget.post.name} 加到收藏中：）'));
    Scaffold.of(context).showSnackBar(snackBar);

    return !isLiked;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(top: 15, bottom: 15),
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
              widget.post.name,
              style: TextStyle(fontSize: 18),
            ),
            subtitle: Text(
              '${widget.post.region} ${widget.post.town}',
              style:
                  TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.6)),
            ),
          ),
          Image.network(widget.post.picture1),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              '${widget.post.descript}',
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
                    widget.post.classTypeText1,
                    style: TextStyle(color: Colors.blue[900], fontSize: 12),
                  ),
                  backgroundColor: Colors.blue[50],
                ),
              ]),
              Wrap(
                children: [
                  LikeButton(
                    isLiked: profile.likes.lookup(widget.post.id) != null,
                    mainAxisAlignment: MainAxisAlignment.center,
                    padding: EdgeInsets.all(10),
                    size: 26,
                    onTap: onLikeButtonTapped,
                    likeBuilder: (bool isLiked) {
                      return Icon(
                        Icons.favorite,
                        color: isLiked ? Colors.pink : Colors.grey,
                        size: 26,
                      );
                    },
                    likeCount: widget.post.like,
                    countBuilder: (int count, bool isLiked, String text) {
                      var color = isLiked ? Colors.pink : Colors.grey;
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
                            "嘿，我從【Taiwan GO GO】發現了想跟你分享的好地方：${widget.post.name}！ ${widget.post.descript}");
                      },
                      child: Icon(Icons.share)),
                  FlatButton(
                    textColor: Colors.blue,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PostDetail(widget.post)));
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
  }
}