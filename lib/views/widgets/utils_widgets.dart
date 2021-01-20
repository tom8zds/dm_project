import 'package:cached_network_image/cached_network_image.dart';
import 'package:dm_project/Api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:shimmer/shimmer.dart';

ClassicalHeader getClassicalHeader() {
  return ClassicalHeader(
    refreshText: '下拉刷新',
    refreshingText: '正在加载...',
    refreshReadyText: '释放刷新',
    refreshFailedText: '加载失败',
    refreshedText: '加载完成',
    noMoreText: '到头了',
    infoText: '更新于 %T',
  );
}

Widget createTagItem(
    String text, int id, Function ontap, bool isSelected, int type) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 4),
    child: ButtonTheme(
      minWidth: 20,
      height: 32,
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        color: isSelected ? Colors.blue : Colors.transparent,
        textColor: isSelected ? Colors.white : Colors.black,
        //borderSide: BorderSide(color: Theme.of(context).accentColor),
        child: Text(
          text,
        ),
        onPressed: () {
          ontap(type, id);
        },
      ),
    ),
  );
}

Widget coverButton(
    double itemHeight,
    double itemWidth,
    double margin,
    BuildContext context,
    PageState state,
    String title,
    String subTitle,
    String cover,
    Function onTap) {
  return Padding(
    padding: EdgeInsets.all(margin),
    child: Container(
      height: itemHeight - 2 * margin,
      width: itemWidth - 2 * margin,
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: margin / 2,
              offset: Offset(margin / 2, margin / 2),
            )
          ]),
      child: Center(
        child: Builder(builder: (context) {
          switch (state) {
            case PageState.loading:
              return Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[100],
                  child: Container(
                    height: itemHeight,
                    width: itemWidth,
                    color: Colors.white,
                  ));
            case PageState.done:
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FlatButton(
                  padding: EdgeInsets.zero,
                  onPressed: onTap,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                            cover,
                            headers: {"Referer": "http://www.dmzj.com/"},
                          ),
                        )),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Colors.transparent, Colors.black87],
                                begin: Alignment.center,
                                end: Alignment.bottomCenter),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ListTile(
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
                  ),
                ),
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
  );
}
