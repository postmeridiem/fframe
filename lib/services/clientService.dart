import 'package:fframe/models/client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClientService {
  static String collection = "clients";
  Query<Client> queryStream({required bool active}) {
    return FirebaseFirestore.instance.collection(collection).where("active", isEqualTo: active).withConverter<Client>(
          fromFirestore: (snapshot, _) => Client().fromFirestore(snapshot),
          toFirestore: (Client client, _) => {
            // Map<String,Object> documentData =  {
            //   "active":client.active,
            // }
            // return documentData;
          },
        );
  }

  Stream<DocumentSnapshot<Client>> documentStream({String? documentId}) {
    if (documentId == null) return Stream.empty();
    DocumentReference<Client> documentReference = FirebaseFirestore.instance.collection(collection).doc(documentId).withConverter<Client>(
        fromFirestore: (snapshot, _) => Client().fromFirestore(snapshot),
        toFirestore: (Client client, _) => {
              // Map<String,Object> documentData =  {
              //   "active":client.active,
              // }
              // return documentData;
            });
    return documentReference.snapshots();
  }

  void applyChanges({required Client client, required DocumentReference documentReference}) {
    print("ClientService => applyChanges to ${documentReference.id}");
    documentReference.update(client.toFirestore());
  }
}
