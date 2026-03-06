import 'package:bloc/bloc.dart';
import 'package:food_app/core/network/api_error.dart';
import 'package:food_app/core/network/api_exceptions.dart';
import 'package:food_app/features/orderHistory/data/models/order_model.dart';
import 'package:food_app/features/orderHistory/data/repo/order_repo.dart';
import 'package:meta/meta.dart';

part 'get_orders_state.dart';

class GetOrdersCubit extends Cubit<GetOrdersState> {
  GetOrdersCubit() : super(GetOrdersInitial());

  final OrderRepo _orderRepo = OrderRepo();

  getOrders() async {
    emit(GetOrdersLoading());
    try {
      final List<OrderModel> orders = await _orderRepo.getOrders();
      emit(GetOrdersSuccess(orders));
    } catch (e) {
      emit(GetOrdersFailure(ApiError(message: e.toString())));
    }
  }
}
