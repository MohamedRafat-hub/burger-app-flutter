import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:food_app/core/network/api_error.dart';
import 'package:food_app/core/utils/pref_helper.dart';
import 'package:food_app/features/auth/data/models/user_model.dart';
import 'package:food_app/features/auth/data/repos/auth_repo.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required this.authRepo}) : super(LoginInitial());
  final AuthRepo authRepo;
  Future<void> login({required String email, required String password}) async {
    emit(LoginLoading());
    final UserModel? user;
    try {
      final user = await authRepo.login(email: email, password: password);
      if (user.token != null) {
        log('token is saved');
        await PrefHelper.saveToken(token: user.token!);
      } else {
        log('Token is not saved');
      }

      emit(LoginSuccess(user));
    } on DioException catch (e) {
      log('Error from Dio');
      emit(LoginFailure(ApiError(message: e.toString())));
    } catch(e)
    {
      log('Error from Catch');
      emit(LoginFailure(ApiError(message: e.toString())));
    }
  }
}
