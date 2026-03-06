

import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:food_app/features/orderHistory/data/repo/order_repo.dart';
import 'package:meta/meta.dart';

import '../../../../../core/network/api_error.dart';
import '../../../../cart/data/models/cart_model.dart';

part 'save_order_state.dart';

class SaveOrderCubit extends Cubit<SaveOrderState> {
  SaveOrderCubit() : super(SaveOrderInitial());

  final OrderRepo _orderRepo = OrderRepo();
  Future<void> saveOrder({required CartRequestModel cartModel})async {
    emit(SaveOrderLoading());
    try {
      await _orderRepo.saveOrder(cartModel);
      log('Save order successfully');
      emit(SaveOrderSuccess());
    }catch (e) {
      log('Save order failure');
      emit(SaveOrderFailure(errorMessage: ApiError(message: e.toString())));
    }
  }

}
