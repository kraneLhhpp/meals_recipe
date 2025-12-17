part of 'recipe_bloc.dart';

@immutable
abstract class RecipeEvent {}

class LoadHomeData extends RecipeEvent {}

class CategorySelected extends RecipeEvent {
  final String categoryName;
  CategorySelected(this.categoryName);
}

class NavigationItemTapped extends RecipeEvent {
  final int index;
  NavigationItemTapped(this.index);
}

class AreaSelected extends RecipeEvent {
  final String area;
  AreaSelected(this.area);
}

class SearchMeals extends RecipeEvent {
  final String query;
  SearchMeals(this.query);
}

class ToggleFavoriteEvent extends RecipeEvent {
  final Meals meal;

  ToggleFavoriteEvent(this.meal);

  List<Object> get props => [meal];
}