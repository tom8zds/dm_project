import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dmapicore/api/api.dart';
import 'package:dmapicore/api/api_models/comic/comic_collection_model.dart';
import 'package:dmapicore/api/comic_api.dart';
import 'package:dmapicore/views/widgets/error_widget.dart';
import 'package:dmapicore/views/widgets/utils_widgets.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ComicCollectionContentView extends StatefulWidget {
  final String title;
  final int id;
  final String cover;

  const ComicCollectionContentView(
      {Key? key, required this.title, required this.id, required this.cover})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => ComicCollectionContentViewState();
}

class ComicCollectionContentViewState
    extends State<ComicCollectionContentView> {
  ComicCollectionContent? content;

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
    return StreamBuilder(
      stream: pageStateController.stream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) {
          return errorPage(context, getComicCollectionData);
        }
        if (snapshot.hasData) {
          double itemHeight = 3 * kToolbarHeight;
          double margin = 8.0;
          int shimmerCount = MediaQuery.of(context).size.height ~/ itemHeight;
          int oneLineCount = 1 + MediaQuery.of(context).orientation.index;
          print(oneLineCount);
          return Scaffold(
            body: SafeArea(
              child: SmartRefresher(
                physics: const BouncingScrollPhysics(),
                onRefresh: getComicCollectionData,
                controller: refreshController,
                child: CustomScrollView(slivers: [
                  SliverAppBar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    title: Text(
                      widget.title,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.ios_share),
                        onPressed: () {},
                        color: Theme.of(context).accentColor,
                      ),
                    ],
                  ),
                  SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        switch (i) {
                          case 0:
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context)
                                          .shadowColor
                                          .withOpacity(0.38),
                                      blurRadius: margin,
                                    )
                                  ],
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: ExtendedNetworkImageProvider(
                                      widget.cover,
                                      headers: {
                                        "Referer": "http://www.dmzj.com/"
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            );
                          case 1:
                            return Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Container(
                                padding: EdgeInsets.all(margin),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Theme.of(context).cardColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context)
                                          .shadowColor
                                          .withOpacity(0.38),
                                      blurRadius: margin,
                                    )
                                  ],
                                ),
                                child: SingleChildScrollView(
                                  child: Text(
                                    content?.description ?? '',
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                ),
                              ),
                            );
                          default:
                            var item = content?.comics?.elementAt(i - 2);
                            return coverButtonExtend(
                              context,
                              snapshot.data,
                              () {},
                              cover: item?.cover,
                              title: item?.name,
                              updateChapter: item?.recommendBrief,
                              authors: item?.recommendReason,
                              margin: margin,
                              itemHeight: itemHeight,
                            );
                        }
                      },
                      childCount: content == null
                          ? shimmerCount + 2
                          : content!.comics!.length + 2,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 21 / 9, crossAxisCount: oneLineCount),
                  )
                ]),
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {},
              label: Text('评论(${content?.commentAmount?.toString() ?? '0'})'),
              icon: const Icon(Icons.message),
            ),
          );
        }
        return const LinearProgressIndicator();
      },
    );
  }

  Future getComicCollectionData() async {
    try {
      pageStateController.add(PageState.loading);

      var api = Api.comicCollectionContent(widget.id);

      Response response = await Dio()
          .get(api, options: Options(responseType: ResponseType.plain));

      if (response.statusCode == 200) {
        content = await ComicApi.instance.getCollectionContent(widget.id);
        pageStateController.add(PageState.done);
      } else {
        pageStateController.addError('statusCode:${response.statusCode}');
        pageStateController.add(PageState.fail);
      }
      refreshController.refreshCompleted();
    } catch (e) {
      print(e);
      pageStateController.addError(e);
      pageStateController.add(PageState.fail);
      refreshController.refreshFailed();
    }
  }
}
