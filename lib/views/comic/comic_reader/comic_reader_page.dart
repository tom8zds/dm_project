import 'dart:io';

import 'package:dmapicore/bloc/comic/reader/comic_reader_cubit.dart';
import 'package:dmapicore/internal/app_constants.dart';
import 'package:dmapicore/model/comic/comic_volume_model.dart';
import 'package:dmapicore/model/common/load_status_model.dart';
import 'package:dmapicore/views/widgets/comic_page_view.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:preload_page_view/preload_page_view.dart';

class ComicReaderPage extends StatelessWidget {
  final ComicVolume volume;
  final int initIndex;

  const ComicReaderPage({Key? key, required this.volume, this.initIndex = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

  ComicReaderView({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ImageGalleryOne(
          state: state,
        ),
      ),
    );
  }
}

class ImageGalleryOne extends StatelessWidget {
  final PreloadPageController pageController = PreloadPageController();

  final ComicReaderState state;

  ImageGalleryOne({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ComicPageView.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (context, index) {
        final url = state.chapter.data.pageUrl.elementAt(index);
        return PhotoViewGalleryPageOptions(
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
          imageProvider: ExtendedNetworkImageProvider(
            url,
            headers: imgHeader,
          ),
        );
      },
      gaplessPlayback: false,
      itemCount: state.chapter.data.picNum,
      loadingBuilder: (context, event) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      loadFailedChild: const Center(
        child: Text("出错啦"),
      ),
      pageController: pageController,
    );
  }
}
