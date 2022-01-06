import 'package:bloc_demo/modal/user_modal.dart';
import 'package:dio/dio.dart';
import 'package:bloc_demo/constant/const_key.dart';

class ApiManager {
  static fetchUser(int page) async {
    String token = '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';
    String key = '${Keys.userBaseUrl}?since=$page&per_page=10';
    var response = await Dio().get(
      key,
      options: Options(
          // headers: {
          //   'Authorization': 'Bearer $token',
          // },
          ),
    );
    if (response.statusCode == 200) {
      List<dynamic> responseList = response.data as List;
      List<UserModal> userModalList =
          responseList.map((e) => UserModal.fromJson(e)).toList();
      return userModalList;
    }
  }
}
