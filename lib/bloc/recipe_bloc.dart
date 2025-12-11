import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nutrition_api/service/api/api_service.dart';
import 'package:nutrition_api/service/model/meal_category.dart';
import 'package:nutrition_api/service/model/meals.dart';

part 'recipe_event.dart';
part 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final ApiService _apiService;
  RecipeBloc(this._apiService) : super(RecipeLoading(0)) {
    on<NavigationItemTapped>((event, emit) {
      if (state is RecipeLoaded) {
        final current = state as RecipeLoaded;
        emit(RecipeLoaded(
          selectedIndex: event.index,
          categories: current.categories,
          meals: current.meals,
          selectedCategory: current.selectedCategory,
        ));
      } 
      else if (state is RecipeLoading) {
        emit(RecipeLoading(event.index));
      }
      else if (state is RecipeError) {
         final current = state as RecipeError;
         emit(RecipeError(current.message, event.index));
      }
    });

    on<LoadHomeData>((event, emit) async {
      final currentIndex = state.selectedIndex;

      emit(RecipeLoading(currentIndex));

      try {
        final categories = await _apiService.fetchCategories();
        final meals = await _apiService.fetchMeals('Beef');

        emit(RecipeLoaded(
          selectedIndex: currentIndex,
          categories: categories,
          meals: meals,
          selectedCategory: 'Beef',
        ));
      } catch (e) {
        emit(RecipeError(e.toString(), currentIndex));
      }
    });

    on<CategorySelected>((event, emit) async{
      emit(RecipeLoading(state.selectedIndex));

      try{
        final meals = await _apiService.fetchMeals(event.categoryName);
        final current = state as RecipeLoaded;

        emit(RecipeLoaded(
          selectedIndex: current.selectedIndex,
          categories: current.categories, 
          meals: meals, 
          selectedCategory: event.categoryName
        ));
      }catch (e){
        emit(RecipeError(e.toString(), state.selectedIndex));
      }
    });
  }
}
