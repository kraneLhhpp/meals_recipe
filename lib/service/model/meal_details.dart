class MealDetails {
  final String idMeal;
  final String strMeal;
  final String strMealThumb;
  final String strCategory;
  final String strArea;
  final String strInstructions;

  final List<String> ingredients;

  MealDetails({
    required this.idMeal,
    required this.strMeal,
    required this.strMealThumb,
    required this.strCategory,
    required this.strArea,
    required this.strInstructions,
    required this.ingredients,
  });

  factory MealDetails.fromJson(Map<String, dynamic> json) {
    final ingredients = <String>[];

    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i']?.toString().trim();
      final measure = json['strMeasure$i']?.toString().trim();

      if (ingredient != null &&
          ingredient.isNotEmpty &&
          ingredient != ' ') {
        ingredients.add(
          measure != null && measure.isNotEmpty
              ? '$ingredient ($measure)'
              : ingredient,
        );
      }
    }

    return MealDetails(
      idMeal: json['idMeal'],
      strMeal: json['strMeal'],
      strMealThumb: json['strMealThumb'],
      strCategory: json['strCategory'],
      strArea: json['strArea'],
      strInstructions: json['strInstructions'],
      ingredients: ingredients,
    );
  }
}
