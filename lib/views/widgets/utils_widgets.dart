import 'package:cached_network_image/cached_network_image.dart';
import 'package:dm_project/Api/api.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

const headers = {"Referer": "http://www.dmzj.com/"};

Widget coverButton(
        double itemHeight,
        double itemWidth,
        double margin,
        BuildContext context,
        PageState state,
        String title,
        String subTitle,
        String cover,
        Function onTap) =>
    InkWell(
      onTap: onTap,
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
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
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
                          gradient: LinearGradient(
                              colors: [Colors.transparent, Colors.black87],
                              begin: Alignment.center,
                              end: Alignment.bottomCenter),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(
                                cover,
                                headers: headers,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ListTile(
                          horizontalTitleGap: 0,
                          title: Text(
                            title,
                            style: TextStyle(color: Colors.white),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: subTitle == null
                              ? null
                              : Text(
                                  subTitle,
                                  style: TextStyle(color: Colors.white54),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
  PageState state,
  Function onTap, {
  double itemHeight = 3 * kToolbarHeight,
  double margin = 8.0,
  String title = '',
  String types = '',
  String authors = '',
  String updateTime = '',
  String updateChapter = '',
  String cover = '',
  int order = -1,
}) =>
    InkWell(
      onTap: onTap,
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
                      SizedBox(
                        width: 8,
                      ),
                      Container(
                        width: itemHeight * 0.75 - 12,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: margin / 2,
                              )
                            ],
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(
                                cover,
                                headers: headers,
                              ),
                              onError: (exception, stackTrace) {
                                print(exception);
                              },
                            )),
                      ),
                      VerticalDivider(
                        width: margin * 2,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: Theme.of(context).textTheme.headline6,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            authors,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          Text(
                            types,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Text(
                            updateTime,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Text(
                            updateChapter,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ),
                    ],
                  );
                case PageState.loading:
                  print('loading');
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
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
                        child: Icon(Icons.broken_image),
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
                        child: Icon(Icons.broken_image),
                      )
                    ],
                  );
              }
            },
          ),
        ),
      ),
    );
