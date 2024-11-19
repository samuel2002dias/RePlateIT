import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:main/services/auth.dart';

class FirestoreService {
  final String uid;

  FirestoreService({required this.uid});

  final CollectionReference userRef =
      FirebaseFirestore.instance.collection("user-profile");
  final CollectionReference favoritesRef =
      FirebaseFirestore.instance.collection("user-favorites");
  final CollectionReference messagesRef =
      FirebaseFirestore.instance.collection("messages");
  final CollectionReference dishesRef =
      FirebaseFirestore.instance.collection("dish");
  final CollectionReference reservationsRef =
      FirebaseFirestore.instance.collection("reservation");

  Future<void> setUserData({
    required String name,
    required String phone,
  }) async {
    return await userRef.doc(uid).set(
      {
        "name": name,
        "phone": phone,
        "business": false,
      },
    );
  }

  Future<void> updateUserName(String newName) async {
    if (newName.isNotEmpty) {
      return await userRef.doc(uid).update(
        {
          "name": newName,
        },
      );
    }
  }

  Future<void> updateBusinessName(String newName) async {
    if (newName.isNotEmpty) {
      return await userRef.doc(uid).update(
        {
          "business_name": newName,
        },
      );
    }
  }

  Future<void> updateUserLocation(String newLocation) async {
    if (newLocation.isNotEmpty) {
      return await userRef.doc(uid).update(
        {
          "location": newLocation,
        },
      );
    }
  }

  Future<void> updateUserPhoneNumber(String newPhoneNumber) async {
    if (newPhoneNumber.isNotEmpty) {
      return await userRef.doc(uid).update(
        {
          "phone": newPhoneNumber,
        },
      );
    }
  }

  Future<void> setBusinessData({
    required String name,
    required String phone,
    required String address,
  }) async {
    return await userRef.doc(uid).set(
      {
        "business_name": name,
        "phone": phone,
        "address": address,
        "business": true,
      },
    );
  }

  Future<DocumentSnapshot<Object?>> getUserData() async {
    return await userRef.doc(uid).get();
  }

  dynamic addFavorite({
    required String businessUid,
  }) async {
    AggregateQuery count = favoritesRef
        .where("user_uid", isEqualTo: uid)
        .where("business_uid", isEqualTo: businessUid)
        .count();

    AggregateQuerySnapshot snapshot = await count.get();

    if (snapshot.count == 0) {
      return await favoritesRef.add({
        "user_uid": uid,
        "business_uid": businessUid,
      });
    }
  }

  Future<void> removeFavourite({
    required String businessUid,
  }) async {
    Query<Object?> collection = favoritesRef
        .where("user_uid", isEqualTo: uid)
        .where("business_uid", isEqualTo: businessUid);

    QuerySnapshot<Object?> res = await collection.get();

    return res.docs.forEach((e) async {
      await favoritesRef.doc(e.id).delete();
    });
  }

  Future<DocumentReference<Object?>> sendMessage({
    required String content,
    required String receiverUid,
  }) async {
    String senderUid = Auth().currentUser()?.uid ?? "";

    if (senderUid.isEmpty) {
      throw Exception("Não está autenticado");
    }

    return messagesRef.add(
      {
        "from_uid": senderUid,
        "to_uid": receiverUid,
        "content": content,
        "timestamp": DateTime.now(),
      },
    );
  }

  Future<DocumentReference<Object?>> addReservation({
    required String dishUid,
  }) async {
    return reservationsRef.add(
      {
        "client_uid": uid,
        "dish_uid": dishUid,
      },
    );
  }

  Stream<DocumentSnapshot<Object?>> getUserSnapshot({
    String? targetUid,
  }) {
    return userRef.doc(targetUid ?? uid).snapshots();
  }

  Stream<DocumentSnapshot<Object?>> getDishSnapshot({
    required String targetUid,
  }) {
    return dishesRef.doc(targetUid).snapshots();
  }

  Stream<QuerySnapshot<Object?>> getUserFavoritesSnapshot() {
    return favoritesRef.where("user_uid", isEqualTo: uid).snapshots();
  }

  Stream<QuerySnapshot<Object?>> getAllBusinesses() {
    return userRef.where("business", isEqualTo: true).snapshots();
  }

  Stream<QuerySnapshot<Object?>> getBusinessDishes(
      {required String businessUid}) {
    return dishesRef.where("business_uid", isEqualTo: businessUid).snapshots();
  }

  Stream<QuerySnapshot<Object?>> getReservations() {
    return reservationsRef.where("client_uid", isEqualTo: uid).snapshots();
  }

  Stream<QuerySnapshot<Object?>> getMessagesToUser(
      {required String receiverUid}) {
    String currentUserUid = Auth().currentUser()?.uid ?? "";

    if (currentUserUid.isEmpty) {
      throw Exception("Não está autenticado");
    }

    return messagesRef
        .where("to_uid", isEqualTo: receiverUid)
        .where("from_uid", isEqualTo: currentUserUid)
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Object?>> getMessagesFromUser(
      {required String senderUid}) {
    String currentUserUid = Auth().currentUser()?.uid ?? "";

    if (currentUserUid.isEmpty) {
      throw Exception("Não está autenticado");
    }

    return messagesRef
        .where("to_uid", isEqualTo: currentUserUid)
        .where("from_uid", isEqualTo: senderUid)
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Object?>> getMessagesToMe() {
    String currentUserUid = Auth().currentUser()?.uid ?? "";

    if (currentUserUid.isEmpty) {
      throw Exception("Não está autenticado");
    }

    return messagesRef.where("to_uid", isEqualTo: currentUserUid).snapshots();
  }

  Stream<QuerySnapshot<Object?>> getMessagesFromMe() {
    String currentUserUid = Auth().currentUser()?.uid ?? "";

    if (currentUserUid.isEmpty) {
      throw Exception("Não está autenticado");
    }

    return messagesRef.where("from_uid", isEqualTo: currentUserUid).snapshots();
  }
}
