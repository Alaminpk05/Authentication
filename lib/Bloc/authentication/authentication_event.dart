// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'authentication_bloc.dart';

sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class SignUpEvent extends AuthenticationEvent {
  final MyUser user;
  final String password;
  final String email;
  const SignUpEvent(  this.password,
  {
    required this.user,
    required this.email,
  });
}

class SignInEvent extends AuthenticationEvent {
  final String email;
  final String password;

  const SignInEvent( {required this.email, required this.password});
}


class SignOutEvent extends AuthenticationEvent {}
class AccountDeleteEvent extends AuthenticationEvent{}
