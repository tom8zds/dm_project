import 'package:dmapicore/bloc/downloader/comic_downloader_cubit.dart';
import 'package:dmapicore/model/downloader/comic_download_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DownloadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ComicDownloaderCubit, ComicDownloaderState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("漫画下载"),
              actions: [
                IconButton(
                  onPressed: () {
                    context.read<ComicDownloaderCubit>().toggleStatus();
                  },
                  icon: AnimatedCrossFade(
                    firstChild: const Icon(Icons.play_arrow),
                    secondChild: const Icon(Icons.pause),
                    firstCurve: Curves.ease,
                    secondCurve: Curves.ease,
                    duration: const Duration(milliseconds: 300),
                    crossFadeState: state.status.isStart
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                  ),
                ),
              ],
            ),
            body: CustomScrollView(
              slivers: [
                SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                  final item = state.missionQueue.values.elementAt(index);
                  return Container(
                    height: 300,
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                              "${item.info.comicTitle} - ${item.info.chapterTitle}"),
                          subtitle: Text(item.state.getName()),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.play_arrow,
                            ),
                            onPressed: () {
                              context.read<ComicDownloaderCubit>().startMission(item);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MissionProgressWidget(
                            mission: item,
                          ),
                        ),
                        Text("${item.progress} / ${item.total}"),
                      ],
                    ),
                  );
                }, childCount: state.missionQueue.length)),
              ],
            ),
          );
        },
        listener: (context, state) {});
  }
}

class MissionProgressWidget extends StatelessWidget {
  final MissionInfo mission;

  const MissionProgressWidget({super.key, required this.mission});

  @override
  Widget build(BuildContext context) {
    switch (mission.state) {
      case MissionState.waiting:
        return LinearProgressIndicator(
          value: 0,
          color: Theme.of(context).disabledColor,
        );
      case MissionState.downloading:
        return LinearProgressIndicator(value: mission.progress / mission.total, color: Theme.of(context).colorScheme.secondary,);
      case MissionState.pause:
        return LinearProgressIndicator(
          value: mission.progress / mission.total,
          color: Theme.of(context).disabledColor,
        );
      case MissionState.extracting:
        return const LinearProgressIndicator();
    }
  }
}
