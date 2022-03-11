import 'package:fframe/models/suggestion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SuggestionService {
  static String collection = "/adminui/suggestions/collection/";
  Query<Suggestion> queryStream({required bool active}) {
    return FirebaseFirestore.instance.collection(collection).where("active", isEqualTo: active).withConverter<Suggestion>(
          fromFirestore: (snapshot, _) => Suggestion().fromFirestore(snapshot),
          toFirestore: (Suggestion suggestion, _) => {
            // Map<String,Object> documentData =  {
            //   "active":suggestion.active,
            // }
            // return documentData;
          },
        );
  }

  Stream<DocumentSnapshot<Suggestion>> documentStream({String? documentId}) {
    if (documentId == null) return Stream.empty();
    DocumentReference<Suggestion> documentReference = FirebaseFirestore.instance.collection(collection).doc(documentId).withConverter<Suggestion>(
        fromFirestore: (snapshot, _) => Suggestion().fromFirestore(snapshot),
        toFirestore: (Suggestion suggestion, _) => {
              // Map<String,Object> documentData =  {
              //   "active":suggestion.active,
              // }
              // return documentData;
            });
    return documentReference.snapshots();
  }

  void applyChanges({required Suggestion suggestion, required DocumentReference documentReference}) {
    print("SuggestionService => applyChanges to ${documentReference.id}");
    documentReference.update(suggestion.toFirestore());
  }
}