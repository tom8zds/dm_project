
import 'package:dmapicore/bloc/comic/reader/comic_reader_cubit.dart';
import 'package:dmapicore/internal/app_constants.dart';
import 'package:dmapicore/model/comic/comic_detail_model.dart';
import 'package:dmapicore/model/common/load_status_model.dart';
import 'package:dmapicore/views/widgets/comic_page_view.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ComicReaderPage extends StatelessWidget {
  final ComicVolume volume;
  final int initIndex;

  const ComicReaderPage({Key? key, required this.volume, this.initIndex = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: Container(
          color: Colors.black,
        ),
      ),
      body: BlocProvider<ComicReaderCubit>(
        create: (_) => ComicReaderCubit(volume),
        child: BlocBuilder<ComicReaderCubit, ComicReaderState>(
          builder: (context, state) {
            if (state.status.isInitial) {
              context.read<ComicReaderCubit>().fetchChapterData(initIndex);
            }
            switch (state.status) {
              case LoadStatus.initial:
              case LoadStatus.loading:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case LoadStatus.success:
                return ComicReaderView(
                  state: state,
                );
              case LoadStatus.failure:
                return const Center(
                  child: Icon(Icons.error_outline),
                );
            }
          },
        ),
      ),
    );
  }
}

class ComicReaderView extends StatelessWidget {
  final ComicReaderState state;

  const ComicReaderView({Key? key, required this.state}) : super(key: key);

  Future<void> showActionDialog(BuildContext context) async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(state.chapter.data.title),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {},
                child: const Text("刷新"),
              ),
              SimpleDialogOption(
                onPressed: () {},
                child: const Text("保存"),
              ),
              SimpleDialogOption(
                onPressed: () {},
                child: const Text("分享"),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onLongPress: () async => showActionDialog(context),
          child: ImageGalleryOne(
            state: state,
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            height: kToolbarHeight,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Expanded(
                  child: Slider(
                    value: state.progress,
                    onChanged: (value) {
                      context.read<ComicReaderCubit>().movePage(value);
                    },
                    onChangeEnd: (value) {
                      context.read<ComicReaderCubit>().onPageChange(value.round());
                    },
                    label: state.progress.toString(),
                    min: 0,
                    max: state.chapter.data.picNum - 1,
                  ),
                ),
                Text(
                    "${(state.progress.round() + 1)}/${state.chapter.data.picNum}"),
              ],
            ),
          ),
        ),
        Positioned(
          right: 0,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: kToolbarHeight,
            child: GestureDetector(
              onTap: context.read<ComicReaderCubit>().nextPage,
            ),
          ),
        ),
        Positioned(
          left: 0,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: kToolbarHeight,
            child: GestureDetector(
              onTap: context.read<ComicReaderCubit>().lastPage,
            ),
          ),
        ),
      ],
    );
  }
}

class ImageGalleryOne extends StatelessWidget {
  final ComicReaderState state;

  const ImageGalleryOne({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ComicPageView.builder(
      builder: (context, index) {
        final url = state.chapter.data.pageUrl.elementAt(index);
        return PhotoViewGalleryPageOptions.customChild(
          filterQuality: FilterQuality.high,
          initialScale: PhotoViewComputedScale.contained,
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.contained * 2.5,
          scaleStateCycle: (state) {
            switch (state) {
              case PhotoViewScaleState.initial:
                return PhotoViewScaleState.tapZoom;
              case PhotoViewScaleState.covering:
              case PhotoViewScaleState.originalSize:
              case PhotoViewScaleState.zoomedIn:
              case PhotoViewScaleState.zoomedOut:
              case PhotoViewScaleState.tapZoom:
                return PhotoViewScaleState.initial;
            }
          },
          child: ComicPage(
            url: url,
          ),
        );
      },
      gaplessPlayback: false,
      itemCount: state.chapter.data.picNum,
      onPageChanged: (index) {
        context.read<ComicReaderCubit>().onPageChange(index);
      },
      pageController: context.read<ComicReaderCubit>().pageController,
    );
  }
}

class ComicPage extends StatelessWidget {
  final String url;

  const ComicPage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: ExtendedImage.network(
        url,
        headers: imgHeader,
        filterQuality: FilterQuality.high,
        loadStateChanged: (state) {
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              if (state.loadingProgress == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                double progress =
                    (state.loadingProgress?.cumulativeBytesLoaded ?? 100) /
                        (state.loadingProgress?.expectedTotalBytes ?? 100);
                return Center(
                  child: CircularProgressIndicator(
                    value: progress,
                  ),
                );
              }
            case LoadState.completed:
              return state.completedWidget;
            case LoadState.failed:
              return Center(
                child: IconButton(
                  onPressed: state.reLoadImage,
                  icon: const Icon(Icons.refresh),
                ),
              );
          }
        },
      ),
    );
  }
}
