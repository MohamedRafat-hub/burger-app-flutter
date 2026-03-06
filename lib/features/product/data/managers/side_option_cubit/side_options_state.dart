part of 'side_options_cubit.dart';


@immutable
sealed class SideOptionsState {}

final class SideOptionsInitial extends SideOptionsState {}
final class SideOptionsLoading extends SideOptionsState {}
final class SideOptionsSuccess extends SideOptionsState {
  final List<ToppingModel>toppings;

  SideOptionsSuccess(this.toppings);
}
final class SideOptionsFailure extends SideOptionsState {
  final ApiError apiError;

  SideOptionsFailure(this.apiError);
}
