import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/rendering.dart';

import '../models/api.dart';

class API {
  static const String apiUrl = "https://hub.very1faker.tk/";

  static late Dio dio;

  static init() async {
    dio = Dio(BaseOptions(
      baseUrl: apiUrl,
      connectTimeout: 5000,
      sendTimeout: 2500,
      receiveTimeout: 2500,
      validateStatus: (_) => true,
    ))
      ..interceptors.add(LogInterceptor(requestBody: false));
  }

  static Future<UserInfo?> userInfo(String username) async {
    final resp =
        await dio.get('/user/info', queryParameters: {'username': username});

    if (resp.statusCode == 200) {
      return UserInfo.fromMap(resp.data);
    } else {
      return null;
    }
  }

  static Future<UserData?> userData(String token) async {
    final resp = await dio.get('/user/data',
        options: Options(headers: {'Authorization': 'Bearer $token'}));

    if (resp.statusCode == 200) {
      debugPrint(UserData.fromMap(resp.data).createdAt.toIso8601String());
      return UserData.fromMap(resp.data);
    } else {
      return null;
    }
  }

  static Future<TokenPair?> userLogin(String username, String password) async {
    final jar = CookieJar();
    final manager = CookieManager(jar);
    dio.interceptors.add(manager);

    final resp = await dio.post(
      '/user/login',
      data: {'username': username, 'password': password, 'ct': 2},
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    dio.interceptors.remove(manager);

    if (resp.statusCode == 200) {
      final data = resp.data as Map<String, dynamic>;
      final refresh = (await jar
              .loadForRequest(Uri.https('hub.very1faker.tk', '/user/login')))
          .firstWhere((cookie) => cookie.name == 'hub-rt')
          .value;
      data['refresh'] = refresh;
      return TokenPair.fromMap(data);
    } else {
      return null;
    }
  }

  static userRegister(String username, String email, String password) async {
    dio.post(
      '/user/register',
    );
  }

  static tokenRefresh(String refreshToken) async {}
}
