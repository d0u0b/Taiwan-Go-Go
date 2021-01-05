import 'package:getflutter/getflutter.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

List list = ["觀光工廠", "自行車道", ""];

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GFSearchBar(
        searchList: list,
        searchQueryBuilder: (query, list) {
          return list
              .where((item) => item.toLowerCase().contains(query.toLowerCase()))
              .toList();
        },
        overlaySearchListItemBuilder: (item) {
          return Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              "$item",
              style: const TextStyle(fontSize: 18),
            ),
          );
        },
        onItemSelected: (item) {
          setState(() {
            // print('$item');
          });
        },
      ),
    );
  }
}
