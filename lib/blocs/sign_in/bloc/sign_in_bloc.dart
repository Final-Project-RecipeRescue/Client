import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:reciperescue_client/controllers/auth_controller.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc() : super(SignInInitial()) {
    on<GetUserEvent>(fetchUserData);
  }

  FutureOr<void> fetchUserData(
      GetUserEvent event, Emitter<SignInState> emit) async {
    emit(SignInLoadingState());
    Map<String, dynamic> user = await AuthController.instance.getUser();
    emit(SignInSuccefulState(user: user));
  }
}
