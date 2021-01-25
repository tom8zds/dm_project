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

  final StreamController pageStateController =
      StreamController<List<PageState>>();
  final RefreshController refreshController = RefreshController();
  final List<PageState> _stateList =
      List<PageState>.filled(4, PageState.loading);

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
                      title: Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: kToolbarHeight - 8,
                          padding: EdgeInsets.all(4),
                          child: InkWell(
                            onTap: () {
                              showSearch(
                                  context: context,
                                  delegate: SearchBarDelegate());
                            },
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
                                  child: Icon(Icons.perm_identity),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: RecommendListWidget(
                        list: _list[0],
                        itemHeight: 3 * kToolbarHeight,
                        itemWidth: 16 / 3 * kToolbarHeight,
                        state: snapShot.data[0],
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
                                  style: Theme.of(context).textTheme.headline5,
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
                          state: snapShot.data[0],
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
                          state: snapShot.data[0],
                          hasListTile: true,
                        ),
                        //大师作品
                        RecommendListWidget(
                          title: _list[4]?.title,
                          list: _list[4],
                          itemHeight: height,
                          itemWidth: height * 0.75,
                          state: snapShot.data[0],
                          hasListTile: true,
                        ),
                        //热门
                        RecommendListWidget(
                          title: _list[7]?.title,
                          list: _list[7],
                          itemHeight: height,
                          itemWidth: height * 0.75,
                          trailing: Icon(Icons.refresh),
                          onTap: () {
                            getBatchUpdate(_list[7].categoryId, 1, 7);
                          },
                          state: snapShot.data[1],
                          hasListTile: true,
                        ),
                        //条漫
                        RecommendListWidget(
                          title: _list[8]?.title,
                          list: _list[8],
                          itemHeight: height,
                          itemWidth: height * 16 / 9,
                          state: snapShot.data[0],
                          hasListTile: true,
                        ),
                        //国漫
                        RecommendListWidget(
                          title: _list[5]?.title,
                          list: _list[5],
                          itemHeight: height,
                          itemWidth: height * 0.75,
                          trailing: Icon(Icons.refresh),
                          onTap: () {
                            getBatchUpdate(_list[5].categoryId, 2, 5);
                          },
                          state: snapShot.data[2],
                          hasListTile: true,
                        ),
                        //美漫
                        RecommendListWidget(
                          title: _list[6]?.title,
                          list: _list[6],
                          itemHeight: height,
                          itemWidth: height * 16 / 9,
                          onTap: null,
                          state: snapShot.data[0],
                          hasListTile: true,
                        ),
                        //最新上架
                        RecommendListWidget(
                          title: _list[9]?.title,
                          list: _list[9],
                          itemHeight: height,
                          itemWidth: height * 0.75,
                          trailing: Icon(Icons.arrow_forward),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ComicCategoryView(
                                        orderType: 1,
                                        showType: 1,
                                      )),
                            );
                          },
                          state: snapShot.data[0],
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
      _stateList.fillRange(0, 3, PageState.loading);
      pageStateController.add(_stateList);
      Response response = await Dio().get(Api.comicHome,
          options: Options(responseType: ResponseType.plain));

      if (response.statusCode == 200) {
        _list = recommendListFromMap(response.data);
        //删除游戏广告
        _list[0].data.removeWhere((element) => element.type == 10);
        refreshController.refreshCompleted();
        _stateList.fillRange(0, 3, PageState.done);
        pageStateController.add(_stateList);
      } else {
        pageStateController.addError('statusCode:${response.statusCode}');
        refreshController.refreshFailed();
        _stateList.fillRange(0, 3, PageState.fail);
        pageStateController.add(_stateList);
      }
    } catch (e) {
      print(e);
      pageStateController.addError(e);
      refreshController.refreshFailed();
      _stateList.fillRange(0, 3, PageState.fail);
      pageStateController.add(_stateList);
    }
  }

  Future getBatchUpdate(int categoryId, int stateIndex, int listIndex) async {
    try {
      _stateList[stateIndex] = PageState.loading;
      pageStateController.add(_stateList);
      Response response = await Dio().get(Api.comicHot(categoryId),
          options: Options(responseType: ResponseType.plain));

      if (response.statusCode == 200) {
        _list[listIndex] = batchUpdateFromMap(response.data).data;
        _stateList[stateIndex] = PageState.done;
        pageStateController.add(_stateList);
      } else {
        pageStateController.addError('statusCode:${response.statusCode}');
        _stateList[stateIndex] = PageState.fail;
        pageStateController.add(_stateList);
      }
    } catch (e) {
      print(e);
      pageStateController.addError(e);
      _stateList[stateIndex] = PageState.fail;
      pageStateController.add(_stateList);
    }
  }
}
