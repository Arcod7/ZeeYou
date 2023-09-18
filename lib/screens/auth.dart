import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:zeeyou/data/staff.dart';
import 'package:zeeyou/tools/text_input_decoration.dart';
import 'package:zeeyou/tools/user_manager.dart';
import 'package:zeeyou/widgets/decoration_circle.dart';
import 'package:zeeyou/widgets/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:zeeyou/widgets/zee_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({
    super.key,
    required this.setCreatingAccount,
  });

  final void Function(bool value) setCreatingAccount;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();

  var _isLogin = false;
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredUserName = '';
  var _isAuthenticating = false;
  File? _selectedImage;

  _createAccountInFirebase(UserCredential userCredentials, String username,
      String userEmail, String userImageUrl) async {
    final userDocumentRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userCredentials.user!.uid);

    await userDocumentRef.set({
      'username': username,
      'email': userEmail,
      'image_url': userImageUrl,
      'created_at': Timestamp.now(),
    });
    widget.setCreatingAccount(false);
    await userDocumentRef.collection('staff_chat').add({
      'text': staffChatWelcomeMessage,
      'createdAt': Timestamp.now(),
      'userId': adminUid,
      'username': 'Antoine',
      'userImage': defaultUserImageUrl,
    });
  }

  void _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    try {
      setState(() {
        _isAuthenticating = true;
      });
      if (_isLogin) {
        await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
      } else {
        widget.setCreatingAccount(true);
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredentials.user!.uid}.jpg');

        await storageRef.putFile(_selectedImage!);
        final imageUrl = await storageRef.getDownloadURL();

        await _createAccountInFirebase(
            userCredentials, _enteredUserName, _enteredEmail, imageUrl);
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        // ...
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message ?? l10n.failedToConnect)));
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  _signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    final userCredentials = await _firebase.signInWithCredential(credential);

    final userDocumentRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userCredentials.user!.uid);

    final userDocument = await userDocumentRef.get();
    if (userDocument.data() == null) {
      String userImageUrl = gUser.photoUrl ?? defaultUserImageUrl;
      String username = gUser.displayName ?? gUser.email.split('@')[0];
      await _createAccountInFirebase(
          userCredentials, username, gUser.email, userImageUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Stack(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        children: [
          const Positioned(
            top: 185,
            left: -100,
            child: DecorationCircle(),
          ),
          const Positioned(
            bottom: 40,
            right: -50,
            child: DecorationCircle(),
          ),
          Positioned.fill(
              top: 100,
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(_isLogin ? l10n.connection : l10n.createAccount,
                    style: Theme.of(context).textTheme.headlineLarge!),
              )),
          Center(
            child: SingleChildScrollView(
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35)),
                margin: const EdgeInsets.only(
                  left: 35,
                  right: 35,
                  top: 120,
                ),
                child: Container(
                  // alignment: Alignment.center,
                  // height: 550,
                  padding: const EdgeInsets.all(28),
                  child: Form(
                    key: _form,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        if (_isLogin)
                          Text(
                            l10n.howGoodMemory,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        if (_isLogin) const SizedBox(height: 20),
                        if (!_isLogin)
                          UserImagePicker(
                            onPickImage: (image) => _selectedImage = image,
                          ),
                        if (!_isLogin)
                          TextFormField(
                            decoration: textInputDecoration(l10n.username),
                            enableSuggestions: false,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim().length < 4) {
                                return l10n.minLetter(4);
                              }
                              return null;
                            },
                            onSaved: (value) => _enteredUserName = value!,
                          ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: textInputDecoration(l10n.email),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains('@')) {
                              return l10n.validEmailPlease;
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredEmail = value!;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: textInputDecoration(l10n.password),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.trim().length < 6) {
                              return l10n.minLetter(6);
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredPassword = value!;
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        if (_isAuthenticating)
                          const CircularProgressIndicator(),
                        if (!_isAuthenticating)
                          ZeeButton(
                              text: _isLogin ? l10n.connection : l10n.register,
                              onPressed: _submit),
                        if (!_isAuthenticating)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                            child: Text(_isLogin
                                ? l10n.createAccount
                                : l10n.alreadyHaveAccount),
                          ),
                        TextButton.icon(
                          onPressed: _signInWithGoogle,
                          icon: Icon(MdiIcons.google),
                          label: Text('Sign in with Google'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Positioned(
          //   bottom: 40,
          //   left: 40,
          //   child: TextButton.icon(
          //       icon: const Icon(Icons.send),
          //       label: const Text('Admin'),
          //       onPressed: () async {
          //         setState(() {
          //           _isAuthenticating = true;
          //         });
          //         await _firebase.signInWithEmailAndPassword(
          //           email: 'test@gmail.com',
          //           password: 'test1234',
          //         );
          //         setState(() {
          //           _isAuthenticating = false;
          //         });
          //       }),
          // ),
          // Positioned(
          //   bottom: 40,
          //   right: 40,
          //   child: TextButton.icon(
          //       icon: const Icon(Icons.send),
          //       label: const Text('Malek'),
          //       onPressed: () async {
          //         setState(() {
          //           _isAuthenticating = true;
          //         });
          //         await _firebase.signInWithEmailAndPassword(
          //           email: 'malek@gmail.com',
          //           password: 'maleklpb',
          //         );
          //         setState(() {
          //           _isAuthenticating = false;
          //         });
          //       }),
          // ),
        ],
      ),
    );
  }
}
