import 'package:authentication/Bloc/authentication/authentication_bloc.dart';
import 'package:authentication/Screen/Authentication/verifypage.dart';

import 'package:authentication/Screen/welcome_screen.dart';
import 'package:authentication/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp(
    userRepository: FirebaseUserRepo(),
  ));
}

class MyApp extends StatelessWidget {
  final UserRepository userRepository;
  
  const MyApp({super.key, required this.userRepository, });

  @override
  Widget build(BuildContext context) {
    
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthenticationBloc(userRepository)),
      ],
      child: MaterialApp(
        title: 'Authentication',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const VerifyPage();
              } else {
                return const WelcomeScreen();
              }
            }),
      ),
    );
  }
}
