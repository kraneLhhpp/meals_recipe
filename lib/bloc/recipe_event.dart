 part of 'recipe_bloc.dart';

@immutable
sealed class RecipeEvent {}

class NavigationItemTapped extends RecipeEvent{
  final int index;

  NavigationItemTapped(this.index);
}

class LoadHomeData extends RecipeEvent{}

class CategorySelected extends RecipeEvent{
  final String categoryName;

  CategorySelected(this.categoryName);
}

