import 'package:fframe_demo/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  static String collection = "users";

  Query<User> userByMakeStream = FirebaseFirestore.instance.collection(collection).orderBy('name').withConverter<User>(
        fromFirestore: (snapshots, _) => User().fromFirestore(snapshots),
        toFirestore: (user, _) => user.toFirestore(),
      );

  Stream<DocumentSnapshot<User>> documentStream({String? documentId}) {
    if (documentId == null) return const Stream.empty();
    DocumentReference<User> documentReference = FirebaseFirestore.instance.collection(collection).doc(documentId).withConverter<User>(
        fromFirestore: (snapshot, _) => User().fromFirestore(snapshot),
        toFirestore: (User customer, _) => {
              // Map<String,Object> documentData =  {
              //   "active":user.active,
              // }
              // return documentData;
            });
    return documentReference.snapshots();
  }

  void applyChanges({required User user, required DocumentReference documentReference}) {
    documentReference.update(user.toFirestore());
  }
}
