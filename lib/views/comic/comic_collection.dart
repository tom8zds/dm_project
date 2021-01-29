import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dm_project/Api/api.dart';
import 'package:dm_project/Api/api_models/comic/comic_collection_model.dart';
import 'package:dm_project/views/comic/comic_collection_content.dart';
import 'package:dm_project/views/widgets/error_widget.dart';
import 'package:dm_project/views/widgets/utils_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ComicCollectionView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ComicCollectionViewState();
}

class ComicCollectionViewState extends State<ComicCollectionView> {
  List<ComicCollection> _dataList;
  int page = 0;

  final StreamController pageStateController = StreamController<PageState>();
  final RefreshController refreshController = RefreshController();

  @override
  void initState() {
    getComicCollectionData();
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
          '专题',
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
      body: StreamBuilder(
        stream: pageStateController.stream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return errorPage(context, getComicCollectionData);
          }
          if (snapshot.hasData) {
            double itemHeight = 3 * kToolbarHeight;
            double margin = 8.0;
            double itemWidth = itemHeight * 21 / 9;
            int shimmerCount = MediaQuery.of(context).size.height ~/ itemHeight;
            int oneLineCount = MediaQuery.of(context).size.width ~/ itemWidth;
            return SafeArea(
              child: SmartRefresher(
                physics: BouncingScrollPhysics(),
                enablePullUp: true,
                onRefresh: getComicCollectionData,
                onLoading: _dataList != null ? onLoad : null,
                controller: refreshController,
                child: CustomScrollView(slivers: [
                  SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        return coverButton(
                          itemHeight,
                          itemWidth,
                          margin,
                          context,
                          snapshot.data,
                          _dataList?.elementAt(i)?.shortTitle,
                          _dataList?.elementAt(i)?.title,
                          _dataList?.elementAt(i)?.smallCover,
                          () {
                            if (_dataList != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ComicCollectionContentView(
                                          title: _dataList[i].title,
                                          cover: _dataList[i].smallCover,
                                          id: _dataList[i].id,
                                        )),
                              );
                            }
                          },
                        );
                      },
                      childCount:
                          _dataList == null ? shimmerCount : _dataList.length,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 21 / 9, crossAxisCount: oneLineCount),
                  )
                ]),
              ),
            );
          }
          return LinearProgressIndicator();
        },
      ),
    );
  }

//Text("${_filterList[i].title}:\n${tagList[i].tagName}")
  Future onLoad() async {
    await getComicCollectionData(isRefresh: false);
  }

  Future getComicCollectionData({isRefresh = true}) async {
    try {
      if (isRefresh) {
        page = 0;
        refreshController.resetNoData();
        refreshController.loadComplete();
      }

      if (page == 0) {
        pageStateController.add(PageState.loading);
      }
      var api = Api.comicCollection(page);

      Response response = await Dio()
          .get(api, options: Options(responseType: ResponseType.plain));

      if (response.statusCode == 200) {
        if (isRefresh) _dataList = [];
        List<ComicCollection> temp = comicCollectionFromMap(response.data);
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
}
