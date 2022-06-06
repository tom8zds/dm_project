import 'package:animations/animations.dart';
import 'package:dmapicore/views/comic/comic_home.dart';
import 'package:dmapicore/views/setting/setting_page.dart';
import 'package:flutter/material.dart';

class HomePageView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageViewState();
}

class HomePageViewState extends State<HomePageView> {
  int index = 0;
  int preIndex = 0;

  final pageList = [
    ComicHomeView(),
    const SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 500),
        reverse: index < preIndex,
        transitionBuilder: (Widget child, Animation<double> primaryAnimation,
            Animation<double> secondaryAnimation) {
          return SharedAxisTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            child: child,
          );
        },
        child: pageList[index],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected: (value) {
          setState(() {
            preIndex = index;
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
