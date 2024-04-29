import 'dart:async';

import 'package:chat_app/constants.dart';
import 'package:chat_app/helper/show_snack_bar.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/pages/regiester_page.dart';
import 'package:chat_app/widgets/buttons.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static String id = 'login page';
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? email;

  String? password;

  bool? isLoading = false;

  GlobalKey<FormState> formKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: false,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: kPrimaryColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Form(
            key: formKey,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset('assets/images/scholar.png', height: 100),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Scholar Chat',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontFamily: 'Pacifico'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 100),
                    const Row(
                      children: [
                        Text(
                          'LOGIN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      onChanged: (data) {
                        email = data;
                      },
                      hintText: ' Email',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      obscureText: true,
                      onChanged: (data) {
                        password = data;
                      },
                      hintText: ' Password',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Button(
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          isLoading = true;
                          if (mounted) setState(() {});
                          try {
                            await loginUser();
                            Navigator.pushNamedAndRemoveUntil(
                                _scaffoldKey.currentContext!,
                                ChatPage.id,
                                arguments: email!,
                                (route) => false);
                          } on FirebaseAuthException catch (ex) {
                            if (ex.code == 'user not found') {
                              showSnackBar(_scaffoldKey.currentContext!,
                                  'weak-password');
                            } else if (ex.code == 'Wrong password') {
                              showSnackBar(_scaffoldKey.currentContext!,
                                  'email already exists');
                            }
                            if (mounted) {
                              isLoading = false;
                              setState(() {});
                            }
                          } catch (ex) {
                            showSnackBar(_scaffoldKey.currentContext!,
                                'there was an error');
                          }
                        } else {}
                      },
                      text: 'Login',
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Dont Have an Acoount?',
                          style: TextStyle(color: Colors.white),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, const RegisterPage().id);
                          },
                          child: const Text(
                            'Sign up',
                            style: TextStyle(color: Color(0xffC7EDE6)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginUser() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
  }
}
