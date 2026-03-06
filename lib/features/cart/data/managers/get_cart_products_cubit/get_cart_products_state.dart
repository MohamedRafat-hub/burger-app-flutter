part of 'get_cart_products_cubit.dart';

@immutable
sealed class GetCartProductsState {}

final class GetCartProductsInitial extends GetCartProductsState {}
final class GetCartProductsLoading extends GetCartProductsState {}
final class GetCartProductsSuccess extends GetCartProductsState {
  final CartData cartItems;

  GetCartProductsSuccess(this.cartItems);
}
final class GetCartProductsFailure extends GetCartProductsState {
  final ApiError apiError;

  GetCartProductsFailure(this.apiError);
}
