import 'package:cloud_firestore/cloud_firestore.dart';

class GetSnapshotData {
// String getQueryField({
//     required QuerySnapshot<Object?> snapshotData,
//     required String fieldName,
//     String? fallbackString,
//   }) {
//     try {
//       return snapshotData.docs[0].da ?.get(fieldName);
//     } catch (_) {
//       return fallbackString ?? "Não definido";
//     }
//   }

  dynamic getUserField({
    required DocumentSnapshot<Object?>? snapshotData,
    required String fieldName,
    String? fallbackString,
  }) {
    try {
      return snapshotData?.get(fieldName);
    } catch (_) {
      return fallbackString ?? "Não definido";
    }
  }
}
