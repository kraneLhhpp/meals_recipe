import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:nutrition_api/service/api/api_service.dart';
import 'package:nutrition_api/service/model/meal_category.dart';
import 'package:nutrition_api/service/model/meals.dart';
import 'package:stream_transform/stream_transform.dart';

part 'recipe_event.dart';
part 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final ApiService apiService;

  RecipeBloc(this.apiService) : super(const RecipeLoading(0)) {
    on<NavigationItemTapped>((event, emit) {
      if (state is RecipeLoaded) {
        final current = state as RecipeLoaded;

        emit(current.copyWith(
          selectedIndex: event.index,
        ));
      } else {
        emit(RecipeLoading(event.index));
      }
    });

    on<LoadHomeData>((event, emit) async {
      final index = state.selectedIndex;
      emit(RecipeLoading(index));

      try {
        final categories = await apiService.fetchCategories();
        final categoryMeals = await apiService.fetchMeals('Beef');
        final areaMeals = await apiService.fetchMealsByArea('Canadian');
        final oldFavorites = state is RecipeLoaded ? (state as RecipeLoaded).favoriteMeals : const <Meals>[];
        final featuredMeals = await apiService.fetchMealsByIngredient('chicken_breast');

        emit(RecipeLoaded(
          selectedIndex: index,
          categories: categories,
          categoryMeals: categoryMeals,
          areaMeals: areaMeals,
          featuredMeals: featuredMeals,
          searchMeals: const [],
          selectedCategory: 'Beef',
          selectedArea: 'Canadian',
          searchQuery: '',
          favoriteMeals: oldFavorites,
        ));
      } catch (e) {
        emit(RecipeError(e.toString(), index));
      }
    });

    on<CategorySelected>((event, emit) async {
      if (state is! RecipeLoaded) return;
      final current = state as RecipeLoaded;

      emit(current.copyWith(
        selectedCategory: event.categoryName,
        categoryMeals: const [],
      ));

      try {
        final meals = await apiService.fetchMeals(event.categoryName);

        emit(current.copyWith(
          categoryMeals: meals,
          selectedCategory: event.categoryName,
        ));
      } catch (e) {
        emit(RecipeError(e.toString(), current.selectedIndex));
      }
    });

    on<AreaSelected>((event, emit) async {
      if (state is! RecipeLoaded) return;
      final current = state as RecipeLoaded;

      emit(current.copyWith(
        selectedArea: event.area,
        areaMeals: const [],
      ));

      try {
        final meals = await apiService.fetchMealsByArea(event.area);

        emit(current.copyWith(
          areaMeals: meals,
          selectedArea: event.area,
        ));
      } catch (e) {
        emit(RecipeError(e.toString(), current.selectedIndex));
      }
    });

    on<SearchMeals>((event, emit) async {
      if (state is! RecipeLoaded) return;
      final current = state as RecipeLoaded;

      if (event.query.isEmpty) {
        emit(current.copyWith(
          searchMeals: const [], 
          searchQuery: '',
          isSearchLoading: false,
        ));
        return;
      }

      emit(current.copyWith(
        isSearchLoading: true, 
        searchQuery: event.query
      ));

      try {
        final meals = await apiService.searchMealsByName(event.query);

        emit(current.copyWith(
          searchMeals: meals,
          isSearchLoading: false,
        ));
      } catch (e) {
        emit(RecipeError(e.toString(), current.selectedIndex));
      }
    }, 
    transformer: (events, mapper) {
      return events
          .debounce(const Duration(milliseconds: 300))
          .switchMap(mapper);
    });

    on<ToggleFavoriteEvent>((event, emit) {
      if (state is RecipeLoaded) {
        final current = state as RecipeLoaded;
        final List<Meals> updatedFavorites = List.from(current.favoriteMeals);        
        final isExisting = updatedFavorites.any((element) => element.idMeal == event.meal.idMeal);

        if (isExisting) {
          updatedFavorites.removeWhere((element) => element.idMeal == event.meal.idMeal);
        } else {
          updatedFavorites.add(event.meal);
        }

        emit(current.copyWith(favoriteMeals: updatedFavorites));
      }
    });
  }
}
