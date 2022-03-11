import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fframe/models/run.dart';

class RunService {
  static String collection = "runs";
  Query<Run> queryStream({required bool active}) {
    return FirebaseFirestore.instance.collection(collection).where("active", isEqualTo: active).withConverter<Run>(
          fromFirestore: (snapshot, _) => Run().fromFirestore(snapshot),
          toFirestore: (Run run, _) => {
            // Map<String,Object> documentData =  {
            //   "active":client.active,
            // }
            // return documentData;
          },
        );
  }

  Stream<DocumentSnapshot<Run>> documentStream({String? documentId}) {
    if (documentId == null) return Stream.empty();
    DocumentReference<Run> documentReference = FirebaseFirestore.instance.collection(collection).doc(documentId).withConverter<Run>(
        fromFirestore: (snapshot, _) => Run().fromFirestore(snapshot),
        toFirestore: (Run run, _) => {
              // Map<String,Object> documentData =  {
              //   "active":client.active,
              // }
              // return documentData;
            });
    return documentReference.snapshots();
  }

  void applyChanges({required Run run, required DocumentReference documentReference}) {
    print("RunService => applyChanges to ${documentReference.id}");
    documentReference.update(run.toFirestore());
  }
}
