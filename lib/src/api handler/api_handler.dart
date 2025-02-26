import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../instagram_login.dart';
import '../modal/user_data_model.dart';

/// To handle Instagram API
class InstaApi {
  static late InstaConfig config;

  /// To get access token
  static Future<String?> getAccessToken({required String code}) async {
    try {
      var url = Uri(
        scheme: 'https',
        host: 'api.instagram.com',
        path: '/oauth/access_token',
      );
      var request = http.MultipartRequest('POST', url)
        ..fields['client_id'] = config.instaID
        ..fields['client_secret'] = config.instaSecret
        ..fields['grant_type'] = 'authorization_code'
        ..fields['redirect_uri'] = config.reDirectURL.toString()
        ..fields['code'] = code;

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);
      if (response.statusCode == 200) {
        var token = data['access_token'];
        return token;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// To get user data
  static Future<UserDataModel?> getUserData(
      {required String accessToken}) async {
    try {
      var url = Uri(
        scheme: 'https',
        host: 'graph.instagram.com',
        path: '/v22.0/me',
        queryParameters: {
          'fields':
              'user_id,username,name,account_type,profile_picture_url,followers_count,follows_count,media_count',
          'access_token': accessToken,
        },
      );
      var request = http.MultipartRequest('GET', url);
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var data = jsonDecode(responseBody);
      if (response.statusCode == 200) {
        return UserDataModel.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
