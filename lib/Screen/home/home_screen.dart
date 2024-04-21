// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:authentication/Bloc/authentication/authentication_bloc.dart';
import 'package:authentication/Screen/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  //  final MyUser user;

  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is LogoutState) {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const WelcomeScreen()));
        }
        if (state is AccountdeleteState) {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const WelcomeScreen()));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyan,
          title: const Text("Welcome Home"),
          actions: [
            IconButton(
                onPressed: () {
                  context.read<AuthenticationBloc>().add(SignOutEvent());
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body: Center(
          child: Column(
            children: [
              Text(
                "Welcome to the Home ${auth.currentUser?.displayName}",
                style: const TextStyle(color: Colors.black, fontSize: 20.0),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  context.read<AuthenticationBloc>().add(AccountDeleteEvent());
                },
                icon: const Icon(Icons.delete_rounded),
                label: const Text('Delete Account'),
              ),
              FirebaseAuth.instance.currentUser != null
                  ? Text("${FirebaseAuth.instance.currentUser?.email}")
                  : const Text("null"),
            ],
          ),
        ),
      ),
    );
  }
}
