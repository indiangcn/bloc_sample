import 'dart:convert';
import 'package:bloc_demo/modal/user_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefStorage {
  static void addBookmarkUser(List userList) async {
    List<String> splist = userList.map((e) => jsonEncode(e)).toList();
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setStringList('userlist', splist);
  }

  static loadBookmarkUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var userData = pref.getStringList('userlist');

    if (userData != null) {
      var userList =
          userData.map((e) => UserModal.fromJson(jsonDecode(e))).toList();
      return userList;
    }
  }
}
