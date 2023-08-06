import 'dart:io';

import 'package:zeeyou/tools/text_input_decoration.dart';
import 'package:zeeyou/widgets/decoration_circle.dart';
import 'package:zeeyou/widgets/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:zeeyou/widgets/zee_button.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();

  var _isLogin = true;
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredUserName = '';
  var _isAuthenticating = false;
  File? _selectedImage;

  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid || !_isLogin && _selectedImage == null) {
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
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredentials.user!.uid}.jpg');

        await storageRef.putFile(_selectedImage!);
        final imageUrl = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set({
          'username': _enteredUserName,
          'email': _enteredEmail,
          'image_url': imageUrl,
        });
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        // ...
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error.message ?? "T'as pas réussi à te co haha")));
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(_isLogin ? 'Se connecter' : 'Créer un compte',
                      style: Theme.of(context).textTheme.displaySmall!),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35)),
                    margin: const EdgeInsets.only(
                      left: 35,
                      right: 35,
                      top: 80,
                    ),
                    child: SingleChildScrollView(
                      child: Container(
                        alignment: Alignment.center,
                        height: 550,
                        padding: const EdgeInsets.all(28),
                        child: Form(
                          key: _form,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              if (_isLogin) const SizedBox(height: 200),
                              if (!_isLogin)
                                UserImagePicker(
                                  onPickImage: (pickedImage) {
                                    _selectedImage = pickedImage;
                                  },
                                ),
                              if (!_isLogin)
                                TextFormField(
                                  decoration:
                                      textInputDecoration("Nom d'utilisateur"),
                                  enableSuggestions: false,
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        value.trim().length < 4) {
                                      return '4 lettres minimum stp';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _enteredUserName = value!;
                                  },
                                ),
                              TextFormField(
                                decoration: textInputDecoration('Adresse Mail'),
                                keyboardType: TextInputType.emailAddress,
                                autocorrect: false,
                                textCapitalization: TextCapitalization.none,
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().isEmpty ||
                                      !value.contains('@')) {
                                    return "Merci d'entrer une adresse mail valide";
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _enteredEmail = value!;
                                },
                              ),
                              TextFormField(
                                decoration: textInputDecoration('Mot de passe'),
                                obscureText: true,
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().length < 6) {
                                    return 'Minimum 6 caractères (Conseil : "bonjour" comme ça il y en a 7)';
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
                                    text: _isLogin
                                        ? "Se connecter"
                                        : "S'inscrire",
                                    onPressed: _submit),
                              if (!_isAuthenticating)
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _isLogin = !_isLogin;
                                    });
                                  },
                                  child: Text(_isLogin
                                      ? 'Créer un compte'
                                      : "J'ai déjà un compte"),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            right: 40,
            child: IconButton(
                iconSize: 30,
                icon: const Icon(Icons.send),
                onPressed: () async {
                  setState(() {
                    _isAuthenticating = true;
                  });
                  await _firebase.signInWithEmailAndPassword(
                    email: 'test@gmail.com',
                    password: '***REMOVED***',
                  );
                  setState(() {
                    _isAuthenticating = false;
                  });
                }),
          ),
        ],
      ),
    );
  }
}
