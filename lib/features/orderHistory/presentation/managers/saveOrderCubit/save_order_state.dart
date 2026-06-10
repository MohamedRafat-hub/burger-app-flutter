part of 'save_order_cubit.dart';

@immutable
sealed class SaveOrderState {}

final class SaveOrderInitial extends SaveOrderState {}

final class SaveOrderLoading extends SaveOrderState {}

final class SaveOrderSuccess extends SaveOrderState {


  SaveOrderSuccess();
}

final class SaveOrderFailure extends SaveOrderState {
  final ApiError errorMessage;

  SaveOrderFailure({required this.errorMessage});
}
