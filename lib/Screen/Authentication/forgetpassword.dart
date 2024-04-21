import 'package:authentication/Screen/Authentication/component/my_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text("Forget Password Page"),
      ),
      body: Center(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: MyTextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              hintText: 'email',
              obscureText: false,
            ),
          ),
          20.heightBox,
          ElevatedButton(
              onPressed: () {
                try {
                  FirebaseAuth.instance
                      .sendPasswordResetEmail(email: emailController.text);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content:
                          Text("Password Reset mail sent to your mail box")));
                          
                } catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
              child: const Text('Save'))
        ],
      )),
    );
  }
}
