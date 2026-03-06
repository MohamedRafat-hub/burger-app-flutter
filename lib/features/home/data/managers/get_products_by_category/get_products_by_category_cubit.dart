import 'package:bloc/bloc.dart';
import 'package:food_app/core/network/api_error.dart';
import 'package:food_app/features/home/data/models/product_model.dart';
import 'package:food_app/features/home/data/repos/product_repo.dart';
import 'package:meta/meta.dart';

part 'get_products_by_category_state.dart';

class GetProductsByCategoryCubit extends Cubit<GetProductsByCategoryState> {
  GetProductsByCategoryCubit() : super(GetProductsByCategoryInitial());
  final ProductRepo productRepo = ProductRepo();
  Future<void> getProductsByCategory(int categoryId) async {
    emit(GetProductsByCategoryLoading());
    try {
      final List<ProductModel> products = await productRepo.getProductsByCategory(categoryId: categoryId);
      emit(GetProductsByCategorySuccess(products));
    } catch (e) {
      emit(GetProductsByCategoryFailure(ApiError(message: e.toString())));
    }
  }
}
