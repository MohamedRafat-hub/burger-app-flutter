part of 'cart_cubit.dart';

@immutable
sealed class CartState {}

final class CartInitial extends CartState {}

final class CartLoading extends CartState {}

final class CartSuccess extends CartState {
  final CartRequestModel cartModel;

  CartSuccess({required this.cartModel});
}

final class CartFailure extends CartState {
  final ApiError errorMessage;

  CartFailure({required this.errorMessage});
}
