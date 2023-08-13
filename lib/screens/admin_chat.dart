import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zeeyou/data/staff.dart';
import 'package:zeeyou/screens/chat.dart';

class AdminChatScreen extends StatelessWidget {
  const AdminChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin chat'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collectionGroup('staff_chat')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshots.hasData) {
            return const Center(
              child: Text("Pas de chat admin pour l'instant"),
            );
          }

          if (snapshots.hasError) {
            return Center(
              child: Text('Ya un prb là frr, ${snapshots.error.toString()}'),
            );
          }

          final loadedChats = snapshots.data!.docs;

          return ListView.builder(
              itemCount: loadedChats.length,
              itemBuilder: (ctx, index) {
                final loadedMessage = loadedChats[index];

                if (loadedMessage.data()['text'] == staffChatWelcomeMessage) {
                  return const SizedBox();
                }

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      loadedMessage.data()['userImage'],
                    ),
                  ),
                  title: Text(
                    loadedMessage.data()['text'],
                  ),
                  subtitle: Text(loadedMessage.data()['username']),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => ChatScreen(
                          title: 'Staff',
                          chatCollectionRef: FirebaseFirestore.instance
                              .collection('users')
                              .doc(loadedMessage.reference.path.split('/')[1])
                              .collection('staff_chat'),
                        ),
                      ),
                    );
                  },
                );
              });
        },
      ),
    );
  }
}
