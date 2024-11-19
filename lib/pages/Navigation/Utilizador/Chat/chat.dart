import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:main/helpers/getSnapshopData.dart';
import 'package:main/pages/Navigation/Utilizador/Chat/private_chat.dart';
import 'package:main/services/auth.dart';
import 'package:main/services/firestore.dart';
import 'package:main/services/storage.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final Stream<QuerySnapshot<Object?>> _businesses =
      FirestoreService(uid: Auth().currentUser()!.uid).getAllBusinesses();
  final Stream<QuerySnapshot<Object?>> _messagesToMe =
      FirestoreService(uid: Auth().currentUser()!.uid).getMessagesToMe();
  final Stream<QuerySnapshot<Object?>> _messagesFromMe =
      FirestoreService(uid: Auth().currentUser()!.uid).getMessagesFromMe();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 254, 252, 247),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder(
                stream: _businesses,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: Text("A carregar estabelecimentos..."),
                    );
                  }

                  return SizedBox(
                    height: 150,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: snapshot.data!.docs.map(
                        (business) {
                          final Stream<String> businessImage = StorageService()
                              .getBusinessImage(uid: business.id);

                          return StreamBuilder(
                            stream: businessImage,
                            builder: (context, imageSnapshot) {
                              return SizedBox(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => PrivateChat(
                                                businessName: GetSnapshotData()
                                                    .getUserField(
                                                        snapshotData: business,
                                                        fieldName:
                                                            "business_name"),
                                                targetUid: business.id,
                                                image: imageSnapshot.data ?? "",
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(top: 20),
                                          child: CircleAvatar(
                                            radius: 40,
                                            backgroundColor: Colors.white,
                                            backgroundImage: imageSnapshot
                                                        .data?.isNotEmpty ??
                                                    false
                                                ? Image.network(
                                                    imageSnapshot.data ?? "",
                                                  ).image
                                                : Image.asset(
                                                        "images/background.jpg")
                                                    .image,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        GetSnapshotData().getUserField(
                                          snapshotData: business,
                                          fieldName: "business_name",
                                        ),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ).toList(),
                    ),
                  );
                },
              ),
              const Text(
                "Mensagens",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
              ),
              StreamBuilder(
                stream: _messagesFromMe,
                builder: (context, messagesFromMeSnapshot) {
                  return StreamBuilder(
                    stream: _messagesToMe,
                    builder: (context, messagesToMeSnapshot) {
                      if (!messagesFromMeSnapshot.hasData &&
                          !messagesToMeSnapshot.hasData) {
                        return const Center(
                            child: Text("Não há mensagens para apresentar"));
                      }

                      List<String> allMessages = [
                        ...messagesFromMeSnapshot.data?.docs.map((m) =>
                                GetSnapshotData().getUserField(
                                    snapshotData: m, fieldName: "to_uid")) ??
                            [],
                        ...messagesToMeSnapshot.data?.docs.map((m) =>
                                GetSnapshotData().getUserField(
                                    snapshotData: m, fieldName: "from_uid")) ??
                            []
                      ];

                      Set<dynamic> chats = allMessages.toSet();

                      return Column(
                        children: chats.map(
                          (profileUid) {
                            Stream<DocumentSnapshot<Object?>> targetProfile =
                                FirestoreService(
                                        uid: Auth().currentUser()?.uid ?? "")
                                    .getUserSnapshot(targetUid: profileUid);

                            return StreamBuilder(
                              stream: targetProfile,
                              builder: (context, targetProfileSnapshot) {
                                if (!targetProfileSnapshot.hasData) {
                                  return const Center(
                                    child: Text("A carregar chat..."),
                                  );
                                }

                                Stream<String> targetImageStream =
                                    StorageService().getBusinessImage(
                                        uid: targetProfileSnapshot.data?.id ??
                                            "");

                                return StreamBuilder(
                                  stream: targetImageStream,
                                  builder: (context, targetImageSnapshot) {
                                    return Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 10, 0, 10),
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: 100.0,
                                        child: Stack(
                                          children: [
                                            ElevatedButton(
                                              onPressed: () =>
                                                  Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PrivateChat(
                                                    targetUid: profileUid,
                                                    image: targetImageSnapshot
                                                            .data ??
                                                        "",
                                                    businessName: GetSnapshotData()
                                                        .getUserField(
                                                            snapshotData:
                                                                targetProfileSnapshot
                                                                    .data,
                                                            fieldName:
                                                                "business_name"),
                                                  ),
                                                ),
                                              ),
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(
                                                  const Color.fromARGB(
                                                    255,
                                                    255,
                                                    255,
                                                    255,
                                                  ),
                                                ),
                                                padding: MaterialStateProperty
                                                    .all<EdgeInsets>(
                                                        EdgeInsets.zero),
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20.0),
                                                    ),
                                                  ),
                                                ),
                                                elevation:
                                                    MaterialStateProperty.all(
                                                        5.0),
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20.0),
                                                    ),
                                                    child: Container(
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: targetImageSnapshot
                                                                      .data
                                                                      ?.isEmpty ??
                                                                  false
                                                              ? Image.asset(
                                                                      "images/background.jpg")
                                                                  .image
                                                              : Image.network(
                                                                      targetImageSnapshot
                                                                              .data ??
                                                                          "")
                                                                  .image,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        top: 7,
                                                        bottom: 4,
                                                        left: 20,
                                                        right: 20,
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            GetSnapshotData().getUserField(
                                                                snapshotData:
                                                                    targetProfileSnapshot
                                                                        .data,
                                                                fieldName:
                                                                    "business_name"),
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'Nunito',
                                                              fontSize: 20,
                                                            ),
                                                            textAlign:
                                                                TextAlign.left,
                                                          ),
                                                          const SizedBox(
                                                              height:
                                                                  5), // Espaçamento
                                                          const Text(
                                                            "Restaurante",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'Nunito',
                                                              fontSize: 14,
                                                            ),
                                                            textAlign:
                                                                TextAlign.left,
                                                          ),
                                                          Text(
                                                            GetSnapshotData()
                                                                .getUserField(
                                                                    snapshotData:
                                                                        targetProfileSnapshot
                                                                            .data,
                                                                    fieldName:
                                                                        "address"),
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'Nunito',
                                                              fontSize: 14,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ).toList(),
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
