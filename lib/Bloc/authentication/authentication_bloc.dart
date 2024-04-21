import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/user_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;
  AuthenticationBloc(this._userRepository)
      : super(AuthenticationInitialState()) {
    on<SignUpEvent>(_signUpEvent);
    on<SignInEvent>(_signInEvent);
    on<SignOutEvent>(_signOutEvent);
    on<AccountDeleteEvent>(_accountDeleteEvent);
  }
  Future<FutureOr<void>> _signUpEvent(
      SignUpEvent event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationProcesingState());
    try {
      MyUser user = await _userRepository.signUp(event.user, event.password);
      await _userRepository
          .setUserData(user)
          .then((value) => emit(AuthenticationSuccessState()));
    } on FirebaseAuthException catch (e) {
      
      if (e.code == 'weak-password') {
        emit(const AuthenticationErrorState(
            errorMessege: 'Password Provided is too weak'));
      }  
      if (e.code == 'email-already-in-use') {
        emit(const AuthenticationErrorState(
            errorMessege: 'Email Provided already Exists'));
      } 
    } catch (e) {
      emit(AuthenticationErrorState(errorMessege: e.toString()));
    }
  }

  Future<FutureOr<void>> _signInEvent(
      SignInEvent event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationProcesingState());
   
    try {
      await _userRepository
          .signIn(event.email, event.password)
          .then((value) => emit(AuthenticationSuccessState()));
    } on FirebaseAuthException catch (e) {
      print(e.code);
      // emit(const AuthenticationErrorState(errorMessege: "Please Check your email and password"));
      if (e.code == 'invalid-credential') {
        emit(const AuthenticationErrorState(
            errorMessege:
                'The supplied auth credential is incorrect, malformed or has expired'));
      } else if (e.code == 'user-not-found') {
        emit(const AuthenticationErrorState(
            errorMessege: 'No user Found with this Email'));
      } else if (e.code == 'wrong-password') {
        emit(const AuthenticationErrorState(
            errorMessege: 'Password did not match'));
      }
      else {
        emit(AuthenticationErrorState(errorMessege: e.toString()));
      }
    } catch (e) {
      emit(AuthenticationErrorState(errorMessege: e.toString()));
    }
  }

  Future<FutureOr<void>> _signOutEvent(
      SignOutEvent event, Emitter<AuthenticationState> emit) async {
    try {
      await _userRepository.logOut();
      emit(LogoutState());
    } catch (e) {
      emit(AuthenticationErrorState(errorMessege: e.toString()));
    }
  }

  Future<FutureOr<void>> _accountDeleteEvent(
      AccountDeleteEvent event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationProcesingState());
    try {
      await FirebaseAuth.instance.currentUser?.delete();
      emit(AccountdeleteState());
    } catch (e) {
      emit(AuthenticationErrorState(errorMessege: e.toString()));
    }
  }
}
