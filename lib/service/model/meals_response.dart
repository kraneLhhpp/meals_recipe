import 'package:nutrition_api/service/model/meals.dart';

class MealsResponse {
  final List<Meals>? meals;

  MealsResponse({required this.meals});

  factory MealsResponse.fromJson(Map<String, dynamic> json) {
    final mealsData = json['meals'];
    if (mealsData is List) {
      return MealsResponse(
        meals: mealsData
            .map((item) => Meals.fromJson(item as Map<String, dynamic>))
            .toList(),
      );
    }
    return MealsResponse(meals: []);
  }
}