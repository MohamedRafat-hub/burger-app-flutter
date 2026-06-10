import 'package:bloc/bloc.dart';
import 'package:food_app/core/network/api_error.dart';
import 'package:food_app/features/home/data/models/product_model.dart';
import 'package:food_app/features/home/data/repos/product_repo.dart';
import 'package:meta/meta.dart';

part 'get_products_state.dart';

class GetProductsCubit extends Cubit<GetProductsState> {
  GetProductsCubit() : super(GetProductsInitial());

  ProductRepo productRepo = ProductRepo();

  Future<void> getAllProducts() async {
    emit(GetProductsLoading());
    try {
      final List<ProductModel> products = await productRepo.getAllProducts();
      emit(GetProductsSuccess(products));
    } catch (e) {
      emit(GetProductsFailure(ApiError(message: e.toString())));
      throw ApiError(message: e.toString());
    }
  }


  Future<void> getProductsByCategory(int categoryId) async {
    emit(GetProductsLoading());
    try {
      final List<ProductModel> products = await productRepo.getProductsByCategory(categoryId: categoryId);
      emit(GetProductsSuccess(products));
    } catch (e) {
      emit(GetProductsFailure(ApiError(message: e.toString())));
      throw ApiError(message: e.toString());
    }
  }
}
