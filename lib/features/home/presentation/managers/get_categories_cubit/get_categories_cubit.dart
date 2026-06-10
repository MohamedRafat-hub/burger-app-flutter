import 'package:bloc/bloc.dart';
import 'package:food_app/core/network/api_error.dart';
import 'package:food_app/features/home/data/models/category_model.dart';
import 'package:food_app/features/home/data/repos/product_repo.dart';
import 'package:meta/meta.dart';

part 'get_categories_state.dart';

class GetCategoriesCubit extends Cubit<GetCategoriesState> {
  GetCategoriesCubit() : super(GetCategoriesInitial());
  final ProductRepo _productRepo = ProductRepo();

  Future<void> getCategories() async {
    emit(GetCategoriesLoading());
    try {
      List<CategoryModel> categories = await _productRepo.getCategories();
      emit(GetCategoriesSuccess(categories));
    } catch (e) {
      emit(GetCategoriesFailure(ApiError(message: e.toString())));
    }
  }
}
