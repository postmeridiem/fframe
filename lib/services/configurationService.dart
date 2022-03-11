import 'package:fframe/models/configuration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConfigurationService {
  static String collection = "/adminui/configurations/collection";
  Query<Configuration> queryStream({required bool active}) {
    return FirebaseFirestore.instance.collection(collection).where("active", isEqualTo: active).withConverter<Configuration>(
          fromFirestore: (snapshot, _) => Configuration().fromFirestore(snapshot),
          toFirestore: (Configuration configuration, _) => {
            // Map<String,Object> documentData =  {
            //   "active":configuration.active,
            // }
            // return documentData;
          },
        );
  }

  Stream<DocumentSnapshot<Configuration>> documentStream({String? documentId}) {
    if (documentId == null) return Stream.empty();
    DocumentReference<Configuration> documentReference = FirebaseFirestore.instance.collection(collection).doc(documentId).withConverter<Configuration>(
        fromFirestore: (snapshot, _) => Configuration().fromFirestore(snapshot),
        toFirestore: (Configuration configuration, _) => {
              // Map<String,Object> documentData =  {
              //   "active":configuration.active,
              // }
              // return documentData;
            });
    return documentReference.snapshots();
  }

  void applyChanges({required Configuration configuration, required DocumentReference documentReference}) {
    print("ConfigurationService => applyChanges to ${documentReference.id}");
    documentReference.update(configuration.toFirestore());
  }
}
