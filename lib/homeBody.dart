import 'package:TaiwanGoGo/Album.dart';
import 'package:TaiwanGoGo/FAQPage.dart';
import 'package:animate_do/animate_do.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'SearchPage.dart';
import 'FavoritePage.dart';

class HomeBody extends StatefulWidget {
  HomeBody({Key key}) : super(key: key);

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

/// This is the private State class that goes with HomeBody.
class _HomeBodyState extends State<HomeBody> {
  int _currentIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            SlideInDown(
              child: HomePage(),
            ),
            SlideInDown(
              child: Album(),
            ),
            SlideInDown(
              child: SearchPage(),
            ),
            SlideInDown(
              child: FavoritePage(),
            ),
            SlideInDown(
              child: FAQPage(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              title: Text('首頁'),
              icon: Icon(Icons.home),
              activeColor: Colors.blueAccent[100],
              inactiveColor: Colors.blue[200],
              textAlign: TextAlign.center),
          BottomNavyBarItem(
              title: Text('相簿'),
              icon: Icon(Icons.photo_album),
              activeColor: Colors.blueAccent[100],
              inactiveColor: Colors.blue[200],
              textAlign: TextAlign.center),
          BottomNavyBarItem(
              title: Text('搜尋景點'),
              icon: Icon(Icons.search),
              activeColor: Colors.blueAccent[100],
              inactiveColor: Colors.blue[200],
              textAlign: TextAlign.center),
          BottomNavyBarItem(
              title: Text('收藏景點'),
              icon: Icon(Icons.favorite),
              activeColor: Colors.blueAccent[100],
              inactiveColor: Colors.blue[200],
              textAlign: TextAlign.center),
          BottomNavyBarItem(
              title: Text('意見回饋'),
              icon: Icon(Icons.feedback),
              activeColor: Colors.blueAccent[100],
              inactiveColor: Colors.blue[200],
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
