import 'dart:ui';

import 'package:common_utils/common_utils.dart';
import 'package:dmapicore/api/api_models/protobuf/comic/detail_response.pb.dart';
import 'package:dmapicore/internal/app_constants.dart';
import 'package:dmapicore/model/comic/comic_volume_model.dart';
import 'package:dmapicore/views/comic/comic_reader/comic_reader_page.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class ComicDetailShow extends StatelessWidget {
  const ComicDetailShow(
      {Key? key,
      required this.detail,
      required this.onRefresh,
      required this.showSequence,
      required this.toggleSequence})
      : super(key: key);

  final ComicDetailInfoResponse detail;
  final ValueGetter<Future<void>> onRefresh;
  final List<bool> showSequence;
  final ValueSetter<int> toggleSequence;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(detail.title),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            // _ComicBackground(src: detail.cover),
            RefreshIndicator(
              onRefresh: onRefresh,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                clipBehavior: Clip.none,
                slivers: [
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 160,
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: theme.cardColor,
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 128,
                              width: 96,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: ExtendedNetworkImageProvider(
                                      detail.cover,
                                      headers: imgHeader,
                                    ),
                                    onError: (exception, stackTrace) {
                                      print(exception);
                                    },
                                  )),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    detail.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.headline4,
                                  ),
                                  Text(
                                    detail.authors[0].tagName,
                                    style: theme.textTheme.headline5?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '''最后更新 ${DateUtil.formatDateMs(detail.lastUpdatetime.toInt() * 1000, format: "yyyy-MM-dd")}''',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      padding: const EdgeInsets.all(8),
                      height: kToolbarHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: theme.cardColor,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                const Icon(Icons.local_fire_department),
                                Expanded(
                                  child: Text(
                                    detail.hotNum.toString(),
                                    maxLines: 1,
                                    style: theme.textTheme.headline5,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const VerticalDivider(),
                          Expanded(
                            child: Row(
                              children: [
                                const Icon(Icons.favorite_border),
                                Expanded(
                                  child: Text(
                                    detail.subscribeNum.toString(),
                                    maxLines: 1,
                                    style: theme.textTheme.headline5,
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: theme.cardColor,
                      ),
                      child: Text(
                        detail.description,
                        style: theme.textTheme.bodyText1,
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, i) {
                      return Container(
                        margin: const EdgeInsets.all(4),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: theme.cardColor,
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                detail.chapters[i].title,
                                style: theme.textTheme.headline6,
                              ),
                              trailing: AnimatedCrossFade(
                                duration: const Duration(milliseconds: 500),
                                firstChild: IconButton(
                                  onPressed: () {
                                    toggleSequence(i);
                                  },
                                  icon: const Icon(Icons.trending_up),
                                ),
                                firstCurve: Curves.easeIn,
                                secondCurve: Curves.easeOut,
                                secondChild: IconButton(
                                  onPressed: () {
                                    toggleSequence(i);
                                  },
                                  icon: const Icon(Icons.trending_down),
                                ),
                                crossFadeState: showSequence[i]
                                    ? CrossFadeState.showFirst
                                    : CrossFadeState.showSecond,
                              ),
                            ),
                            GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 128,
                                mainAxisExtent: 56,
                                mainAxisSpacing: 4,
                                crossAxisSpacing: 4,
                              ),
                              itemBuilder: (ctx, j) {
                                final chapters;
                                if (showSequence[i]) {
                                  chapters =
                                      detail.chapters[i].data.reversed.toList();
                                } else {
                                  chapters = detail.chapters[i].data;
                                }
                                return TextButton(
                                  onPressed: () {
                                    ComicVolume volume = ComicVolume(
                                      comicId: detail.id,
                                      comicTitle: detail.title,
                                      volumeTitle: detail.chapters[i].title,
                                      chapterList: detail.chapters[i].data,
                                      firstLetter: detail.firstLetter,
                                    );
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ComicReaderPage(
                                          volume: volume,
                                          initIndex: j,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    chapters[j].chapterTitle,
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              },
                              itemCount: detail.chapters[i].data.length,
                            ),
                          ],
                        ),
                      );
                    }, childCount: detail.chapters.length),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 100,
                      child: Center(
                        child: Text(
                          "没有更多了",
                          style: theme.textTheme.headline6?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.hintColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

class _ComicBackground extends StatelessWidget {
  const _ComicBackground({Key? key, required this.src}) : super(key: key);

  final String src;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.width;
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Image.network(
        src,
        width: width,
        height: height,
      ),
    );
  }
}
