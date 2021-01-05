import 'dart:convert';
import 'package:TaiwanGoGo/View.dart';
import 'package:http/http.dart' as http;

Future<List<View>> fetchView() async {
  final response = await http.get(
      'https://gis.taiwan.net.tw/XMLReleaseALL_public/scenic_spot_C_f.json');

  // print('response gotten');
  if (response.statusCode == 200) {
    // print('result gotten');

    // print(utf8.decode(response.bodyBytes));
    var res = jsonDecode(utf8.decode(response.bodyBytes));

    List<View> views = List<View>();
    List<dynamic> viewsInJson = res['XML_Head']['Infos']['Info'];
    viewsInJson.forEach((view) {
      // print(view['Name']);
      views.add(View.fromJson(view));
    });
    
    // print(views);
    return views;
  } else {
    // print('status code:${response.statusCode}');
    throw Exception('Failed to load data');
  }
}