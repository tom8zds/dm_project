import 'package:dm_project/views/comic/comic_home.dart';
import 'package:dm_project/views/novel/novel_home.dart';
import 'package:flutter/material.dart';

class HomePageView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageViewState();
}

class HomePageViewState extends State<HomePageView> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: index,
        children: [
          ComicHomeView(),
          NovelHomeView(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        currentIndex: index,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_album_outlined),
            label: '漫画',
            activeIcon: Icon(Icons.photo_album),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            label: '小说',
            activeIcon: Icon(Icons.article),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: '设置',
            activeIcon: Icon(Icons.settings),
          ),
        ],
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
      ),
    );
  }
}
