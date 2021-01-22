import 'package:cached_network_image/cached_network_image.dart';
import 'package:dm_project/Api/api.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

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
              color: Theme.of(context).shadowColor.withOpacity(0.38),
              blurRadius: margin / 2,
              offset: Offset(margin / 2, margin / 2),
            )
          ]),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
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
                return Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                      cover,
                      headers: {"Referer": "http://www.dmzj.com/"},
                    ),
                  )),
                  child: FlatButton(
                    padding: EdgeInsets.zero,
                    onPressed: onTap,
                    child: Stack(
                      children: [
                        Container(
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
    ),
  );
}
