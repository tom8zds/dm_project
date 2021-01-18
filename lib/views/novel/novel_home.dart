import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NovelHomeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NovelHomeViewState();
}

class NovelHomeViewState extends State<NovelHomeView> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Container(
            height: kToolbarHeight - 16,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.white, Colors.grey],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey, blurRadius: 4, offset: Offset(4, 4))
                ]),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: CircleAvatar(),
            )
          ],
        ),
        SliverToBoxAdapter(
          child: Container(
            height: 3 * kToolbarHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 3 * kToolbarHeight,
                    width: 5 * kToolbarHeight,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.white, Colors.grey],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey,
                              blurRadius: 4,
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
                    '小说',
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
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(colors: [
                      Colors.white,
                      Colors.grey,
                    ], begin: Alignment.centerLeft, end: Alignment.centerRight),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 8,
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
            );
          }, childCount: 6),
          itemExtent: 4 * kToolbarHeight,
        )
      ],
    );
  }
}
