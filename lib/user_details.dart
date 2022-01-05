import 'package:bloc_demo/bloc/testing_bloc.dart';
import 'package:bloc_demo/modal/user_modal.dart';
import 'package:bloc_demo/widget/user_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({Key? key}) : super(key: key);

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  TestBloc testBloc = TestBloc();
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    testBloc.eventSink.add(TestAction.fetch);
  }

  void setupScrollController(BuildContext context) {
    scrollController.addListener(
      () {
        if (scrollController.position.atEdge) {
          if (scrollController.position.pixels != 0) {
            testBloc.eventSink.add(TestAction.loadMoredata);
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    setupScrollController(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Api-BlocPattern"),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 6,
            tabs: [
              Tab(
                text: "All User",
              ),
              Tab(
                text: "BookMark User",
              )
            ],
          ),
        ),
        body: SizedBox(
          child: StreamBuilder2<List<UserModal>, List<UserModal>>(
            streams: Tuple2(testBloc.userStream, testBloc.bookmarkStream),
            builder: (BuildContext context,
                Tuple2<AsyncSnapshot<List<UserModal>>,
                        AsyncSnapshot<List<UserModal>>>
                    snapshot) {
              if (snapshot.item1.hasData) {
                return TabBarView(
                  children: [
                    //AllUser Tab
                    ListView.builder(
                      itemCount: snapshot.item1.data!.length,
                      controller: scrollController,
                      itemBuilder: (context, index) {
                        var userIsExist =
                            testBloc.userIsExist(snapshot.item1.data![index]);
                        return UserCardWidget(
                          testBloc: testBloc,
                          userIsExist: userIsExist,
                          snapshot: snapshot.item1,
                          index: index,
                        );
                      },
                    ),
                    //BookMark Tab
                    snapshot.item2.hasData
                        ? snapshot.item2.data!.isEmpty
                            ? const Center(
                                child: Text("BookMark Not Added"),
                              )
                            : ListView.builder(
                                itemCount: snapshot.item2.data!.length,
                                controller: scrollController,
                                itemBuilder: (context, index) {
                                  var userIsExist = testBloc
                                      .userIsExist(snapshot.item2.data![index]);
                                  return UserCardWidget(
                                    testBloc: testBloc,
                                    userIsExist: userIsExist,
                                    snapshot: snapshot.item2,
                                    index: index,
                                  );
                                },
                              )
                        : const Center(
                            child: Text("Bookmark Not Added"),
                          )
                  ],
                );
              } else if (snapshot.item1.hasError) {
                return const Center(
                  child: Text(
                    "SomeThing Went Wrong",
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 4.5,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    testBloc.dispose();
    super.dispose();
  }
}
