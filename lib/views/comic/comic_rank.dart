import 'dart:async';
import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:dmapicore/api/api.dart';
import 'package:dmapicore/api/api_models/comic/comic_tag_model.dart';
import 'package:dmapicore/api/api_models/protobuf/comic/rank_list_response.pb.dart';
import 'package:dmapicore/api/comic_api.dart';
import 'package:dmapicore/views/widgets/error_widget.dart';
import 'package:dmapicore/views/widgets/utils_widgets.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ComicRankView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ComicRankViewState();
}

class ComicRankViewState extends State<ComicRankView> {
  List<ComicRankListItemResponse>? _dataList;
  late List<FilterTag> _tagList;

  late FilterTag typeTag;
  int? timeRange = 0;
  int? orderType = 0;
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
                physics: const BouncingScrollPhysics(),
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
                      preferredSize: const Size.fromHeight(kTextTabBarHeight),
                      child: Row(children: [
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
                                          .subtitle1!
                                          .fontSize,
                                      color: Theme.of(context).accentColor),
                                  onChanged: (dynamic value) {
                                    setState(() {
                                      timeRange = value;
                                      refreshController.requestRefresh();
                                    });
                                  },
                                  value: timeRange,
                                  items: [
                                    const DropdownMenuItem(
                                      value: 0,
                                      child: Text('日'),
                                    ),
                                    const DropdownMenuItem(
                                      value: 1,
                                      child: Text('周'),
                                    ),
                                    const DropdownMenuItem(
                                      value: 2,
                                      child: Text('月'),
                                    ),
                                    const DropdownMenuItem(
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
                                          .subtitle1!
                                          .fontSize,
                                      color: Theme.of(context).accentColor),
                                  onChanged: (dynamic value) {
                                    setState(() {
                                      orderType = value;
                                      refreshController.requestRefresh();
                                    });
                                  },
                                  value: orderType,
                                  items: [
                                    const DropdownMenuItem(
                                      value: 0,
                                      child: Text('人气'),
                                    ),
                                    const DropdownMenuItem(
                                      value: 1,
                                      child: Text('吐槽'),
                                    ),
                                    const DropdownMenuItem(
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
                        var item = _dataList?.elementAt(i);
                        return coverButtonExtend(
                          context,
                          snapshot.data,
                          () {},
                          title: item?.title,
                          authors: item?.authors,
                          cover: item?.cover,
                          types: item?.types,
                          updateTime: DateUtil.formatDate(
                              DateTime.fromMillisecondsSinceEpoch(
                                  item!.lastUpdatetime.toInt() * 1000),
                              format: "yyyy-MM-dd"),
                          updateChapter: item.lastUpdateChapterName,
                          margin: margin,
                          itemHeight: itemHeight,
                          order: i + 1,
                        );
                      },
                      childCount:
                          _dataList == null ? shimmerCount : _dataList!.length,
                    ),
                    itemExtent: 4 * kToolbarHeight,
                  )
                ]),
              ),
            );
          }
          return const LinearProgressIndicator();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.search),
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

      if (isRefresh) _dataList = [];
      List<ComicRankListItemResponse> temp = await ComicApi.instance
          .getRankList(
              tagId: typeTag.tagId,
              byTime: timeRange,
              rankType: orderType,
              page: page);
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

  Future getComicRankFilter() async {
    try {
      var api = Api.comicRankFilter();
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
