class FirestoreUser {
  final String uid;
  final String name;
  final String phone;
  final String location;

  const FirestoreUser(
      {required this.uid,
      required this.name,
      required this.phone,
      required this.location});
}
