import 'package:dmapicore/model/common/load_status_model.dart';
import 'package:dmapicore/views/comic/comic_detail/comic_detail_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widget/comic_detail_show.dart';

class ComicDetailPage extends StatelessWidget {
  final int comicId;

  const ComicDetailPage({Key? key, required this.comicId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ComicDetailCubit(),
      child: ComicDetailView(
        comicId: comicId,
      ),
    );
  }
}

class ComicDetailView extends StatelessWidget {
  final int comicId;

  const ComicDetailView({Key? key, required this.comicId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ComicDetailCubit, ComicDetailState>(
      builder: (context, state) {
        if (state.status == LoadStatus.initial) {
          context.read<ComicDetailCubit>().fetchDetail(comicId);
        }
        switch (state.status) {
          case LoadStatus.initial:
          case LoadStatus.loading:
            return const ComicDetailLoading();
          case LoadStatus.success:
            return ComicDetailShow(
              detail: state.detail,
              onRefresh: () {
                return context.read<ComicDetailCubit>().refreshDetail();
              },
              showSequence: state.showSequence,
              toggleSequence: (int index) {
                return context
                    .read<ComicDetailCubit>()
                    .toggleShowSequence(index);
              },
            );
          case LoadStatus.failure:
          default:
            return const ComicDetailError();
        }
      },
      listener: (context, state) {},
    );
  }
}

class ComicDetailLoading extends StatelessWidget {
  const ComicDetailLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class ComicDetailError extends StatelessWidget {
  const ComicDetailError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: const Center(
        child: Icon(
          Icons.error_outline,
          size: kToolbarHeight,
        ),
      ),
    );
  }
}
