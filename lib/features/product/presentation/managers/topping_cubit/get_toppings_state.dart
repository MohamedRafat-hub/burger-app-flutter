part of 'get_toppings_cubit.dart';

@immutable
sealed class GetToppingsState {}

final class GetToppingsInitial extends GetToppingsState {}
final class GetToppingsLoading extends GetToppingsState {}
final class GetToppingsSuccess extends GetToppingsState {
 final List<ToppingModel>toppings;

  GetToppingsSuccess(this.toppings);
}
final class GetToppingsFailure extends GetToppingsState {
  final ApiError apiError;

  GetToppingsFailure(this.apiError);
}
