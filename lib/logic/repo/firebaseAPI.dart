// ignore_for_file: file_names,non_constant_identifier_names,avoid_print

import 'package:dio/dio.dart';

class FirebaseAPI {
  final String api;
  final String auth;
  FirebaseAPI({required this.api, required this.auth});
  static Future<Map<String, dynamic>?> _getResponse(String url) async {
    try {
      Response response =
          await Dio().getUri<Map<String, dynamic>>(Uri.parse(url));
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data);
      } else {
        print(response.statusCode);
      }
    } catch (error) {
      Exception('>> Api request $error');
    }
  }

  ///initailly function consider path as root path
  Future<Map<String, dynamic>?> getRequest(
      {String path = '', int timeOutsec = 10}) async {
    String finalUrl =
        api + '/' + path + '.json' + '?timeout=${timeOutsec}s' + '&auth=$auth';

    return await _getResponse(finalUrl);
  }

  /// For use -> orderBy:'\$key' & path:'' <- for target root
  Future<Map<String, dynamic>?> searchByKey(
      {required String query,
      required String path,
      required String orderBy,
      int timeOutsec = 10}) async {
    String finalUrl = api +
        '/$path.json?timeout=${timeOutsec}s&auth=$auth&orderBy="$orderBy"&startAt="$query"&endAt="$query\uf8ff"';

    return await _getResponse(finalUrl);
  }

  /// For use -> orderBy:'\$key' & path:'' <- for target root
  Future<Map<String, dynamic>?> rangeQuery(
      {required String startAt,
      required int range,
      required String path,
      required String orderBy,
      int timeOutsec = 10}) async {
    String finalUrl = api +
        '/$path.json?timeout=${timeOutsec}s&auth=$auth&orderBy="$orderBy"&startAt=$startAt&limitToFirst=$range';

    return await _getResponse(finalUrl);
  }

  Future<Map<String, dynamic>?> equalToKey(
      {required String value,
      required String path,
      required String orderBy,
      int timeOutsec = 10}) async {
    String finalUrl = api +
        '/$path.json?timeout=${timeOutsec}s&auth=$auth&orderBy="$orderBy"&equalTo="$value"';

    return await _getResponse(finalUrl);
  }
}
