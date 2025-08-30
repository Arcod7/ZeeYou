import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zeeyou/l10n/app_localizations.dart';
import 'package:zeeyou/models/color_shade.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({
    super.key,
    required this.chatCollectionRef,
    this.color,
  });

  final CollectionReference<Map<String, dynamic>> chatCollectionRef;
  final ColorShade? color;

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final FocusNode _focusNode = FocusNode();
  final _messageController = TextEditingController();

  bool _isTextInputEmpty = true;

  @override
  void dispose() {
    _messageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final enteredMessage = _messageController.text;

    if (enteredMessage.trim().isEmpty) {
      return;
    }

    _messageController.clear();

    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    // print(user.uid);
    // print(userData.data());

    widget.chatCollectionRef.add({
      'text': enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData.data()!['username'],
      'userImage': userData.data()!['image_url'],
    });
  }

  @override
  void initState() {
    _messageController.addListener(() {
      setState(() {
        _isTextInputEmpty = _messageController.value.text.isEmpty;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const BorderRadius messageBorder = BorderRadius.only(
      topLeft: Radius.elliptical(50, 30),
      topRight: Radius.elliptical(50, 30),
    );
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => _focusNode.requestFocus(),
      child: Material(
        elevation: 20,
        borderRadius: messageBorder,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: messageBorder,
          ),
          padding:
              const EdgeInsets.only(left: 20, right: 12, bottom: 14, top: 14),
          child: Row(
            children: [
              Expanded(
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(minHeight: 70.0, maxHeight: 140.0),
                  child: TextField(
                    controller: _messageController,
                    focusNode: _focusNode,
                    textCapitalization: TextCapitalization.sentences,
                    autocorrect: true,
                    enableSuggestions: true,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: l10n.sendMessage,
                    ),
                    // onSubmitted: (_) => print("yo le sang"),
                    // onEditingComplete: () => print("hello le s"),
                  ),
                ),
              ),
              IconButton(
                color: _isTextInputEmpty
                    ? Colors.grey[400]
                    : widget.color != null
                        ? widget.color!.primary
                        : Theme.of(context).colorScheme.inversePrimary,
                icon: const Icon(Icons.send),
                onPressed: _submitMessage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
