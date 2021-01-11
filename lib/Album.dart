import 'dart:async';

import 'package:TaiwanGoGo/ViewDetail.dart';
import 'package:TaiwanGoGo/firestore.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

class Album extends StatefulWidget {
  final Post post;

  Album({this.post}) : super();

  @override
  _AlbumState createState() => _AlbumState();
}

class _AlbumState extends State<Album> {
  Future<bool> onLikeButtonTapped(bool isLiked) async {
    // print(isLiked);
    if (isLiked) {
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
    return InkWell(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetail(
              widget.post,
            ),
          ),
        ),
      },
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.network(
            widget.post.picture1,
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
                        Text(widget.post.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${widget.post.region} ${widget.post.town}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12)),
                            LikeButton(
                              isLiked:
                                  profile.likes.lookup(widget.post.id) != null,
                              onTap: onLikeButtonTapped,
                              likeBuilder: (bool isLiked) {
                                return Icon(
                                  Icons.favorite,
                                  color:
                                      isLiked ? Colors.pink : Colors.grey[400],
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
      ),
    );
  }
}
