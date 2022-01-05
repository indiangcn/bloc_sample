import 'dart:async';
import 'package:bloc_demo/modal/user_modal.dart';
import 'package:bloc_demo/service/api_service.dart';
import 'package:bloc_demo/sharedprefrence/pref.dart';

//Event For Fetch,Update,Delete Action Over Api
enum TestAction { fetch, loadMoredata }

class TestBloc {
  List<UserModal> userList = [];
  List<UserModal> bookMarkUser = [];
  int pageIndex = 0;

  // State Stream Controller
  final stateStreamController = StreamController<List<UserModal>>();
  Stream<List<UserModal>> get userStream => stateStreamController.stream;
  StreamSink<List<UserModal>> get userSink => stateStreamController.sink;

  //Page Stream Controller
  final pageStreamController = StreamController<int>();
  Stream<int> get pageStream => pageStreamController.stream;
  StreamSink<int> get pageSink => pageStreamController.sink;

  // Event Stream Controller
  final eventStreamController = StreamController<TestAction>();
  Stream<TestAction> get eventStream => eventStreamController.stream;
  StreamSink<TestAction> get eventSink => eventStreamController.sink;

  //BookMark StreamController
  final bookmarkStreamcontroller = StreamController<List<UserModal>>();
  Stream<List<UserModal>> get bookmarkStream => bookmarkStreamcontroller.stream;
  StreamSink<List<UserModal>> get bookmarkSink => bookmarkStreamcontroller.sink;

  TestBloc() {
    pageSink.add(0);
    eventStream.listen(
      (event) async {
        if (event == TestAction.fetch) {
          try {
            //First Time Load BookMarkData
            loadBookMarkData();
            List<UserModal> user = await ApiManager.fetchUser(pageIndex);
            pageIndex++;
            userList.addAll(user);
            userSink.add(userList);
          } on Exception catch (e) {
            userSink.addError("$e");
          }
        } else if (event == TestAction.loadMoredata) {
          loadMoredata();
        }
      },
    );
  }
  userIsExist(UserModal user) {
    var userExist = bookMarkUser.where((element) => element.id == user.id);
    return userExist.toList();
  }

  addbookMarkData(UserModal user) async {
    var userExist = userIsExist(user);
    if (userExist.isEmpty) {
      bookMarkUser.add(user);
      bookmarkSink.add(bookMarkUser);
      PrefStorage.addBookmarkUser(bookMarkUser);
    } else {
      bookMarkUser.removeWhere((element) => element.id == user.id);
      bookmarkSink.add(bookMarkUser);
      PrefStorage.addBookmarkUser(bookMarkUser);
    }
  }

  loadBookMarkData() async {
    var userData = await PrefStorage.loadBookmarkUser();
    if (userData != null) {
      bookMarkUser = userData;
      bookmarkSink.add(bookMarkUser);
    }
  }

  Future<void> loadMoredata() async {
    var user = await ApiManager.fetchUser(pageIndex++);
    userList.addAll(user);
    userSink.add(userList);
  }

  void dispose() {
    stateStreamController.close();
    eventStreamController.close();
    bookmarkStreamcontroller.close();
  }
}
