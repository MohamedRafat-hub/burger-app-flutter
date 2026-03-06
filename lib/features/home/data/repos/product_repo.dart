import 'package:dio/dio.dart';
import 'package:food_app/core/network/api_error.dart';
import 'package:food_app/core/network/api_exceptions.dart';
import 'package:food_app/core/network/api_service.dart';
import 'package:food_app/features/home/data/models/category_model.dart';
import 'package:food_app/features/home/data/models/product_model.dart';
import 'package:food_app/features/product/data/models/topping_model.dart';

class ProductRepo {
  final ApiService _apiService = ApiService();

  Future<List<ProductModel>> getAllProducts() async {
    try {
      final Response response = await _apiService.get(endPoint: '/products');
      List<dynamic> data = response.data['data'];

      return data.map((product) => ProductModel.fromJson(product)).toList();
    } on DioException catch (e) {
      throw ApiExceptions.apiHandler(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  Future<List<ToppingModel>> getAllToppings({required String endPoint}) async {
    try {
      final Response response = await _apiService.get(endPoint: endPoint);
      List<dynamic> data = response.data['data'];
      return data.map((topping) => ToppingModel.fromJson(topping)).toList();
    } on DioException catch (e) {
      throw ApiExceptions.apiHandler(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  Future<List<CategoryModel>> getCategories() async {
    try {
      final Response response = await _apiService.get(endPoint: '/categories');
      List data = response.data['data'];

      List<CategoryModel> categories =
          data.map((e) => CategoryModel.fromJson(e)).toList();

      return categories;
    } on DioException catch (e) {
      throw ApiExceptions.apiHandler(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  Future<List<ProductModel>> getProductsByCategory({required int categoryId}) async {
    try {
      final Response response = await _apiService
          .get(endPoint: '/products', param: {'category_id': categoryId});
      List<dynamic> data = response.data['data'];
      return data.map((product) => ProductModel.fromJson(product)).toList();
    } on DioException catch (e) {
      throw ApiExceptions.apiHandler(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }
}
