import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:food_app/core/network/api_error.dart';
import 'package:food_app/core/utils/pref_helper.dart';
import 'package:food_app/features/auth/data/models/user_model.dart';
import 'package:food_app/features/auth/data/repos/auth_repo.dart';
import 'package:meta/meta.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit({required this.authRepo}) : super(SignupInitial());

  final AuthRepo authRepo;

  Future<void> signup(
      {required String name,
      required String email,
      required String password}) async {
    emit(SignupLoading());
    UserModel? user;
    try {
      user =
      await authRepo.register(name: name, email: email, password: password);
      if (user.token != null) {
        log('Token is Saved');
        PrefHelper.saveToken(token: user.token!);
      }

      emit(SignupSuccess(user));
    } catch(e)
    {
      log('Sign up error is : => $e');
      emit(SignupFailure(ApiError(message: e.toString())));
    }
  }
}
