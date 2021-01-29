import 'package:dm_project/Api/api.dart';
import 'package:dm_project/Api/api_models/comic/comic_home_model.dart';
import 'package:dm_project/views/widgets/utils_widgets.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class RecommendListWidget extends StatelessWidget {
  final RecommendList list;
  final double itemHeight;
  final double itemWidth;
  final Function onTap;
  final String title;
  final Icon trailing;
  final bool hasListTile;
  final PageState state;

  const RecommendListWidget({
    Key key,
    this.itemHeight,
    this.itemWidth,
    this.onTap,
    this.trailing,
    this.hasListTile = false,
    this.state,
    this.list,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double margin = 8.0;

    return hasListTile
        ? createWidget(margin, context)
        : createList(margin, context);
  }

  Widget createWidget(double margin, BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            ListTile(
              title: title == null
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      child: SizedBox(height: 18, width: 3 * kToolbarHeight),
                    )
                  : Text(
                      title,
                      style: Theme.of(context).textTheme.headline6,
                    ),
              trailing: trailing,
            ),
            createList(margin, context),
          ],
        ),
      ),
    );
  }

  Widget createList(double margin, BuildContext context) {
    return Container(
      height: itemHeight,
      child: ListView.builder(
        itemExtent: itemWidth,
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: list == null ? 3 : list.data.length,
        padding: EdgeInsets.only(left: margin),
        itemBuilder: (context, i) {
          if (list == null) {
            return coverButton(itemHeight, itemWidth, margin, context, state,
                null, null, null, null);
          }
          return coverButton(
              itemHeight,
              itemWidth,
              margin,
              context,
              state,
              list?.data[i]?.title ?? list.data[i].status,
              list?.data[i]?.subTitle ?? list?.data[i]?.authors,
              list?.data[i]?.cover,
              () {});
        },
      ),
    );
  }
}
