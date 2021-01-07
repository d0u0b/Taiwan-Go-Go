import 'package:TaiwanGoGo/View.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:TaiwanGoGo/api_service.dart';

class Post {
  final String title;
  final String description;

  Post(this.title, this.description);
}

class SearchPage extends StatelessWidget {
  List<View> searchResult;
  Future<List<Post>> search(String search) async {
    searchResult = await fetchView(search: search);
    return List.generate(searchResult.length, (int index) {
      return Post(
        "景點 : ${searchResult[index].Name}",
        "描述 :${searchResult[index].Descript}",
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SearchBar<Post>(
            onSearch: search,
            onItemFound: (Post post, int index) {
              return ListTile(
                title: Text(post.title),
                subtitle: Text(post.description),
              );
            },
          ),
        ),
      ),
    );
  }
}
