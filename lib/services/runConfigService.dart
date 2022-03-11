import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fframe/models/runConfig.dart';

class RunConfigService {
  static String collection = "runconfigs";
  Query<RunConfig> queryStream({required bool active}) {
    return FirebaseFirestore.instance.collection(collection).withConverter<RunConfig>(
          fromFirestore: (snapshot, _) => RunConfig().fromFirestore(snapshot),
          toFirestore: (RunConfig runConfig, _) => {
            // Map<String,Object> documentData =  {
            //   "active":client.active,
            // }
            // return documentData;
          },
        );
  }

  Stream<DocumentSnapshot<RunConfig>> documentStream({String? documentId}) {
    if (documentId == null) return Stream.empty();
    DocumentReference<RunConfig> documentReference = FirebaseFirestore.instance.collection(collection).doc(documentId).withConverter<RunConfig>(
        fromFirestore: (snapshot, _) => RunConfig().fromFirestore(snapshot),
        toFirestore: (RunConfig runConfig, _) => {
              // Map<String,Object> documentData =  {
              //   "active":client.active,
              // }
              // return documentData;
            });
    return documentReference.snapshots();
  }

  void applyChanges({required RunConfig runConfig, required DocumentReference documentReference}) {
    print("RunConfigService => applyChanges to ${documentReference.id}");
    documentReference.update(runConfig.toFirestore());
  }
}
