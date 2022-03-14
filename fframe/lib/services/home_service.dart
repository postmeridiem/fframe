import 'package:fframe/models/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeService {
  static String collection = "/fframe/pages/collection";

  Query<Home> homeByMakeStream = FirebaseFirestore.instance.collection(collection).withConverter<Home>(
        fromFirestore: (snapshots, _) => Home().fromFirestore(snapshots),
        toFirestore: (home, _) => home.toFirestore(),
      );

  Stream<DocumentSnapshot<Home>> documentStream({String? documentId}) {
    if (documentId == null) return const Stream.empty();
    DocumentReference<Home> documentReference = FirebaseFirestore.instance.collection(collection).doc(documentId).withConverter<Home>(
        fromFirestore: (snapshot, _) => Home().fromFirestore(snapshot),
        toFirestore: (Home customer, _) => {
              // Map<String,Object> documentData =  {
              //   "active":home.active,
              // }
              // return documentData;
            });
    return documentReference.snapshots();
  }

  void applyChanges({required Home home, required DocumentReference documentReference}) {
    print("homeService => applyChanges to ${documentReference.id}");
    documentReference.update(home.toFirestore());
  }
}
