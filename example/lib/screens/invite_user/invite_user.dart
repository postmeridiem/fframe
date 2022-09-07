import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class InviteUser extends StatefulWidget {
  const InviteUser({Key? key}) : super(key: key);

  @override
  State<InviteUser> createState() => _InviteUserState();
}

class _InviteUserState extends State<InviteUser> {
  final _formKey = GlobalKey<FormState>();
  UserInviteState userInviteState = UserInviteState.clickable;
  Widget userInviteButton = const IgnorePointer();
  String? emailAddress;

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      emailAddress = null;
      return 'Enter an email address';
    } else if (!EmailValidator.validate(value)) {
      emailAddress = null;
      return 'Enter a valid email address';
    } else {
      emailAddress = value;
      return null;
    }
  }

  void inviteUser() {
    var acs = ActionCodeSettings(
      // URL you want to redirect back to. The domain (www.example.com) for this
      // URL must be whitelisted in the Firebase Console.
      url: 'https://fframe.page.link/acceptinvitation',
      // This must be true
      handleCodeInApp: true,
      iOSBundleId: 'example.fframe.app',
      androidPackageName: 'example.fframe.app',
      // installIfNotAvailable
      androidInstallApp: true,
      // minimumVersion
      androidMinimumVersion: '12',
    );

    FirebaseAuth.instance.sendSignInLinkToEmail(email: emailAddress!, actionCodeSettings: acs).catchError((onError) {
      debugPrint('Error sending email verification $onError');
      setState(() {
        userInviteState = UserInviteState.error;
      });
    }).then((value) {
      debugPrint('Successfully sent email verification to $emailAddress');
      setState(() {
        userInviteState = UserInviteState.clickable;
      });
    });

    // return UserInviteState.clickable;
  }

  @override
  Widget build(BuildContext context) {
    switch (userInviteState) {
      case UserInviteState.clickable:
        userInviteButton = ElevatedButton.icon(
          onPressed: () {
            // Validate returns true if the form is valid, or false otherwise.
            FormState formState = _formKey.currentState!;
            if (formState.validate()) {
              setState(() {
                userInviteState = UserInviteState.waiting;
              });
              inviteUser();
            }
          },
          icon: const Icon(Icons.person_add),
          label: const Text('Invite user'),
        );
        break;
      case UserInviteState.waiting:
        userInviteButton = ElevatedButton.icon(
          icon: const CircularProgressIndicator(),
          label: const Text(''),
          onPressed: null,
        );
        break;
      case UserInviteState.error:
        userInviteButton = ElevatedButton.icon(
          icon: const Icon(
            Icons.error,
            color: Colors.redAccent,
          ),
          label: const Text('Error'),
          onPressed: null,
        );
        break;
    }

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Invite a new user "),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    enabled: UserInviteState.clickable == userInviteState,
                    initialValue: 'arno@zwaag.net',
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      // errorText: "Please enter a valid email address",
                    ),
                    textCapitalization: TextCapitalization.none,
                    validator: validateEmail,
                  ),
                ),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: userInviteButton,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

enum UserInviteState {
  clickable,
  waiting,
  error,
}
