import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dm_project/Api/api.dart';
import 'package:dm_project/Api/api_models/comic/comic_rank_model.dart';
import 'package:dm_project/Api/api_models/comic/comic_tag_model.dart';
import 'package:dm_project/views/widgets/error_widget.dart';
import 'package:dm_project/views/widgets/utils_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ComicRankView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ComicRankViewState();
}

class ComicRankViewState extends State<ComicRankView> {
  List<ComicRankItem> _dataList;
  List<FilterTag> _tagList;

  FilterTag typeTag;
  int timeRange = 0;
  int orderType = 0;
  int page = 0;

  final StreamController pageStateController = StreamController<PageState>();
  final RefreshController refreshController = RefreshController();

  @override
  void initState() {
    getComicRankFilter();
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
          '排行榜',
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
      body: StreamBuilder(
        stream: pageStateController.stream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return errorPage(context, getComicRankData);
          }
          if (snapshot.hasData) {
            double itemHeight = 3 * kToolbarHeight;
            double margin = 8.0;
            int shimmerCount = MediaQuery.of(context).size.height ~/ itemHeight;
            return SafeArea(
              child: SmartRefresher(
                physics: BouncingScrollPhysics(),
                enablePullUp: true,
                onRefresh: getComicRankData,
                onLoading: _dataList != null ? onLoad : null,
                controller: refreshController,
                child: CustomScrollView(slivers: [
                  SliverAppBar(
                    floating: true,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    titleSpacing: 0,
                    title: PreferredSize(
                      preferredSize: Size.fromHeight(kTextTabBarHeight),
                      child: Row(children: [
                        orderType == 0
                            ? Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      showMaterialScrollPicker(
                                        showDivider: false,
                                        context: context,
                                        title: '分类',
                                        items: _tagList
                                            .map((e) => e.tagName)
                                            .toList(),
                                        confirmText: '确定',
                                        cancelText: '取消',
                                        selectedItem: typeTag.tagName,
                                        onChanged: (value) {
                                          typeTag = _tagList.firstWhere(
                                              (element) =>
                                                  element.tagName == value);
                                        },
                                        onConfirmed:
                                            refreshController.requestRefresh,
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          "分类:",
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text("${typeTag.tagName}",
                                              style: TextStyle(
                                                  fontSize: Theme.of(context)
                                                      .textTheme
                                                      .subtitle1
                                                      .fontSize,
                                                  color: Theme.of(context)
                                                      .accentColor)),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        Text(
                          "时间:",
                          style: Theme.of(context).textTheme.caption,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                  isExpanded: true,
                                  style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .fontSize,
                                      color: Theme.of(context).accentColor),
                                  onChanged: (value) {
                                    setState(() {
                                      timeRange = value;
                                      refreshController.requestRefresh();
                                    });
                                  },
                                  value: timeRange,
                                  items: [
                                    DropdownMenuItem(
                                      value: 0,
                                      child: Text('日'),
                                    ),
                                    DropdownMenuItem(
                                      value: 1,
                                      child: Text('周'),
                                    ),
                                    DropdownMenuItem(
                                      value: 2,
                                      child: Text('月'),
                                    ),
                                    DropdownMenuItem(
                                      value: 3,
                                      child: Text('总'),
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                        Text(
                          "排序:",
                          style: Theme.of(context).textTheme.caption,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                  isExpanded: true,
                                  style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .fontSize,
                                      color: Theme.of(context).accentColor),
                                  onChanged: (value) {
                                    setState(() {
                                      orderType = value;
                                      refreshController.requestRefresh();
                                    });
                                  },
                                  value: orderType,
                                  items: [
                                    DropdownMenuItem(
                                      value: 0,
                                      child: Text('人气'),
                                    ),
                                    DropdownMenuItem(
                                      value: 1,
                                      child: Text('吐槽'),
                                    ),
                                    DropdownMenuItem(
                                      value: 2,
                                      child: Text('订阅'),
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                  SliverFixedExtentList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        return coverButtonExtend(
                          context,
                          snapshot.data,
                          () {},
                          title: _dataList?.elementAt(i)?.title,
                          authors: _dataList?.elementAt(i)?.authors,
                          cover: _dataList?.elementAt(i)?.cover,
                          types: _dataList?.elementAt(i)?.types,
                          updateTime: _dataList?.elementAt(i)?.lastUpdatetime,
                          updateChapter:
                              _dataList?.elementAt(i)?.lastUpdateChapterName,
                          margin: margin,
                          itemHeight: itemHeight,
                          order: i + 1,
                        );
                      },
                      childCount:
                          _dataList == null ? shimmerCount : _dataList.length,
                    ),
                    itemExtent: 4 * kToolbarHeight,
                  )
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
    await getComicRankData(isRefresh: false);
  }

  Future getComicRankData({isRefresh = true}) async {
    try {
      if (isRefresh) {
        page = 0;
        refreshController.resetNoData();
      }

      if (page == 0) {
        pageStateController.add(PageState.loading);
      }
      var api = Api.comicRank(typeTag.tagId, timeRange, orderType, page);

      Response response = await Dio()
          .get(api, options: Options(responseType: ResponseType.plain));

      if (response.statusCode == 200) {
        if (isRefresh) _dataList = [];
        List<ComicRankItem> temp = comicRankItemFromMap(response.data);
        if (temp.isEmpty && !isRefresh) {
          refreshController.loadNoData();
          return;
        }
        _dataList.addAll(temp);
        page += 1;
        pageStateController.add(PageState.done);
      } else {
        pageStateController.addError('statusCode:${response.statusCode}');
        pageStateController.add(PageState.fail);
      }
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

  Future getComicRankFilter() async {
    try {
      var api = Api.comicRankFilter;
      Response response = await Dio()
          .get(api, options: Options(responseType: ResponseType.plain));

      if (response.statusCode == 200) {
        _tagList = filterTagFromMap(response.data);
        for (var i = 0; i < _tagList.length; i++) {
          typeTag = _tagList[0];
        }
        getComicRankData(isRefresh: true);
      } else {
        throw HttpException('statusCode: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }
}
