part of 'recipe_bloc.dart';

@immutable
sealed class RecipeState {
  int get selectedIndex;
}

class NavigationState extends RecipeState{
  @override
  final int selectedIndex;

  NavigationState(this.selectedIndex);
}

