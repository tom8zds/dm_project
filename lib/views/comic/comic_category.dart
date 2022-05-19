import 'dart:async';
import 'dart:io';

import 'package:dmapicore/api/api.dart';
import 'package:dmapicore/api/api_models/comic/comic_category_model.dart';
import 'package:dmapicore/api/api_models/comic/comic_tag_model.dart';
import 'package:dmapicore/api/comic_api.dart';
import 'package:dmapicore/views/widgets/error_widget.dart';
import 'package:dmapicore/views/widgets/utils_widgets.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ComicCategoryView extends StatefulWidget {
  final int orderType;
  final int showType;

  const ComicCategoryView({Key? key, this.orderType = 0, this.showType = 0})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => ComicCategoryViewState();
}

class ComicCategoryViewState extends State<ComicCategoryView> {
  List<ComicCategoryDetailItem>? _dataList;
  late List<ComicCategoryFilter> _filterList;
  List<FilterTag?> tagList = List.filled(4, null);
  int page = 0;
  int? orderType;
  int? showType; //0: grid, 1:list

  final StreamController pageStateController = StreamController<PageState>();
  final RefreshController refreshController = RefreshController();

  @override
  void initState() {
    orderType = widget.orderType;
    showType = widget.showType;
    getComicCategoryFilter();
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 4,
        automaticallyImplyLeading: false,
        title: Text(
          '分类',
          style: Theme.of(context).textTheme.headline5,
        ),
        actions: [
          Center(
            child: Text(
              '排序:',
              style: Theme.of(context).textTheme.caption,
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                orderType = (orderType! + 1) % 2;
                refreshController.requestRefresh();
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: AnimatedCrossFade(
                  firstChild: Text(
                    '人气排行',
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                  secondChild: Text('最近更新',
                      style: TextStyle(color: Theme.of(context).accentColor)),
                  crossFadeState: orderType == 0
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: Duration(milliseconds: 300),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                showType = (showType! + 1) % 2;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: AnimatedCrossFade(
                  firstChild: Icon(
                    Icons.grid_view,
                    color: Theme.of(context).accentColor,
                  ),
                  secondChild: Icon(
                    Icons.list,
                    color: Theme.of(context).accentColor,
                  ),
                  crossFadeState: showType == 0
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: Duration(milliseconds: 300),
                ),
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: pageStateController.stream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return errorPage(context, getComicCategoryData);
          }
          if (snapshot.hasData) {
            int oneLineCount =
                (MediaQuery.of(context).size.width / 3 / kToolbarHeight)
                    .round();
            double itemWidth =
                MediaQuery.of(context).size.shortestSide / oneLineCount;
            double itemHeight = itemWidth / 0.75;
            double margin = 8.0;
            int shimmerCount = 6;
            if (showType == 1) {
              double listItemHeight = 3 * kToolbarHeight;
              shimmerCount =
                  MediaQuery.of(context).size.height ~/ listItemHeight;
            }
            return SafeArea(
              child: SmartRefresher(
                physics: BouncingScrollPhysics(),
                enablePullUp: true,
                onRefresh: getComicCategoryData,
                onLoading: _dataList != null ? onLoad : null,
                controller: refreshController,
                child: CustomScrollView(slivers: [
                  showType == 0
                      ? SliverGrid(
                          delegate: SliverChildBuilderDelegate((context, i) {
                            return coverButton(
                                itemHeight,
                                itemWidth,
                                margin,
                                context,
                                snapshot.data,
                                _dataList?.elementAt(i).title,
                                _dataList?.elementAt(i).authors,
                                _dataList?.elementAt(i).cover,
                                () {});
                          },
                              childCount: _dataList == null
                                  ? 3 * oneLineCount
                                  : _dataList!.length),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 0.75,
                                  crossAxisCount: oneLineCount),
                        )
                      : SliverFixedExtentList(
                          delegate: SliverChildBuilderDelegate(
                            (context, i) {
                              return coverButtonExtend(
                                context,
                                snapshot.data,
                                () {},
                                title: _dataList![i].title,
                                authors: _dataList![i].authors,
                                cover: _dataList![i].cover,
                                types: _dataList![i].types,
                                margin: margin,
                                itemHeight: 3 * kToolbarHeight,
                              );
                            },
                            childCount: _dataList == null
                                ? shimmerCount
                                : _dataList!.length,
                          ),
                          itemExtent: 3 * kToolbarHeight,
                        ),
                ]),
              ),
            );
          }
          return LinearProgressIndicator();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.search),
      ),
    );
  }

//Text("${_filterList[i].title}:\n${tagList[i].tagName}")
  Future onLoad() async {
    await getComicCategoryData(isRefresh: false);
  }

  Future getComicCategoryData({isRefresh = true}) async {
    try {
      if (isRefresh) {
        page = 0;
        refreshController.resetNoData();
      }

      if (page == 0) {
        pageStateController.add(PageState.loading);
      }

      var api = Api.comicCategory();

      List<ComicCategoryDetailItem> temp =
          await ComicApi.instance.getCategoryDetail();

      if (isRefresh) _dataList = [];
      if (temp.isEmpty && !isRefresh) {
        refreshController.loadNoData();
        return;
      }
      _dataList!.addAll(temp);
      page += 1;
      pageStateController.add(PageState.done);
      if (isRefresh) {
        refreshController.refreshCompleted();
      } else {
        refreshController.loadComplete();
      }
    } catch (e) {
      print(e);
      pageStateController.addError(e);
      pageStateController.add(PageState.fail);
      if (isRefresh) {
        refreshController.refreshFailed();
      } else {
        refreshController.loadFailed();
      }
    }
  }

  Future getComicCategoryFilter() async {
    try {
      _filterList = await ComicApi.instance.getCategoryFilterList();
      for (var i = 0; i < _filterList.length; i++) {
        tagList[i] = _filterList[i].items![0];
      }
      getComicCategoryData();
    } catch (e) {
      print(e);
    }
  }
}
