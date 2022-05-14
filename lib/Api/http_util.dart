import 'dart:io';

import 'package:dio/dio.dart';

class HttpUtil {
  static late final HttpUtil instance = HttpUtil();

  late Dio dio;

  HttpUtil() {
    print("http util init");
    dio = Dio(
      BaseOptions(),
    );
  }

  Future<String?> httpGet(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool needLogin = false,
  }) async {
    try {
      var result = await dio.get(
        url,
        queryParameters: queryParameters,
        options: options ??
            Options(
              responseType: ResponseType.plain,
              //headers: header,
            ),
      );

      return result.data;
    } catch (e) {
      if (e is DioError) {
        dioErrorHandle(e);
      } else {
        throw AppError("网络请求失败");
      }
      return null;
    }
  }

  Future<String?> httpPost(
    String url, {
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Options? options,
    bool needLogin = false,
  }) async {
    try {
      var result = await dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options ??
            Options(
              responseType: ResponseType.plain,
              //headers: header,
            ),
      );

      return result.data;
    } catch (e) {
      if (e is DioError) {
        dioErrorHandle(e);
      } else {
        throw AppError("网络请求失败");
      }
      return null;
    }
  }

  Future httpDownload(String url, String path,
      {Map<String, dynamic>? queryParameters,
      dynamic data,
      Options? options}) async {
    dio.download(
      url,
      path,
      queryParameters: queryParameters,
      data: data,
      deleteOnError: false,
      options: options ??
          Options(
            responseType: ResponseType.plain,
            //headers: header,
          ),
    );
  }

  /// Downloading by spiting as file in chunks
  Future downloadWithChunks(url, savePath,
      {ProgressCallback? onReceiveProgress, Options? options}) async {
    const firstChunkSize = 102;
    const maxChunk = 3;

    var total = 0;
    var dio = Dio();
    var progress = <int>[];

    void Function(int, int) createCallback(no) {
      return (int received, int _) {
        progress[no] = received;
        if (onReceiveProgress != null && total != 0) {
          onReceiveProgress(progress.reduce((a, b) => a + b), total);
        }
      };
    }

    Future<Response> downloadChunk(url, start, end, no) async {
      progress.add(0);
      --end;
      if (options != null) {
        options.headers!.addAll({'range': 'bytes=$start-$end'});
      }
      return dio.download(
        url,
        savePath + 'temp$no',
        onReceiveProgress: createCallback(no),
        options: options ??
            Options(
              headers: {'range': 'bytes=$start-$end'},
            ),
      );
    }

    Future mergeTempFiles(chunk) async {
      var f = File(savePath + 'temp0');
      var ioSink = f.openWrite(mode: FileMode.writeOnlyAppend);
      for (var i = 1; i < chunk; ++i) {
        var _f = File(savePath + 'temp$i');
        await ioSink.addStream(_f.openRead());
        await _f.delete();
      }
      await ioSink.close();
      await f.rename(savePath);
    }

    var response = await downloadChunk(url, 0, firstChunkSize, 0);
    if (response.statusCode == 206) {
      total = int.parse(response.headers
          .value(HttpHeaders.contentRangeHeader)!
          .split('/')
          .last);
      var reserved = total -
          int.parse(response.headers.value(Headers.contentLengthHeader)!);
      var chunk = (reserved / firstChunkSize).ceil() + 1;
      if (chunk > 1) {
        var chunkSize = firstChunkSize;
        if (chunk > maxChunk + 1) {
          chunk = maxChunk + 1;
          chunkSize = (reserved / maxChunk).ceil();
        }
        var futures = <Future>[];
        for (var i = 0; i < maxChunk; ++i) {
          var start = firstChunkSize + i * chunkSize;
          futures.add(downloadChunk(url, start, start + chunkSize, i + 1));
        }
        await Future.wait(futures);
      }
      await mergeTempFiles(chunk);
    }
  }

  void dioErrorHandle(DioError e) {
    switch (e.type) {
      case DioErrorType.cancel:
        throw AppError("请求被取消");
      case DioErrorType.response:
        throw AppError("请求失败:${e.response!.statusCode}");
      case DioErrorType.connectTimeout:
      case DioErrorType.sendTimeout:
      case DioErrorType.receiveTimeout:
        throw AppError("网络连接超时,请稍后再试");
      default:
        throw AppError("请求失败,无法连接至服务器");
    }
  }
}

class AppError implements Exception {
  final int? code;
  final String message;

  AppError(
    this.message, {
    this.code,
  });

  @override
  String toString() {
    return message;
  }
}
