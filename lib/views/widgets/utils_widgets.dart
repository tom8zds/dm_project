import 'package:dmapicore/api/api.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

const headers = {"Referer": "http://www.dmzj.com/"};

Widget coverButton(
        double itemHeight,
        double itemWidth,
        double margin,
        BuildContext context,
        PageState? state,
        String? title,
        String? subTitle,
        String? cover,
        Function? onTap) =>
    InkWell(
      onTap: onTap as void Function()?,
      child: Container(
        padding: EdgeInsets.all(margin),
        height: itemHeight - 2 * margin,
        width: itemWidth - 2 * margin,
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Builder(builder: (context) {
              switch (state) {
                case PageState.loading:
                  return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Material(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(),
                      ));
                case PageState.done:
                  return Stack(
                    children: [
                      Container(
                        foregroundDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: const LinearGradient(
                              colors: [Colors.transparent, Colors.black87],
                              begin: Alignment.center,
                              end: Alignment.bottomCenter),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: ExtendedNetworkImageProvider(
                                cover!,
                                headers: headers,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                title!,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subTitle == null
                                  ? Container()
                                  : Text(
                                      subTitle,
                                      style: const TextStyle(
                                          color: Colors.white54),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                case PageState.fail:
                  return Icon(
                    Icons.broken_image,
                    color: Theme.of(context).disabledColor,
                  );
                default:
                  return Icon(
                    Icons.broken_image,
                    color: Theme.of(context).disabledColor,
                  );
              }
            }),
          ),
        ),
      ),
    );

Widget coverButtonExtend(
  BuildContext context,
  PageState? state,
  Function onTap, {
  double itemHeight = 4 * kToolbarHeight,
  double margin = 8.0,
  String? title = '',
  String? types = '',
  String? authors = '',
  String? updateTime = '',
  String? updateChapter = '',
  String? cover = '',
  int order = -1,
}) =>
    InkWell(
      onTap: onTap as void Function()?,
      child: Padding(
        padding: EdgeInsets.all(margin),
        child: Container(
          height: itemHeight,
          child: Builder(
            builder: (context) {
              switch (state) {
                case PageState.done:
                  return Row(
                    children: [
                      AspectRatio(
                        aspectRatio: 0.75,
                        child: Container(
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
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: ExtendedNetworkImageProvider(
                                  cover!,
                                  headers: headers,
                                ),
                                onError: (exception, stackTrace) {
                                  print(exception);
                                },
                              )),
                        ),
                      ),
                      VerticalDivider(
                        width: margin * 2,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title ?? '',
                              style: Theme.of(context).textTheme.headline6,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    authors ?? '',
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                  Text(
                                    types ?? '',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  Text(
                                    updateChapter ?? '',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      order == -1
                          ? Container()
                          : Container(
                              width: kToolbarHeight,
                              child: Center(
                                child: Text(
                                  '$order',
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                              ),
                            ),
                      const SizedBox(
                        width: 8,
                      ),
                    ],
                  );
                case PageState.loading:
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: itemHeight * 0.75 - 12,
                          height: itemHeight - 16,
                          color: Colors.white,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                height: 24.0,
                                color: Colors.white,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.0),
                              ),
                              Container(
                                width: double.infinity,
                                height: 16.0,
                                color: Colors.white,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.0),
                              ),
                              Container(
                                width: 40.0,
                                height: 16.0,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                case PageState.fail:
                  return Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        width: itemHeight * 0.75 - 6,
                        child: const Icon(Icons.broken_image),
                      )
                    ],
                  );
                default:
                  return Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        width: itemHeight * 0.75 - 6,
                        child: const Icon(Icons.broken_image),
                      )
                    ],
                  );
              }
            },
          ),
        ),
      ),
    );
