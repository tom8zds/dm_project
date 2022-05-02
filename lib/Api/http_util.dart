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
