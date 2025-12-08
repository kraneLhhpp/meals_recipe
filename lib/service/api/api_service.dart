import 'package:dio/dio.dart';
import 'package:nutrition_api/service/model/category_response.dart';
import 'package:nutrition_api/service/model/meal_category.dart';
import 'package:nutrition_api/service/model/meals.dart';
import 'package:nutrition_api/service/model/meals_response.dart';

class ApiService {
  final dio = Dio();
  static const allCategoryUrl = 'https://www.themealdb.com/api/json/v1/1/categories.php';
  final filterByCategoryUrl = 'https://www.themealdb.com/api/json/v1/1/filter.php?c';
  
  Future<List<MealCategory>> fetchCategories() async{
    try{
      final Response response = await dio.get(allCategoryUrl);

      if(response.statusCode == 200){
        final jsonMap = response.data as Map<String, dynamic>;
        final categoryResponse = CategoryResponse.fromJson(jsonMap);
        return categoryResponse.categories;
      }else {
        throw Exception('Failed to load. Status code: ${response.statusCode}');
      }
    }on DioException catch(e){
      throw Exception('Dio fetching error: ${e.message}');
    }catch (e){
      throw Exception('Failed to process $e');  
    }
  } 
  Future<List<Meals>> fetchMeals(String category) async{
    try{
      final Response response = await dio.get('$filterByCategoryUrl=$category');

      if(response.statusCode == 200){
        final jsonMap = response.data as Map<String, dynamic>;
        final mealResponse = MealsResponse.fromJson(jsonMap);
        return mealResponse.meals;
      }else{
        throw Exception('Failed to load. Status code: ${response.statusCode}');
      }
    }catch (e){
      throw Exception('Failed to process: $e');
    }
  }
}