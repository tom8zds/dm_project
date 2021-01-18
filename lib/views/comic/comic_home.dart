import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ComicHomeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ComicHomeViewState();
}

class ComicHomeViewState extends State<ComicHomeView> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          toolbarHeight: kToolbarHeight + 16,
          title: Container(
            height: kToolbarHeight,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.white, Colors.grey[300]],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey, blurRadius: 4, offset: Offset(4, 4))
                ]),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Colors.blue,
                      ),
                      onPressed: () {}),
                  Expanded(
                    child: Container(),
                  ),
                  CircleAvatar(
                    child: Icon(Icons.account_circle_outlined),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            height: 3 * kToolbarHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 3 * kToolbarHeight,
                    width: 5 * kToolbarHeight,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.white, Colors.grey[300]],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey,
                              blurRadius: 12,
                              offset: Offset(4, 4))
                        ]),
                  ),
                );
              },
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            height: kToolbarHeight,
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '漫画',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                ButtonBar(
                  children: [
                    FlatButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.category),
                        label: Text('分类')),
                    FlatButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.bar_chart),
                        label: Text('排行')),
                    FlatButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.collections),
                        label: Text('专题')),
                  ],
                ),
              ],
            ),
          ),
        ),
        SliverFixedExtentList(
          delegate: SliverChildBuilderDelegate((context, i) {
            return InkWell(
              onTap: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('onTap')));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[300],
                          blurRadius: 12,
                        ),
                      ]),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('$i'),
                        trailing: Icon(Icons.arrow_forward),
                      )
                    ],
                  ),
                ),
              ),
            );
          }, childCount: 6),
          itemExtent: 4 * kToolbarHeight,
        )
      ],
    );
  }
}
