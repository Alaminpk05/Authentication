part of 'authentication_bloc.dart';

sealed class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

final class AuthenticationInitialState extends AuthenticationState {}
final class AuthenticationProcesingState extends AuthenticationState {}
final class AuthenticationLogoutState extends AuthenticationState {}
final class AuthenticationSuccessState extends AuthenticationState {}
final class LogoutState extends AuthenticationState {}
final class AccountdeleteState extends AuthenticationState {}

final class AuthenticationErrorState extends AuthenticationState {
   final String errorMessege;

  const AuthenticationErrorState({required this.errorMessege});
}
