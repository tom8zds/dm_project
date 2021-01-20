import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dm_project/Api/api.dart';
import 'package:dm_project/Api/api_models/comic/comic_category_api.dart';
import 'package:dm_project/views/widgets/error_widget.dart';
import 'package:dm_project/views/widgets/utils_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:shimmer/shimmer.dart';

class ComicCategoryView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ComicCategoryViewState();
}

class ComicCategoryViewState extends State<ComicCategoryView> {
  List<ComicCategoryItem> _dataList;
  List<ComicCategoryFilter> _filterList;
  List<int> typeId = [0, 0, 0, 0];

  final StreamController pageStateController = StreamController<PageState>();

  @override
  void initState() {
    getComicCategoryFilter();
    getComicCategoryData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('分类')),
      body: StreamBuilder(
        stream: pageStateController.stream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return errorPage(context, getComicCategoryData);
          }
          if (snapshot.hasData) {
            double itemWidth = MediaQuery.of(context).size.width / 3;
            double itemHeight = itemWidth / 3 * 4;
            double margin = 8.0;
            return EasyRefresh.custom(
                header: getClassicalHeader(),
                onRefresh: getComicCategoryData,
                slivers: [
                  SliverGrid(
                    delegate: SliverChildBuilderDelegate((context, i) {
                      return coverButton(
                          itemHeight,
                          itemWidth,
                          margin,
                          context,
                          snapshot.data,
                          _dataList[i].title,
                          _dataList[i].authors,
                          _dataList[i].cover,
                          () {});
                    }, childCount: _dataList == null ? 9 : _dataList.length),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.75, crossAxisCount: 3),
                  )
                ]);
          }
          return Container();
        },
      ),
      // bottomNavigationBar: Row(
      //   children: bottomBar(),
      // ),
    );
  }

  // List<Widget> bottomBar() {
  //   List<Widget> bar = [];
  //   for (var i = 0; i < _filterList.length; i++) {
  //     bar.add(Expanded(
  //       child: FlatButton(
  //         height: kBottomNavigationBarHeight,
  //         child: Text(_filterList[i].title),
  //         onPressed: () {
  //           showModalBottomSheet(
  //             context: context,
  //             builder: (context) => Wrap(
  //               children: _filterList[i].items.map<Widget>((e) {
  //                 var flag = false;
  //                 if (e.tagId == typeId.elementAt(i)) flag = true;
  //                 return createTagItem(e.tagName, e.tagId, updateTag, flag, i);
  //               }).toList(),
  //             ),
  //           );
  //         },
  //       ),
  //     ));
  //   }
  //   return bar;
  // }

  void updateTag(int type, int tagId) {
    print('$type, $tagId');
    typeId[type] = tagId;
    getComicCategoryData();
  }

  Future getComicCategoryData() async {
    try {
      pageStateController.add(PageState.loading);
      var api = Api.comicCatagory(typeId.map((e) => e.toString()).toList());

      Response response = await Dio()
          .get(api, options: Options(responseType: ResponseType.plain));

      if (response.statusCode == 200) {
        _dataList = comicCategoryItemFromMap(response.data);
        pageStateController.add(PageState.done);
      } else {
        pageStateController.addError('statusCode:${response.statusCode}');
        pageStateController.add(PageState.fail);
      }
    } catch (e) {
      print(e);
      pageStateController.addError(e);
      pageStateController.add(PageState.fail);
    }
  }

  Future getComicCategoryFilter() async {
    try {
      var api = Api.comicCatagoryFilter;
      print(api);
      Response response = await Dio()
          .get(api, options: Options(responseType: ResponseType.plain));

      print(json.decode(response.data));
      await Future.delayed(Duration(seconds: 5));

      if (response.statusCode == 200) {
        _filterList = comicCategoryFilterFromMap(response.data);
        pageStateController.add(PageState.done);
      } else {
        throw HttpException('statusCode: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }
}
