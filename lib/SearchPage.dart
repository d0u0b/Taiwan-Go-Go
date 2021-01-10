import 'package:TaiwanGoGo/View.dart';
import 'package:TaiwanGoGo/ViewDetail.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:TaiwanGoGo/api_service.dart';

class SearchPage extends StatelessWidget {
  List<View> searchResult;
  Future<List<View>> search(String search) async {
    searchResult = await fetchView(search: search);
    return List.generate(searchResult.length, (int index) {
      return searchResult[index];
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SearchBar<View>(
            minimumChars: 2,
            onSearch: search,
            hintText: "搜尋景點或縣市",
            
            onItemFound: (View view, int index) {
              return Container(
                padding: EdgeInsets.only(top: 10),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewDetail(view)));
                  },
                  leading: Image.network(view.Picture1),
                  title: Text(view.Name),
                  subtitle: Text('${view.Region} ${view.Town}'),
                  
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
