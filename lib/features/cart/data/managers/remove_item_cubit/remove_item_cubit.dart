import 'package:bloc/bloc.dart';
import 'package:food_app/core/network/api_error.dart';
import 'package:food_app/features/cart/data/repos/cart_repo.dart';
import 'package:meta/meta.dart';

part 'remove_item_state.dart';

class RemoveItemCubit extends Cubit<RemoveItemState> {
  RemoveItemCubit() : super(RemoveItemInitial());
  CartRepo _cartRepo = CartRepo();

  Future<void>removeItem({required int itemId}) async {
    try {
      emit(RemoveItemLoading());
      await _cartRepo.removeItem(itemId: itemId);
      emit(RemoveItemSuccess());
    } catch (e) {
      emit(RemoveItemFailure(ApiError(message: e.toString())));
    }
  }
}
