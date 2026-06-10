import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:food_app/core/network/api_error.dart';
import 'package:food_app/features/cart/data/repos/cart_repo.dart';

import '../../../data/models/cart_model.dart';


part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());
  CartRepo cartRepo = CartRepo();

  Future<void> addToCart({required CartRequestModel cartModel})async {
    emit(CartLoading());
    try {
     await cartRepo.addToCart(cart: cartModel);
      emit(CartSuccess(cartModel: cartModel));
    }catch (e) {
      emit(CartFailure(errorMessage: ApiError(message: e.toString())));
    }
  }
}
