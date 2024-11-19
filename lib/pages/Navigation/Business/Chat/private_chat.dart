import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:main/services/auth.dart';
import 'package:main/services/firestore.dart';

class BusinessPrivateChat extends StatefulWidget {
  final String targetUid;
  final String businessName;
  final String image;

  const BusinessPrivateChat({
    super.key,
    required this.targetUid,
    required this.businessName,
    required this.image,
  });

  @override
  State<BusinessPrivateChat> createState() => _PrivateChatState();
}

class _PrivateChatState extends State<BusinessPrivateChat> {
  late final Stream<QuerySnapshot<Object?>> _messagesToMe =
      FirestoreService(uid: Auth().currentUser()?.uid ?? "")
          .getMessagesFromUser(senderUid: widget.targetUid);
  late final Stream<QuerySnapshot<Object?>> _messagesFromMe =
      FirestoreService(uid: Auth().currentUser()?.uid ?? "")
          .getMessagesToUser(receiverUid: widget.targetUid);
  String _currentMessage = "";
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: const Color.fromARGB(
          255,
          254,
          252,
          247,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 20),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                backgroundImage: widget.image.isNotEmpty
                    ? Image.network(
                        widget.image,
                      ).image
                    : Image.asset("images/background.jpg").image,
              ),
            ),
            Text(widget.businessName),
          ],
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.close,
              color: Color.fromARGB(
                255,
                144,
                238,
                96,
              ),
              size: 42,
            ),
            tooltip: 'Show Snackbar',
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.0),
          child: Container(
            color: const Color.fromARGB(
              255,
              144,
              238,
              96,
            ),
            height: 4.0,
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(
        255,
        254,
        252,
        247,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              flex: 1,
              child: StreamBuilder(
                stream: _messagesToMe,
                builder: (context, toMeSnapshot) {
                  return StreamBuilder(
                    stream: _messagesFromMe,
                    builder: (context, fromMeSnapshot) {
                      if (!toMeSnapshot.hasData && !fromMeSnapshot.hasData) {
                        return const Center(
                          child: Text("Sem mensagens para mostrar..."),
                        );
                      }

                      List<Map<String, dynamic>> allMessages = [
                        ...fromMeSnapshot.data?.docs.map(
                              (e) {
                                return {
                                  "fromMe": true,
                                  "content": e.get("content"),
                                  "timestamp": e.get("timestamp")
                                };
                              },
                            ) ??
                            [],
                        ...toMeSnapshot.data?.docs.map(
                              (e) {
                                return {
                                  "fromMe": false,
                                  "content": e.get("content"),
                                  "timestamp": e.get("timestamp")
                                };
                              },
                            ) ??
                            []
                      ];

                      allMessages.sort(
                        (a, b) {
                          return -a["timestamp"].compareTo(b["timestamp"]);
                        },
                      );

                      return ListView(
                        reverse: true,
                        scrollDirection: Axis.vertical,
                        children: allMessages.map(
                          (e) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Align(
                                alignment: e["fromMe"]
                                    ? Alignment.topRight
                                    : Alignment.topLeft,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: e["fromMe"]
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 300,
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: e["fromMe"]
                                            ? const Color.fromARGB(
                                                255,
                                                124,
                                                235,
                                                68,
                                              )
                                            : Colors.black54,
                                        borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(20),
                                          topRight: const Radius.circular(20),
                                          bottomRight: e["fromMe"]
                                              ? const Radius.circular(0)
                                              : const Radius.circular(20),
                                          bottomLeft: e["fromMe"]
                                              ? const Radius.circular(20)
                                              : const Radius.circular(0),
                                        ),
                                      ),
                                      child: Text(
                                        e["content"],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      DateTime.parse(
                                        e["timestamp"].toDate().toString(),
                                      ).toString(),
                                      style: const TextStyle(
                                          color: Colors.black54),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      );
                    },
                  );
                },
              ),
            ),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Escreva a sua mensagem...",
                labelStyle: const TextStyle(
                  color: Colors.black54,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.bold,
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(
                      255,
                      148,
                      248,
                      102,
                    ),
                    width: 2.0,
                  ),
                  gapPadding: 20,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                focusColor: const Color.fromARGB(
                  255,
                  148,
                  248,
                  102,
                ),
                contentPadding: const EdgeInsets.all(20),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.send_rounded,
                    color: Color.fromARGB(
                      255,
                      144,
                      238,
                      96,
                    ),
                    size: 42,
                  ),
                  onPressed: () async {
                    if (_currentMessage.isNotEmpty) {
                      await FirestoreService(
                              uid: Auth().currentUser()?.uid ?? "")
                          .sendMessage(
                              content: _currentMessage,
                              receiverUid: widget.targetUid);
                    }
                    _controller.clear();
                    setState(() {
                      _currentMessage = "";
                    });
                  },
                ),
              ),
              onChanged: (value) => setState(() {
                _currentMessage = value;
              }),
            )
          ],
        ),
      ),
    );
  }
}
