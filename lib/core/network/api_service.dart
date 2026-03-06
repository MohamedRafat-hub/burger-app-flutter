import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:food_app/core/network/api_error.dart';
import 'package:food_app/core/network/api_exceptions.dart';
import 'package:food_app/core/network/dio_client.dart';

//
// class ApiService {
//   final DioClient _dioClient = DioClient();
//
//   /// get
//   Future<Response> get(String endPoint) async {
//     try {
//       final Response response = await _dioClient.dio.get(endPoint);
//       return response;
//     } on DioException catch (e) {
//       throw ApiExceptions.apiHandler(e);
//     } catch (e) {
//       throw ApiError(message: e.toString());
//     }
//   }
//
//   /// post
//   Future<Response> post(String endPoint, Map<String, dynamic> data) async {
//     try {
//       final Response response = await _dioClient.dio.post(endPoint, data: data);
//       return response;
//     } on DioException catch (e) {
//       throw ApiExceptions.apiHandler(e);
//     } catch (e) {
//       throw ApiError(message: e.toString());
//     }
//   }
//
//   /// put
//   Future<dynamic> put(String endPoint, Map<String, dynamic> data) async {
//     try {
//       final Response response = await _dioClient.dio.put(endPoint, data: data);
//       return response;
//     } on DioException catch (e) {
//       return ApiExceptions.apiHandler(e);
//     } catch (e) {
//       return ApiError(message: e.toString());
//     }
//   }
//
//
//   ///delete
//   Future<dynamic> delete(String endPoint, Map<String, dynamic> data) async {
//     try {
//       final Response response = await _dioClient.dio.delete(endPoint, data: data);
//       return response;
//     } on DioException catch (e) {
//       return ApiExceptions.apiHandler(e);
//     } catch (e) {
//       return ApiError(message: e.toString());
//     }
//   }
// }

class ApiService {
  final DioClient _dioClient = DioClient();

  Future<Response> get({required String endPoint , dynamic param}) async {
    try {
      final Response response = await _dioClient.dio.get(endPoint  , queryParameters: param);
      return response;
    } on DioException catch (e) {
      log("STATUS => ${e.response?.statusCode}");
      throw ApiExceptions.apiHandler(e);
    } catch (e) {
      log('catch ${e.toString()}');
      throw ApiError(message: e.toString());
    }
  }

  Future<Response> post(
      String endPoint,  dynamic json) async {
    final Response response;
    try {
      response = await _dioClient.dio.post(endPoint, data: json);
      return response;
    } on DioException catch (e) {
      log("DioException: ${e.message}");
      throw ApiExceptions.apiHandler(e);

      /// => ApiError
    } catch (e) {
      log("exception is${e.toString()}");
      throw ApiError(message: e.toString());
    }
  }

  Future<Response>put({required String endPoint, required Map<String, dynamic> json})async {
   try {
     final Response response = await _dioClient.dio.put(endPoint, data: json);
     return response;
   } on DioException catch (e) {
     throw ApiExceptions.apiHandler(e);
   }catch(e)
    {
      throw ApiError(message: e.toString());
    }
  }


  Future<Response> delete({required String endPoint}) async
  {
   try {
     final Response response = await _dioClient.dio.delete(endPoint);
     return response;
   } on DioException catch (e) {
     throw ApiExceptions.apiHandler(e);
   }catch(e)
    {
      throw ApiError(message: e.toString());
    }
  }
}
