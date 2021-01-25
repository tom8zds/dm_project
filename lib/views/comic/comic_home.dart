import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dm_project/Api/api.dart';
import 'package:dm_project/Api/api_models/comic/comic_home_model.dart';
import 'package:dm_project/views/comic/comic_category.dart';
import 'package:dm_project/views/comic/comic_rank.dart';
import 'package:dm_project/views/search_view.dart';
import 'package:dm_project/views/widgets/error_widget.dart';
import 'package:dm_project/views/widgets/home_view_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ComicHomeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ComicHomeViewState();
}

class ComicHomeViewState extends State<ComicHomeView> {
  List<RecommendList> _list = List.filled(9, null);

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
        builder: (context, snapShot) {
          final double height = 4 * kToolbarHeight - 16;
          if (snapShot.hasError) return errorPage(context, getComicHomeData);
          if (snapShot.hasData)
            return SafeArea(
              child: SmartRefresher(
                onRefresh: getComicHomeData,
                controller: refreshController,
                child: CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      floating: true,
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      toolbarHeight: kToolbarHeight,
                      title: Container(
                        height: kToolbarHeight - 8,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 2,
                              )
                            ]),
                        child: Container(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                              IconButton(
                                  icon: Icon(
                                    Icons.search,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {}),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    showSearch(
                                        context: context,
                                        delegate: SearchBarDelegate());
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: CircleAvatar(
                                  child: Icon(Icons.perm_identity),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: RecommendListWidget(
                        list: _list[0],
                        itemHeight: 3 * kToolbarHeight,
                        itemWidth: 16 / 3 * kToolbarHeight,
                        state: snapShot.data,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        height: kToolbarHeight,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  '漫画',
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                              ),
                            ),
                            ButtonBar(
                              children: [
                                TextButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ComicCategoryView()),
                                      );
                                    },
                                    icon: Icon(Icons.category),
                                    label: Text('分类')),
                                TextButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ComicRankView()),
                                      );
                                    },
                                    icon: Icon(Icons.bar_chart),
                                    label: Text('排行')),
                                TextButton.icon(
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
                      delegate: SliverChildListDelegate([
                        //近期必看
                        RecommendListWidget(
                          title: _list[1]?.title,
                          list: _list[1],
                          itemHeight: height,
                          itemWidth: height * 0.75,
                          trailing: Icon(Icons.arrow_forward),
                          onTap: () {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text('onTap')));
                          },
                          state: snapShot.data,
                          hasListTile: true,
                        ),
                        //专题
                        RecommendListWidget(
                          title: _list[3]?.title,
                          list: _list[3],
                          itemHeight: height,
                          itemWidth: height / 9 * 16,
                          trailing: Icon(Icons.arrow_forward),
                          onTap: () {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text('onTap')));
                          },
                          state: snapShot.data,
                          hasListTile: true,
                        ),
                        //大师作品
                        RecommendListWidget(
                          title: _list[4]?.title,
                          list: _list[4],
                          itemHeight: height,
                          itemWidth: height * 0.75,
                          trailing: Icon(Icons.arrow_forward),
                          onTap: () {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text('onTap')));
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
                          trailing: Icon(Icons.arrow_forward),
                          onTap: () {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text('onTap')));
                          },
                          state: snapShot.data,
                          hasListTile: true,
                        ),
                        //条漫
                        RecommendListWidget(
                          title: _list[8]?.title,
                          list: _list[8],
                          itemHeight: height,
                          itemWidth: height * 16 / 9,
                          trailing: Icon(Icons.arrow_forward),
                          onTap: () {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text('onTap')));
                          },
                          state: snapShot.data,
                          hasListTile: true,
                        ),
                        //国漫
                        RecommendListWidget(
                          title: _list[5]?.title,
                          list: _list[5],
                          itemHeight: height,
                          itemWidth: height * 0.75,
                          trailing: Icon(Icons.arrow_forward),
                          onTap: () {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text('onTap')));
                          },
                          state: snapShot.data,
                          hasListTile: true,
                        ),
                        //美漫
                        RecommendListWidget(
                          title: _list[6]?.title,
                          list: _list[6],
                          itemHeight: height,
                          itemWidth: height * 16 / 9,
                          trailing: Icon(Icons.arrow_forward),
                          onTap: () {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text('onTap')));
                          },
                          state: snapShot.data,
                          hasListTile: true,
                        ),
                      ]),
                      itemExtent: 5 * kToolbarHeight,
                    )
                  ],
                ),
              ),
            );
          return Scaffold();
        });
  }

  Future getComicHomeData() async {
    try {
      print(Api.comicHome);
      pageStateController.add(PageState.loading);
      Response response = await Dio().get(Api.comicHome,
          options: Options(responseType: ResponseType.plain));

      if (response.statusCode == 200) {
        _list = recommendListFromMap(response.data);
        refreshController.refreshCompleted();
        pageStateController.add(PageState.done);
      } else {
        pageStateController.addError('statusCode:${response.statusCode}');
        refreshController.refreshFailed();
        pageStateController.add(PageState.fail);
      }
    } catch (e) {
      print(e);
      pageStateController.addError(e);
      refreshController.refreshFailed();
      pageStateController.add(PageState.fail);
    }
  }
}
