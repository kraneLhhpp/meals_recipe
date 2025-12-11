part of 'recipe_bloc.dart';

@immutable
sealed class RecipeState {
  final int selectedIndex;

  const RecipeState({this.selectedIndex = 0});
}

class RecipeLoading extends RecipeState{
  const RecipeLoading(int index) : super(selectedIndex: index);
}

class RecipeLoaded extends RecipeState{
  final List<MealCategory> categories;
  final List<Meals> meals;
  final String selectedCategory;

  const RecipeLoaded({
    super.selectedIndex, 
    required this.categories, 
    required this.meals, 
    required this.selectedCategory}) ;
}

class RecipeError extends RecipeState{
  final String message;

  const RecipeError(this.message, int index);
}


