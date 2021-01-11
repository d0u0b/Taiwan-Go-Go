import 'package:TaiwanGoGo/ViewDetail.dart';
import 'package:TaiwanGoGo/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
// import 'package:TaiwanGoGo/api_service.dart';

class SearchPage extends StatelessWidget {
  Future<List<DocumentSnapshot>> search(String search) async {
    return await Post.search(search);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SearchBar<DocumentSnapshot>(
            minimumChars: 2,
            onSearch: search,
            hintText: "搜尋景點或縣市",
            onItemFound: (DocumentSnapshot snapshot, int index) {
              Post post = Post(snapshot);
              return Container(
                padding: EdgeInsets.only(top: 10),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostDetail(
                          post,
                        ),
                      ),
                    );
                  },
                  leading: Image.network(post.picture1),
                  title: Text(post.name),
                  subtitle: Text('${post.region} ${post.town}'),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
