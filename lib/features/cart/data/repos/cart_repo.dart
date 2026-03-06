import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:food_app/core/network/api_error.dart';
import 'package:food_app/core/network/api_exceptions.dart';
import 'package:food_app/core/network/api_service.dart';
import 'package:food_app/features/cart/data/models/cart_model.dart';

class CartRepo {
  ApiService _apiService = ApiService();

  Future<void> addToCart({required CartRequestModel cart}) async {
    try {
      final Response response =
          await _apiService.post('/cart/add', cart.toJson());
    } on DioException catch (e) {
      throw ApiExceptions.apiHandler(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  Future<CartData> getCartProducts() async {
    final Response response = await _apiService.get(endPoint: '/cart');
    final data = response.data['data'];
    return CartData.fromJson(response.data['data']);
  }

  Future<void> removeItem({required int itemId}) async {
    final Response response =
        await _apiService.delete(endPoint: '/cart/remove/$itemId');
  }



}
