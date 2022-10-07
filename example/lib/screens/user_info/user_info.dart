import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';

class CurrentUserInfo extends StatefulWidget {
  const CurrentUserInfo({Key? key}) : super(key: key);

  @override
  State<CurrentUserInfo> createState() => _CurrentUserInfoState();
}

class _CurrentUserInfoState extends State<CurrentUserInfo> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer(builder: (context, ref, child) {
        FFrameUser? fFrameUser = ref.watch(userStateNotifier).fFrameUser;

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  flex: 1,
                  child: Text("timeStamp"),
                ),
                Expanded(
                  flex: 3,
                  child: Text("${fFrameUser?.timeStamp?.toLocal()}"),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  flex: 1,
                  child: Text("usertoken"),
                ),
                Expanded(
                  flex: 3,
                  child: Text("${fFrameUser?.firebaseUser?.refreshToken}"),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  flex: 1,
                  child: Text("roles"),
                ),
                Expanded(
                  flex: 3,
                  child: Text("${fFrameUser?.roles}"),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
