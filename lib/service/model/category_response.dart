import 'package:nutrition_api/service/model/meal_category.dart';

class CategoryResponse {
  final List<MealCategory> categories;

  CategoryResponse({required this.categories});

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> categoryList = json['categories'] as List<dynamic>;
    
    return CategoryResponse(
      categories: categoryList
          .map((item) => MealCategory.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}