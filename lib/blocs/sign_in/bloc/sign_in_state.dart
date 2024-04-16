part of 'sign_in_bloc.dart';

@immutable
sealed class SignInState {}

final class SignInInitial extends SignInState {}

final class SignInSuccefulState extends SignInInitial {
  final Map<String, dynamic> user;
  SignInSuccefulState({required this.user});
}

final class SignInErrorState extends SignInInitial {}

final class SignInLoadingState extends SignInInitial {}
