import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_api/bloc/recipe_bloc.dart';
import 'package:nutrition_api/service/model/meal_details.dart';
import 'package:nutrition_api/service/model/meals.dart'; 

class MealDetailsScreen extends StatelessWidget {
  final MealDetails meal;

  const MealDetailsScreen({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Image.network(
            meal.strMealThumb,
            height: MediaQuery.of(context).size.height * 0.45,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.55,
            minChildSize: 0.55,
            maxChildSize: 0.9,
            builder: (context, controller) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: controller,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal.strMeal,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${meal.strCategory} • ${meal.strArea}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),                      
                      const Text(
                        'Ingredients',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: meal.ingredients.map((ingredient) {
                          return Chip(
                            label: Text(ingredient),
                            backgroundColor: Colors.white,
                            elevation: 2,
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 30),

                      BlocBuilder<RecipeBloc, RecipeState>(
                        builder: (context, state) {
                          bool isFavorite = false;
                          if (state is RecipeLoaded) {
                            isFavorite = state.favoriteMeals.any((m) => m.idMeal == meal.idMeal);
                          }

                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isFavorite 
                                    ? Colors.red.shade400 
                                    : const Color(0xFF7AB8C8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              onPressed: () {
                                final mealShort = Meals(
                                  idMeal: meal.idMeal,
                                  strMeal: meal.strMeal,
                                  strMealThumb: meal.strMealThumb,
                                );
                                context.read<RecipeBloc>().add(ToggleFavoriteEvent(mealShort));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(isFavorite ? 'Removed from favorites' : 'Added to favorites'),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                              child: Text(
                                isFavorite ? 'Remove from Favorites' : 'Add to Favorites',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}