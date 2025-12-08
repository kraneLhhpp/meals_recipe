import 'package:nutrition_api/service/model/meals.dart';

class MealsResponse {
  final List<Meals> meals;

  MealsResponse({required this.meals});

  factory MealsResponse.fromJson(Map<String, dynamic> json){
    final List<dynamic> mealsList = json['meals'] as List<dynamic>;
    return MealsResponse(meals: mealsList.map((item) => Meals.fromJson(item as Map<String, dynamic>)).toList());
  } 
}