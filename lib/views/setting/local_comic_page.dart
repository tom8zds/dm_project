import 'package:dmapicore/bloc/comic/local_comic/local_comic_cubit.dart';
import 'package:dmapicore/model/common/load_status_model.dart';
import 'package:dmapicore/views/comic/comic_detail/comic_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocalComicPage extends StatelessWidget {
  const LocalComicPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocalComicCubit, LocalComicState>(
        builder: (context, state) {
          context.read<LocalComicCubit>().loadData();
          return Scaffold(
            appBar: AppBar(
              title: const Text("漫画下载"),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                context.read<LocalComicCubit>().loadData();
              },
              child: const Icon(Icons.refresh),
            ),
            body: CustomScrollView(
              slivers: [
                state.comicList.isNotEmpty
                    ? SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final comic = state.comicList.elementAt(index);
                            return ListTile(
                              title: Text(comic.comicTitle),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ComicDetailPage(comicId: comic.comicId),
                                  ),
                                );
                              },
                            );
                          },
                          childCount: state.comicList.length,
                        ),
                      )
                    : const SliverFillRemaining(
                        child: Center(
                          child: Text("啥都没有"),
                        ),
                      ),
              ],
            ),
          );
        },
        listener: (context, state) {});
  }
}
