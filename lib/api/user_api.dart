import 'package:dio/dio.dart';
import 'package:dmapicore/api/http_util.dart';

import 'api.dart';
import 'api_models/user/user_login.dart';

class UserApi {
  static late UserApi instance = UserApi();

  static final Options loginOption = Options(
      responseType: ResponseType.plain,
      contentType: 'application/x-www-form-urlencoded',
      headers: {
        "Host": "user.dmzj.com",
        "Connection": "Keep-Alive",
        "Accept-Encoding": "gzip",
        "User-Agent": "okhttp/3.12.1",
      });

  Future<UserLoginResponse> doLogin(
      {required String username, required String password}) async {
    String? result = await HttpUtil.instance.httpPost(Api.loginV2,
        data: {"passwd": password, "nickname": username}, options: loginOption);
    if (result != null) {
      UserLoginResponse data = userLoginResponseFromMap(result);
      return data;
    } else {
      throw AppError("发生错误");
    }
  }
}
