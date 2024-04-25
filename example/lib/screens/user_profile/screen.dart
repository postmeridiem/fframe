import 'package:fframe/fframe.dart';
import 'package:fframe/helpers/slug.dart';
import 'package:flutter/material.dart';

class CurrentUserProfile extends StatefulWidget {
  const CurrentUserProfile({super.key});

  @override
  State<CurrentUserProfile> createState() => _CurrentUserProfileState();
}

class _CurrentUserProfileState extends State<CurrentUserProfile> {
  @override
  Widget build(BuildContext context) {
    FFrameUser? fFrameUser = Fframe.of(context)?.user;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
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
                child: Text("timeStamp"),
              ),
              Expanded(
                flex: 3,
                child: Text(getSlug("${fFrameUser?.timeStamp?.toLocal()}")),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton.icon(
              icon: const Icon(Icons.list, size: 18),
              label: const Padding(
                padding: EdgeInsets.only(top: 12, bottom: 12),
                child: Text(
                  "FB TOOLS",
                ),
              ),
              onPressed: () {
                FRouter.of(context).navigateToRoute(context, route: "settings", id: "99-firestore-tools");
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
