import 'package:bloc_demo/bloc/testing_bloc.dart';
import 'package:bloc_demo/modal/user_modal.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class UserCardWidget extends StatelessWidget {
  const UserCardWidget({
    Key? key,
    required this.testBloc,
    required this.userIsExist,
    required this.snapshot,
    required this.index,
  }) : super(key: key);

  final TestBloc testBloc;
  final List userIsExist;
  final AsyncSnapshot<List<UserModal>> snapshot;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 5.0,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(snapshot.data![index].avatarUrl!),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      snapshot.data![index].login!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                    )
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    testBloc.addbookMarkData(snapshot.data![index]);
                  },
                  child: userIsExist.isEmpty
                      ? const Icon(
                          Ionicons.bookmark_outline,
                        )
                      : const Icon(
                          Ionicons.bookmark,
                        ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
