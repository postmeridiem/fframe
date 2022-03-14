import 'package:fframe/models/setting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingService {
  static String collection = "/fframe/settings/collection/";
  Query<Setting> queryStream() {
    return FirebaseFirestore.instance.collection(collection).withConverter<Setting>(
          fromFirestore: (snapshot, _) => Setting().fromFirestore(snapshot),
          toFirestore: (Setting setting, _) => {
            // Map<String,Object> documentData =  {
            //   "active":setting.active,
            // }
            // return documentData;
          },
        );
  }

  Stream<DocumentSnapshot<Setting>> documentStream({String? documentId}) {
    if (documentId == null) return const Stream.empty();
    DocumentReference<Setting> documentReference = FirebaseFirestore.instance.collection(collection).doc(documentId).withConverter<Setting>(
        fromFirestore: (snapshot, _) => Setting().fromFirestore(snapshot),
        toFirestore: (Setting setting, _) => {
              // Map<String,Object> documentData =  {
              //   "active":setting.active,
              // }
              // return documentData;
            });
    return documentReference.snapshots();
  }

  void applyChanges({required Setting setting, required DocumentReference documentReference}) {
    print("SettingService => applyChanges to ${documentReference.id}");
    documentReference.update(setting.toFirestore());
  }
}
