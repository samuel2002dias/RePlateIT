import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final storage =
      FirebaseStorage.instanceFor(bucket: "gs://replate-it-dd479.appspot.com");

  dynamic uploadUserImage({
    required File file,
    required String uid,
  }) async {
    final Reference storageRef = storage.ref();
    final Reference imagesRef = storageRef.child("/user_images/$uid");

    return await imagesRef.putFile(file);
  }

  dynamic uploadBusinessImage({
    required File file,
    required String uid,
  }) async {
    final Reference storageRef = storage.ref();
    final Reference imagesRef = storageRef.child("/business_images/$uid");

    return await imagesRef.putFile(file);
  }

  dynamic uploadDishImage({
    required File file,
    required String uid,
  }) async {
    final Reference storageRef = storage.ref();
    final Reference imagesRef = storageRef.child("/dish_images/$uid");

    return await imagesRef.putFile(file);
  }

  Stream<String> getUserImage({required String uid}) {
    final Reference storageRef = storage.ref();
    final Reference imageRef = storageRef.child("user_images/$uid");

    return imageRef.getDownloadURL().asStream();
  }

  Stream<String> getBusinessImage({required String uid}) {
    final Reference storageRef = storage.ref();
    final Reference imageRef = storageRef.child("business_images/$uid");

    return imageRef.getDownloadURL().asStream();
  }

  Stream<String> getDishImage({required String uid}) {
    final Reference storageRef = storage.ref();
    final Reference imageRef = storageRef.child("dish_images/$uid");

    return imageRef.getDownloadURL().asStream();
  }
}
