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
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:shimmer/shimmer.dart';

class ComicCategoryView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ComicCategoryViewState();
}

class ComicCategoryViewState extends State<ComicCategoryView> {
  List<ComicCategoryItem> _dataList = [];
  List<ComicCategoryFilter> _filterList;
  List<FilterTag> tagList = List.filled(4, null);
  int page = 0;
  int orderType = 0;

  final StreamController pageStateController = StreamController<PageState>();

  @override
  void initState() {
    getComicCategoryFilter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            return SafeArea(
              child: EasyRefresh.custom(
                  header: getClassicalHeader(),
                  footer: MaterialFooter(),
                  onRefresh: getComicCategoryData,
                  onLoad: _dataList.isNotEmpty ? onLoad : null,
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      elevation: 4,
                      automaticallyImplyLeading: false,
                      title: Text(
                        '分类',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      bottom: PreferredSize(
                        preferredSize: Size.fromHeight(kTextTabBarHeight),
                        child: Row(
                          children: bottomBar(),
                        ),
                      ),
                    ),
                    SliverGrid(
                      delegate: SliverChildBuilderDelegate((context, i) {
                        return coverButton(
                            itemHeight,
                            itemWidth,
                            margin,
                            context,
                            snapshot.data,
                            _dataList?.elementAt(i)?.title,
                            _dataList?.elementAt(i)?.authors,
                            _dataList?.elementAt(i)?.cover,
                            () {});
                      }, childCount: _dataList == null ? 9 : _dataList.length),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 0.75, crossAxisCount: 3),
                    )
                  ]),
            );
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.search),
      ),
    );
  }

  List<Widget> bottomBar() {
    List<Widget> bar = [];
    for (var i = 0; i < _filterList.length; i++) {
      bar.add(
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                showMaterialScrollPicker(
                  context: context,
                  title: _filterList[i].title,
                  items: _filterList[i].items.map((e) => e.tagName).toList(),
                  confirmText: '确定',
                  cancelText: '取消',
                  selectedItem: tagList[i].tagName,
                  onChanged: (value) {
                    tagList[i] = _filterList[i]
                        .items
                        .firstWhere((element) => element.tagName == value);
                  },
                  onConfirmed: getComicCategoryData,
                );
              },
              child: Column(
                children: [
                  Text(
                    "${_filterList[i].title}",
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Text("${tagList[i].tagName}",
                      style: Theme.of(context).textTheme.subtitle1)
                ],
              ),
            ),
          ),
        ),
      );
    }
    return bar;
  }

//Text("${_filterList[i].title}:\n${tagList[i].tagName}")
  Future onLoad() async {
    await getComicCategoryData(isRefresh: false);
  }

  Future getComicCategoryData({isRefresh = true}) async {
    try {
      if (isRefresh) page = 0;

      if (page == 0) {
        pageStateController.add(PageState.loading);
      }
      var api = Api.comicCatagory(
          tagList.map((e) => e.tagId.toString()).toList(), page, orderType);

      Response response = await Dio()
          .get(api, options: Options(responseType: ResponseType.plain));

      if (response.statusCode == 200) {
        if (isRefresh) _dataList = [];
        _dataList.addAll(comicCategoryItemFromMap(response.data));
        page += 1;
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
      Response response = await Dio()
          .get(api, options: Options(responseType: ResponseType.plain));

      if (response.statusCode == 200) {
        _filterList = comicCategoryFilterFromMap(response.data);
        for (var i = 0; i < _filterList.length; i++) {
          tagList[i] = _filterList[i].items[0];
        }
        getComicCategoryData();
      } else {
        throw HttpException('statusCode: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }
}
