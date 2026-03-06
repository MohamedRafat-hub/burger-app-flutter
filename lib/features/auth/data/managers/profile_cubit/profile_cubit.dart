import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:food_app/core/network/api_error.dart';
import 'package:food_app/core/utils/pref_helper.dart';
import 'package:food_app/features/auth/data/models/user_model.dart';
import 'package:food_app/features/auth/data/repos/auth_repo.dart';
import 'package:meta/meta.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required this.authRepo}) : super(ProfileInitial());

  final AuthRepo authRepo;

  /// get Profile Data
  Future<void> getProfileData() async {
    emit(ProfileLoading());
    try {
      final userModel = await authRepo.getProfileData();
      emit(ProfileSuccess(userModel: userModel));
    } catch (e) {
      emit(ProfileFailure(ApiError(message: e.toString())));
    }
  }





  /// Update Profile
  Future<void> updateProfile({required UserModel user}) async {
    emit(ProfileLoading());
    try {
      final UserModel updateUser = await authRepo.updateProfile(
        userModel: user,
      );
      emit(ProfileSuccess(userModel: updateUser));
    } catch (e) {
      emit(ProfileFailure(ApiError(message: e.toString())));
    }
  }






  /// Logout
  Future<void>logout() async
  {
    emit(ProfileLoading());
    try {
      await authRepo.logout();
      emit(ProfileSuccess());
    } catch (e) {
      emit(ProfileFailure(ApiError(message: e.toString())));
    }
  }
}
