import 'package:bloc/bloc.dart';
import 'package:food_app/core/network/api_error.dart';
import 'package:food_app/features/home/data/repos/product_repo.dart';
import 'package:food_app/features/product/data/models/topping_model.dart';
import 'package:meta/meta.dart';

part 'get_toppings_state.dart';

class GetToppingsCubit extends Cubit<GetToppingsState> {
  GetToppingsCubit() : super(GetToppingsInitial());

  ProductRepo _productRepo = ProductRepo();

  Future<void> getToppings() async {
    try {
      emit(GetToppingsLoading());
      List<ToppingModel> toppings = await _productRepo.getAllToppings(endPoint: '/toppings');
      emit(GetToppingsSuccess(toppings));
    }catch (e) {
      emit(GetToppingsFailure(ApiError(message: e.toString())));
    }
  }

}
