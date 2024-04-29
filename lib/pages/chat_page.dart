import 'package:chat_app/constants.dart';
import 'package:chat_app/pages/messages.dart';
import 'package:chat_app/widgets/chat_buble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});
  final CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessagesCollection);
  final TextEditingController controller = TextEditingController();

  static String id = 'ChatPage';
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments as String;
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy(kCreatedAt, descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Message> messagesList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messagesList.add(Message.fromJson(snapshot.data!.docs[i]));
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: kPrimaryColor,
              title: const Text(
                'Chat',
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    controller: _controller,
                    itemCount: messagesList.length,
                    itemBuilder: (context, index) {
                      return messagesList[index].id == email
                          ? ChatBuble(
                              message: messagesList[index],
                            )
                          : ChatBubleForFriend(
                              message: messagesList[index],
                            );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Enter your message',
                      suffixIcon: IconButton(
                        onPressed: () {
                          messages.add({
                            kMessage: controller.text,
                            kCreatedAt: DateTime.now(),
                            'id': email
                          });
                          controller.clear();
                          _controller.animateTo(
                            0,
                            curve: Curves.easeIn,
                            duration: const Duration(milliseconds: 500),
                          );
                        },
                        icon: const Icon(Icons.send),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
