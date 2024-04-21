import 'dart:async';


import 'package:authentication/Screen/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyPage extends StatefulWidget {
  const VerifyPage({super.key});

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  bool emailverified = false;
  Timer? timer;
  bool cancelResend = true;

  @override
  void initState() {
    super.initState();
    emailverified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!emailverified) {
      sendemailverification();
      timer = Timer.periodic(
          const Duration(seconds: 3), (_) => checkemailverification());
    }
  }

  Future<void> checkemailverification() async {
    await FirebaseAuth.instance.currentUser!.reload();
    if(mounted){
    setState(() {
      emailverified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    }
    
    if (emailverified) timer?.cancel();
  }
  // @override
  // void dispose() {
  //   timer?.cancel();
  //   super.dispose();
  // }

  Future<void> sendemailverification() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() => cancelResend = false);
      Future.delayed(const Duration(seconds: 5));
      setState(()=>cancelResend=true);
    } catch (e) {
      ScaffoldMessenger.of( context)
          .showSnackBar(const SnackBar(content: Text('Verification Error')));
    }
  }

  

  @override
  Widget build(BuildContext context) => emailverified
      ? const HomeScreen()
      : Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.cyan,
            title: const Text('Verification Page'),
          ),
          body: Center(
            child: Column(
              children: [
                ElevatedButton(
                  clipBehavior: Clip.hardEdge,
                  onPressed: cancelResend ? sendemailverification : null,
                  child: Container(
                  color: Colors.cyan,
                    child: const Text('Resend verification')),
                ),
                ElevatedButton(
                  clipBehavior: Clip.hardEdge,
                  onPressed: ()=>FirebaseAuth.instance.signOut(),
                  child: Container(
                  color: Colors.cyan,
                    child: const Text('Cancel')),
                ),
              ],
            ),
          ),
        );
}
