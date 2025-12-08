class Meals {
  final String strMeal;
  final String strMealThumb;
  final String idMeal;

  Meals({required this.strMeal, required this.strMealThumb, required this.idMeal});

    factory Meals.fromJson(Map<String, dynamic> json){
      return Meals(
        strMeal: json['strMeal'], 
        strMealThumb: json['strMealThumb'], 
        idMeal: json['idMeal']
      );
    }
}
