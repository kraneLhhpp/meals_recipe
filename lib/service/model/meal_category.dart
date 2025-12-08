class MealCategory {
  final String idCategory;
  final String strCategory;
  final String strCategoryThumb;
  final String strCategoryDescription;

  MealCategory({
    required this.idCategory, 
    required this.strCategory, 
    required this.strCategoryThumb, 
    required this.strCategoryDescription
  });

  factory MealCategory.fromJson(Map<String, dynamic> json){
    return MealCategory(
      idCategory: json['idCategory'] as String, 
      strCategory: json['strCategory'] as String, 
      strCategoryThumb: json['strCategoryThumb'] as String, 
      strCategoryDescription: json['strCategoryDescription'] as String
    );
  }
} 