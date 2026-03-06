import 'package:dio/dio.dart';
import 'package:food_app/core/network/api_error.dart';
import 'package:food_app/core/network/api_exceptions.dart';
import 'package:food_app/core/network/api_service.dart';
import 'package:food_app/features/orderHistory/data/models/order_model.dart';
import '../../../cart/data/models/cart_model.dart';

class OrderRepo {
  final ApiService _apiService = ApiService();

  Future<List<OrderModel>> getOrders() async {
    try {
      final Response response = await _apiService.get(endPoint: '/orders');
      List<dynamic> data = response.data['data'];

      List<OrderModel> orders =
          data.map((e) => OrderModel.fromJson(e)).toList();

      return orders;
    } on DioException catch (e) {
      throw ApiExceptions.apiHandler(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  Future<void> saveOrder(CartRequestModel order) async {
    try {
      final Response response = await _apiService.post('/orders', order.toJson());
    } on DioException catch (e) {
      throw ApiExceptions.apiHandler(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }
}
