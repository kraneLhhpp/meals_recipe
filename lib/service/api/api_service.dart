import 'package:dio/dio.dart';
import 'package:nutrition_api/service/model/category_response.dart';
import 'package:nutrition_api/service/model/meal_category.dart';
import 'package:nutrition_api/service/model/meal_details.dart';
import 'package:nutrition_api/service/model/meals.dart';
import 'package:nutrition_api/service/model/meals_response.dart';

class ApiService {
  final Dio dio = Dio();

  static const String allCategoryUrl =
      'https://www.themealdb.com/api/json/v1/1/categories.php';

  static const String filterByCategoryUrl =
      'https://www.themealdb.com/api/json/v1/1/filter.php';

  static const String filterByAreaUrl =
    'https://www.themealdb.com/api/json/v1/1/filter.php';

  Future<List<MealCategory>> fetchCategories() async {
    try {
      final response = await dio.get(allCategoryUrl);
      final data = response.data as Map<String, dynamic>;
      
      if (data['categories'] == null) return [];
      
      final categoryResponse = CategoryResponse.fromJson(data);
      return categoryResponse.categories;
    } on DioException catch (e) {
      throw Exception('Dio error (categories): ${e.message}');
    }
  }

  Future<List<Meals>> fetchMeals(String category) async {
    try {
      final response = await dio.get(
        filterByCategoryUrl,
        queryParameters: {'c': category},
      );

      final data = response.data as Map<String, dynamic>;
      
      if (data['meals'] == null) return [];

      final mealResponse = MealsResponse.fromJson(data);
      return mealResponse.meals ?? [];
    } on DioException catch (e) {
      throw Exception('Dio error (meals): ${e.message}');
    }
  }

 Future<List<Meals>> fetchMealsByArea(String area) async {
    try {
      final response = await dio.get(
        filterByAreaUrl,
        queryParameters: {'a': area},
      );

      final data = response.data as Map<String, dynamic>;
      if (data['meals'] == null) return [];

      final mealResponse = MealsResponse.fromJson(data);
      return mealResponse.meals ?? [];
    } on DioException catch (e) {
      throw Exception('Dio error (area): ${e.message}');
    }
  }

  Future<List<Meals>> searchMealsByName(String query) async {
    try {
      final response = await dio.get(
        'https://www.themealdb.com/api/json/v1/1/search.php',
        queryParameters: {'s': query},
      );

      final data = response.data as Map<String, dynamic>;
      if (data['meals'] == null) return [];

      final mealResponse = MealsResponse.fromJson(data);
      return mealResponse.meals ?? [];
    } on DioException catch (e) {
      throw Exception('Dio error (search): ${e.message}');
    }
  }

  Future<MealDetails> fetchMealDetails(String id) async {
    try {
      final response = await dio.get(
        'https://www.themealdb.com/api/json/v1/1/lookup.php',
        queryParameters: {'i': id},
      );

      final data = response.data;
      
      if (data['meals'] == null || (data['meals'] as List).isEmpty) {
        throw Exception('Meal not found');
      }

      return MealDetails.fromJson(data['meals'][0]);
    } catch (e) {
      throw Exception('Error fetching details: $e');
    }
  }

  Future<List<Meals>> fetchMealsByIngredient(String ingredient) async {
    try {
      final response = await dio.get(
        'https://www.themealdb.com/api/json/v1/1/filter.php',
        queryParameters: {'i': ingredient},
      );

      final data = response.data as Map<String, dynamic>;
      if (data['meals'] == null) return [];

      final mealResponse = MealsResponse.fromJson(data);
      return mealResponse.meals ?? [];
    } on DioException catch (e) {
      throw Exception('Dio error (ingredient): ${e.message}');
    }
  }
}