import 'package:dmapicore/views/comic/comic_home.dart';
import 'package:dmapicore/views/setting/setting_page.dart';
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
          SettingPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected: (value) {
          setState(() {
            index = value;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.photo_album_outlined),
            label: '漫画',
            selectedIcon: Icon(Icons.photo_album),
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            label: '设置',
            selectedIcon: Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}
