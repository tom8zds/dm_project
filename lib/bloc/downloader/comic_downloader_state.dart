part of 'comic_downloader_cubit.dart';

enum ComicDownloaderStatus { start, stop }

extension ComicDownloaderStatusX on ComicDownloaderStatus{
  bool get isStart => this == ComicDownloaderStatus.start;
  bool get isStop => this == ComicDownloaderStatus.stop;
}

class ComicDownloaderState extends Equatable{
  final ComicDownloaderStatus status;
  final Map<String,MissionInfo> missionQueue;


  ComicDownloaderState copyWith({
    ComicDownloaderStatus? status,
    Map<String,MissionInfo>? missionQueue,
  }) {
    return ComicDownloaderState(
      status: status ?? this.status,
      missionQueue: missionQueue ?? this.missionQueue,
    );
  }

  const ComicDownloaderState({
    required this.status,
    required this.missionQueue,
  });

  static ComicDownloaderState initState() => const ComicDownloaderState(status: ComicDownloaderStatus.stop, missionQueue: {});

  @override
  List<Object> get props => [status, missionQueue];
}
