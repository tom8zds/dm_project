import 'package:dmapicore/api/api.dart';
import 'package:dmapicore/api/api_models/comic/comic_home_model.dart';
import 'package:dmapicore/views/comic/comic_detail/comic_detail_page.dart';
import 'package:dmapicore/views/widgets/utils_widgets.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class RecommendListWidget extends StatelessWidget {
  final RecommendList? list;
  final double itemHeight;
  final double itemWidth;
  final Function? onTap;
  final String? title;
  final Icon? trailing;
  final bool hasListTile;
  final PageState? state;
  final double margin;

  const RecommendListWidget({
    Key? key,
    required this.itemHeight,
    required this.itemWidth,
    this.onTap,
    this.trailing,
    this.hasListTile = false,
    this.state,
    this.list,
    this.title,
    this.margin = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return hasListTile
        ? createWidget(margin, context)
        : createList(margin, context);
  }

  Widget createWidget(double margin, BuildContext context) {
    return InkWell(
      onTap: onTap as void Function()?,
      child: Column(
        children: [
          ListTile(
            title: title == null
                ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: const SizedBox(height: 18, width: 3 * kToolbarHeight),
                  )
                : Text(
                    title!,
                    style: Theme.of(context).textTheme.headline6,
                  ),
            trailing: trailing,
          ),
          createList(margin, context),
        ],
      ),
    );
  }

  Widget createList(double margin, BuildContext context) {
    return Container(
      height: itemHeight,
      child: ListView.builder(
        itemExtent: itemWidth,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: list == null ? 3 : list!.data!.length,
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
              list?.data![i].title ?? list!.data![i].status as String?,
              null,
              list?.data![i].cover, () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ComicDetailPage(comicId: list!.data![i].id ?? list!.data![i].objId!)));
          });
        },
      ),
    );
  }
}
