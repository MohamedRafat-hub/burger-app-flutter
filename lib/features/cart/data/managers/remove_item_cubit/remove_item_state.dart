part of 'remove_item_cubit.dart';

@immutable
sealed class RemoveItemState {}

final class RemoveItemInitial extends RemoveItemState {}
final class RemoveItemLoading extends RemoveItemState {}
final class RemoveItemSuccess extends RemoveItemState {}
final class RemoveItemFailure extends RemoveItemState {
  final ApiError apiError;

  RemoveItemFailure(this.apiError);
}
