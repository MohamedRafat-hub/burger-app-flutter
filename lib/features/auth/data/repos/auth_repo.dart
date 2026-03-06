import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:food_app/core/network/api_error.dart';
import 'package:food_app/core/network/api_exceptions.dart';
import 'package:food_app/core/network/api_service.dart';
import 'package:food_app/core/utils/pref_helper.dart';
import 'package:food_app/features/auth/data/models/user_model.dart';

class AuthRepo {
  final ApiService apiService;

  AuthRepo({required this.apiService});

  static bool isGuest = false;
  static UserModel? authUser;


  /// Login
  Future<UserModel> login(
      {required String email, required String password}) async {
    Response? response;
    try {
      response = await apiService.post('/login', {
        'email': email,
        'password': password,
      });
      log(response.data.toString());
      UserModel userModel = UserModel.fromJson(response.data['data']);
      isGuest = false;
      authUser = userModel;
      return userModel;
    } on DioException catch (e) {
      log('login error is => $e');
      throw ApiExceptions.apiHandler(e);
    } catch (e) {
      log('login error is => $e');
      throw ApiError(message: e.toString());
    }
  }


  /// Register
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    Response? response;
    try {
      response = await apiService.post('/register', {
        'name': name,
        'email': email,
        'password': password,
      });
      log('Register response ${response.data.toString()}');
      UserModel userModel = UserModel.fromJson(response.data['data']);
      isGuest = false;
      authUser = userModel;
      return userModel;
    } on DioException catch (e) {
      throw ApiExceptions.apiHandler(e);
    } catch (e) {
      log('e is $e');
      throw ApiError(message: e.toString());
    }
  }


  /// getProfileData
  Future<UserModel?> getProfileData() async {
    final token = PrefHelper.getToken();
    if (token == null || token == 'guest') {
      return null;
    }
    final Response response = await apiService.get(endPoint: '/profile');
    if (response.statusCode == 200 || response.statusCode == 201) {
      isGuest = false;
      authUser = UserModel.fromJson(response.data['data']);
    }
    return UserModel.fromJson(response.data['data']);
  }


  /// Update Profile
  Future<UserModel> updateProfile({required UserModel userModel}) async {
    final Map<String, dynamic> data = {
      'name': userModel.name,
      'email': userModel.email,
      'address': userModel.address,
    };

    if (userModel.visa != null && userModel.visa!.isNotEmpty) {
      data['Visa'] = userModel.visa;
    }

    if (userModel.image != null &&
        userModel.image!.isNotEmpty &&
        !userModel.image!.startsWith('http')) {
      data['image'] = await MultipartFile.fromFile(
        userModel.image!,
        filename: userModel.image!.split('/').last,
      );
    }

    final formData = FormData.fromMap(data);

    final Response response =
    await apiService.post('/update-profile', formData);

    if (response.statusCode == 200 || response.statusCode == 201) {
      isGuest = false;
      authUser = UserModel.fromJson(response.data['data']);
    }

    return UserModel.fromJson(response.data['data']);
  }


  /// Logout
  Future<void> logout() async {
    final response = await apiService.post('logout', {});
    if (response.statusCode == 200 || response.statusCode == 201) {
      isGuest = true;
      authUser = null;
    }
  }


  Future<void> continueAsGuest() async{
    isGuest = true;
    authUser = null;
    await PrefHelper.saveToken(token: 'guest');
  }



  Future<UserModel?>autoLogin() async
  {

    final token = PrefHelper.getToken();
    log('auto login token is $token');
    if( token =='guest')
      {
        isGuest = true;
        authUser = null;
        return null;
      }
    isGuest = false;

    try {
      final UserModel? user = await getProfileData();
      log('auto login user name is ${user?.name}');
      authUser = user;
      return user;
    } catch (e) {
      log('auto login user error $e');
      await PrefHelper.removeToken();
      authUser = null;
      return null;
    }
  }


  bool get isLoggedIn => !isGuest && authUser !=null;
}
