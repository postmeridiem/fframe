import 'package:fframe_demo/models/suggestion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SuggestionService {
  static String collection = "suggestions";
  Query<Suggestion> queryStream() {
    return FirebaseFirestore.instance.collection(collection).withConverter<Suggestion>(
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
    if (documentId == null) return const Stream.empty();
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
    documentReference.update(suggestion.toFirestore());
  }
}
