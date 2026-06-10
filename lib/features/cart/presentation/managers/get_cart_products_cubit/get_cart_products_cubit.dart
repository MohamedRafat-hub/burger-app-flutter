import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:food_app/core/network/api_error.dart';
import 'package:food_app/features/cart/data/models/cart_model.dart';
import 'package:food_app/features/cart/data/repos/cart_repo.dart';
import 'package:meta/meta.dart';

part 'get_cart_products_state.dart';

class GetCartProductsCubit extends Cubit<GetCartProductsState> {
  GetCartProductsCubit() : super(GetCartProductsInitial());

  CartRepo _cartRepo = CartRepo();

  Future<void> getCartProducts() async {
    emit(GetCartProductsLoading());
    try {
      final products = await _cartRepo.getCartProducts();
      emit(GetCartProductsSuccess(products));
    } catch (e) {
      log('get products failure is $e');
      emit(GetCartProductsFailure(ApiError(message: e.toString())));
      throw ApiError(message: e.toString());
    }
  }
}
