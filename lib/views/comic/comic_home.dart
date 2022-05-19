import 'dart:async';

import 'package:dmapicore/api/api.dart';
import 'package:dmapicore/api/api_models/comic/comic_home_model.dart';
import 'package:dmapicore/api/comic_api.dart';
import 'package:dmapicore/views/comic/comic_category.dart';
import 'package:dmapicore/views/comic/comic_rank.dart';
import 'package:dmapicore/views/widgets/error_widget.dart';
import 'package:dmapicore/views/widgets/home_view_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'comic_collection.dart';

class ComicHomeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ComicHomeViewState();
}

class ComicHomeViewState extends State<ComicHomeView> {
  List<RecommendList?> _list = List.filled(10, null);

  final StreamController pageStateController = StreamController<PageState>();
  final RefreshController refreshController = RefreshController();

  @override
  void initState() {
    getComicHomeData();
    super.initState();
  }

  @override
  void dispose() {
    pageStateController.close();
    refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: pageStateController.stream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapShot) {
          const double height = 4 * kToolbarHeight - 64;
          final double width = MediaQuery
              .of(context)
              .size
              .width > 21/9 * height ? 21/9 * height : MediaQuery
              .of(context)
              .size
              .width;
          if (snapShot.hasError) return errorPage(context, getComicHomeData);
          if (snapShot.hasData) {
            return Scaffold(
              appBar: AppBar(
                toolbarHeight: kToolbarHeight,
                title: const Text("漫画"),
                centerTitle: true,
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search),
                  ),
                ],
              ),
              body: SmartRefresher(
                onRefresh: getComicHomeData,
                controller: refreshController,
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: RecommendListWidget(
                        list: _list[0],
                        itemHeight: height,
                        itemWidth: width,
                        state: snapShot.data,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        padding: const EdgeInsets.all(8),
                        height: kToolbarHeight,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Theme
                              .of(context)
                              .colorScheme
                              .surfaceVariant,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: TextButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const ComicCategoryView()),
                                  );
                                },
                                icon: const Icon(Icons.category),
                                label: const Text('分类'),
                              ),
                            ),
                            Expanded(
                              child: TextButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ComicRankView()),
                                  );
                                },
                                icon: const Icon(Icons.bar_chart),
                                label: const Text('排行'),
                              ),
                            ),
                            Expanded(
                              child: TextButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ComicCollectionView()),
                                  );
                                },
                                icon: const Icon(Icons.collections),
                                label: const Text('专题'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate([
                        //近期必看
                        RecommendListWidget(
                          title: _list[1]?.title,
                          list: _list[1],
                          itemHeight: width / 3 / 3 * 4,
                          itemWidth: width / 3,
                          trailing: Icon(Icons.arrow_forward, color: Theme.of(context).colorScheme.primary,),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('onTap')));
                          },
                          state: snapShot.data,
                          hasListTile: true,
                          margin: 4,
                        ),
                        //专题
                        RecommendListWidget(
                          title: _list[2]?.title,
                          list: _list[2],
                          itemHeight: height,
                          itemWidth: width,
                          trailing: const Icon(Icons.arrow_forward),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ComicCollectionView()),
                            );
                          },
                          state: snapShot.data,
                          hasListTile: true,
                        ),

                        //热门
                        RecommendListWidget(
                          title: _list[7]?.title,
                          list: _list[7],
                          itemHeight: height,
                          itemWidth: height * 0.75,
                          trailing: const Icon(Icons.refresh),
                          onTap: () {},
                          state: snapShot.data,
                          hasListTile: true,
                        ),
                      ]),
                    )
                  ],
                ),
              ),
            );
          }
          return const Scaffold();
        });
  }

  Future getComicHomeData() async {
    try {
      pageStateController.add(PageState.loading);

      _list = await ComicApi.instance.getHomeList();
      //删除游戏广告
      _list[0]!.data!.removeWhere((element) => element.type == 10);
      refreshController.refreshCompleted();
      pageStateController.add(PageState.done);
    } catch (e) {
      print(e);
      pageStateController.addError(e);
      refreshController.refreshFailed();
      pageStateController.add(PageState.fail);
    }
  }
}
