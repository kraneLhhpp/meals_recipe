part of 'recipe_bloc.dart';

@immutable
abstract class RecipeState extends Equatable {
  final int selectedIndex;
  const RecipeState(this.selectedIndex);

  @override
  List<Object?> get props => [selectedIndex];
}

class RecipeLoading extends RecipeState {
  const RecipeLoading(super.selectedIndex);
}

class RecipeLoaded extends RecipeState {
  final List<MealCategory> categories;
  final List<Meals> categoryMeals;
  final List<Meals> areaMeals;
  final List<Meals> searchMeals;
  final List<Meals> favoriteMeals;
  final String selectedCategory;
  final String selectedArea;
  final String searchQuery;
  final bool isSearchLoading;
  final List<Meals> featuredMeals;


  const RecipeLoaded({
    required int selectedIndex,
    required this.categories,
    required this.categoryMeals,
    required this.areaMeals,
    required this.selectedCategory,
    required this.selectedArea,
    required this.searchMeals,
    required this.searchQuery,
    this.favoriteMeals = const [],
    this.isSearchLoading = false,
     this.featuredMeals = const <Meals>[],
  }) : super(selectedIndex);

  RecipeLoaded copyWith({
    int? selectedIndex,
    List<MealCategory>? categories,
    List<Meals>? categoryMeals,
    List<Meals>? areaMeals,
    List<Meals>? searchMeals,
    List<Meals>? favoriteMeals,
    String? selectedCategory,
    String? selectedArea,
    String? searchQuery,
    bool? isSearchLoading,
    List<Meals>? featuredMeals,
  }) {
    return RecipeLoaded(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      categories: categories ?? this.categories,
      categoryMeals: categoryMeals ?? this.categoryMeals,
      areaMeals: areaMeals ?? this.areaMeals,
      favoriteMeals: favoriteMeals ?? this.favoriteMeals,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedArea: selectedArea ?? this.selectedArea,
      searchMeals: searchMeals ?? this.searchMeals,
      searchQuery: searchQuery ?? this.searchQuery,
      isSearchLoading: isSearchLoading ?? this.isSearchLoading,
      featuredMeals: featuredMeals ?? this.featuredMeals,
    );
  }

  @override
  List<Object?> get props => [
        selectedIndex,
        categories,
        categoryMeals,
        areaMeals,
        searchMeals,
        favoriteMeals,
        selectedCategory,
        selectedArea,
        searchQuery,
        isSearchLoading,
        featuredMeals
      ];
}

class RecipeError extends RecipeState {
  final String message;

  const RecipeError(this.message, int index) : super(index);

  @override
  List<Object?> get props => [selectedIndex, message];
}