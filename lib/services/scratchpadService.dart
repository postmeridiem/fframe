import 'package:fframe/models/scratchpad.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScratchpadService {
  static String collection = "/adminui/scratchpads/collection/";
  Query<Scratchpad> queryStream({required bool active}) {
    return FirebaseFirestore.instance.collection(collection).where("active", isEqualTo: active).withConverter<Scratchpad>(
          fromFirestore: (snapshot, _) => Scratchpad().fromFirestore(snapshot),
          toFirestore: (Scratchpad scratchpad, _) => {
            // Map<String,Object> documentData =  {
            //   "active":scratchpad.active,
            // }
            // return documentData;
          },
        );
  }

  Stream<DocumentSnapshot<Scratchpad>> documentStream({String? documentId}) {
    if (documentId == null) return Stream.empty();
    DocumentReference<Scratchpad> documentReference = FirebaseFirestore.instance.collection(collection).doc(documentId).withConverter<Scratchpad>(
        fromFirestore: (snapshot, _) => Scratchpad().fromFirestore(snapshot),
        toFirestore: (Scratchpad scratchpad, _) => {
              // Map<String,Object> documentData =  {
              //   "active":scratchpad.active,
              // }
              // return documentData;
            });
    return documentReference.snapshots();
  }

  void applyChanges({required Scratchpad scratchpad, required DocumentReference documentReference}) {
    print("ScratchpadService => applyChanges to ${documentReference.id}");
    documentReference.update(scratchpad.toFirestore());
  }
}
