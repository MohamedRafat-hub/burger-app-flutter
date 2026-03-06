import 'package:bloc/bloc.dart';
import 'package:food_app/core/network/api_error.dart';
import 'package:food_app/features/home/data/repos/product_repo.dart';
import 'package:meta/meta.dart';

import '../../models/topping_model.dart';
import '../topping_cubit/get_toppings_cubit.dart';

part 'side_options_state.dart';

class SideOptionsCubit extends Cubit<SideOptionsState> {
  SideOptionsCubit() : super(SideOptionsInitial());

  ProductRepo _productRepo = ProductRepo();
  Future<void>getSideOptions() async {
    try {
      emit(SideOptionsLoading());
      List<ToppingModel> toppings = await _productRepo.getAllToppings(endPoint: '/side-options');
      emit(SideOptionsSuccess(toppings));
    }catch (e) {
      emit(SideOptionsFailure(ApiError(message: e.toString())));
    }
  }
}
