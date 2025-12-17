import 'package:nutrition_api/service/model/meal_details.dart';

abstract class MealDetailsState {}

class MealDetailsLoading extends MealDetailsState {}

class MealDetailsLoaded extends MealDetailsState {
  final MealDetails meal;
  MealDetailsLoaded(this.meal);
}

class MealDetailsError extends MealDetailsState {
  final String message;
  MealDetailsError(this.message);
}
