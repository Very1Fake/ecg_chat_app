import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:ecg_chat_app/models/settings.dart';
import 'package:ecg_chat_app/models/state_manager.dart';
import 'package:ecg_chat_app/utils/pair.dart';
import 'package:flutter/rendering.dart';

import '../models/account.dart';
import '../models/api.dart';

class API {
  static const String apiUrl = "https://hub.very1faker.tk/";
  static const Duration accessRotate = Duration(seconds: 10);

  static late Dio dio;

  // State

  static Account? tempAccount;

  static beginTempSession(String token) {
    tempAccount = Account.temp(token);
  }

  static endTempSession() {
    tempAccount = null;
  }

  static init() {
    dio = Dio(BaseOptions(
      baseUrl: apiUrl,
      connectTimeout: 7500,
      sendTimeout: 3000,
      receiveTimeout: 5000,
      validateStatus: (_) => true,
    ))
      ..interceptors.add(LogInterceptor(requestBody: false));
  }

  // Endpoints

  static Future<TokenPair?> maintainSession() async {
    final account = tempAccount ?? Settings().account.value;
    final isTemp = tempAccount != null;

    if (account == null) return null;

    if (account.accessExpiry.difference(DateTime.now()) < accessRotate ||
        account.accessToken == null) {
      final result = await tokenRefresh(account.token);
      final pair = result.first;

      if (pair != null) {
        account.token = pair.refresh;
        account.accessToken = pair.access;
        if (!isTemp) await StateManager.updateAccount(account);
      } else {
        if (result.second) StateManager.logOut();
        return null;
      }
    }

    return TokenPair(account.token, account.accessToken!);
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

  static Future<UserData?> userData() async {
    final pair = await maintainSession();

    if (pair != null) {
      final resp = await dio.get('/user/data',
          options:
              Options(headers: {'Authorization': 'Bearer ${pair.access}'}));

      if (resp.statusCode == 200) return UserData.fromMap(resp.data);
    }

    return null;
  }

  static Future<TokenPair?> userLogin(String username, String password) async {
    final jar = CookieJar();
    final manager = CookieManager(jar);
    dio.interceptors.add(manager);

    final resp = await dio.post(
      '/user/login',
      data: {'username': username, 'password': password, 'ct': 2},
      options: Options(responseType: ResponseType.plain),
    );

    dio.interceptors.remove(manager);

    if (resp.statusCode == 200) {
      return TokenPair(
        (await jar
                .loadForRequest(Uri.https('hub.very1faker.tk', '/user/login')))
            .firstWhere((cookie) => cookie.name == 'hub-rt')
            .value,
        resp.data as String,
      );
    } else {
      return null;
    }
  }

  static Future<bool?> userRegister(
      String username, String email, String password) async {
    final resp = await dio.post('/user/register', data: {
      'username': username,
      'email': email,
      'password': password,
    });

    if (resp.statusCode == 201) {
      return true;
    } else if (resp.statusCode == 409) {
      return false;
    } else {
      return null;
    }
  }

  static Future<Pair<TokenPair?, bool>> tokenRefresh(String token) async {
    final jar = CookieJar();
    final manager = CookieManager(jar);
    dio.interceptors.add(manager);

    final resp = await dio.get('token/refresh',
        options: Options(
            headers: {'Cookie': 'hub-rt=$token;'},
            responseType: ResponseType.plain));

    dio.interceptors.remove(manager);

    if (resp.statusCode == 200) {
      final cookies = (await jar
          .loadForRequest(Uri.https('hub.very1faker.tk', '/user/login')));

      return Pair(
        TokenPair(
            cookies.isNotEmpty
                ? cookies.firstWhere((cookie) => cookie.name == 'hub-rt').value
                : token,
            resp.data as String),
        true,
      );
    } else if (resp.statusCode == 404) {
      return Pair(null, true);
    } else {
      return Pair(null, false);
    }
  }

  static Future<bool> tokenRevoke() async {
    final pair = await maintainSession();

    if (pair == null) return false;

    final resp = await dio.get('token/revoke',
        options: Options(headers: {'Authorization': 'Bearer ${pair.access}'}));

    if (resp.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> tokenRevokeAll() async {
    final pair = await maintainSession();

    if (pair == null) return false;

    final jar = CookieJar();
    final manager = CookieManager(jar);
    dio.interceptors.add(manager);

    final resp = await dio.get('token/revoke_all',
        options: Options(
            headers: {'Authorization': 'Bearer ${pair.access}'},
            responseType: ResponseType.plain));

    dio.interceptors.remove(manager);

    if (resp.statusCode == 200) {
      final cookies = (await jar
          .loadForRequest(Uri.https('hub.very1faker.tk', '/token/revoke_all')));
      final account = Settings().account.value!;

      account.token = cookies.isNotEmpty
          ? cookies.firstWhere((cookie) => cookie.name == 'hub-rt').value
          : pair.refresh;

      account.accessToken = resp.data;
      await StateManager.updateAccount(account);

      return true;
    } else {
      return false;
    }
  }

  static Future<UserSessions?> userSessions() async {
    final pair = await maintainSession();

    if (pair == null) return null;

    final resp = await dio.get('user/sessions',
        options: Options(headers: {'Authorization': 'Bearer ${pair.access}'}));

    if (resp.statusCode == 200) {
      return UserSessions.fromMap(resp.data as Map<String, dynamic>);
    } else {
      return null;
    }
  }
}
