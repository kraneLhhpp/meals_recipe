  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:nutrition_api/bloc/recipe_bloc.dart';
  import 'package:nutrition_api/screens/home_screens/widgets/meal_details_screen.dart';
  import 'package:nutrition_api/service/api/api_service.dart';

  class HomeBar extends StatefulWidget {
    const HomeBar({super.key});

    @override
    State<HomeBar> createState() => _HomeBarState();
  }

  class _HomeBarState extends State<HomeBar> {
    final user = FirebaseAuth.instance.currentUser;
    final ApiService _apiService = ApiService();

    @override
    Widget build(BuildContext context) {
      return BlocBuilder<RecipeBloc, RecipeState>(
        builder: (context, state) {

          if (state is RecipeLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is RecipeError) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Text(
                  'Error loading data:\n${state.message}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (state is RecipeLoaded) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.sunny, color: Color(0xFF4D8194)),
                          Text(
                            getGreeting(),
                            style: TextStyle(color: Color(0xFF0A2533)),
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),

                                            StreamBuilder<User?>(
                        stream: FirebaseAuth.instance.userChanges(),
                        builder: (context, snapshot) {
                          final user = snapshot.data;

                          return Text(
                            user?.displayName ?? 'Guest',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'Featured',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        height: 140,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.featuredMeals.length,
                          itemBuilder: (context, index) {
                            final meal = state.featuredMeals[index];

                            return GestureDetector(
                              onTap: () async {
                                final fullMeal = await _apiService.fetchMealDetails(meal.idMeal);

                                if(!context.mounted) return;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                      value: context.read<RecipeBloc>(),
                                      child: MealDetailsScreen(meal: fullMeal),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 220,
                                margin: const EdgeInsets.only(right: 16),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF7AB8C8),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Text(
                                        meal.strMeal,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'Categories',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 10),

                      SizedBox(
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.categories.length,
                          itemBuilder: (context, index) {
                            final category = state.categories[index];
                            final isSelected =
                                category.strCategory == state.selectedCategory;

                            return GestureDetector(
                              onTap: () {
                                context.read<RecipeBloc>().add(
                                  CategorySelected(category.strCategory),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF4D8194)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: Row(
                                  children: [
                                    Image.network(
                                      category.strCategoryThumb,
                                      width: 26,
                                      height: 26,
                                      errorBuilder: (_, __, ___) =>
                                          const Icon(Icons.error),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      category.strCategory,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 15),

                      Expanded(
                        child: state.categoryMeals.isEmpty
                            ? const Center(
                                child: Text('No meals found'),
                              )
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: state.categoryMeals.length,
                                itemBuilder: (context, index) {
                                  final meal = state.categoryMeals[index];

                                  return GestureDetector(
                                    onTap: () async {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) => const Center(
                                          child: CircularProgressIndicator(color: Color(0xFF4D8194)),
                                        ),
                                      );

                                      try {
                                        final fullMealDetails = await _apiService.fetchMealDetails(meal.idMeal);
                                        if (!context.mounted) return;
                                        Navigator.of(context).pop(); 
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => BlocProvider.value(
                                              value: context.read<RecipeBloc>(),
                                              child: MealDetailsScreen(meal: fullMealDetails),
                                            ),
                                          ),
                                        );
                                      } catch (e) {
                                        if (!mounted) return;
                                        Navigator.of(context).pop(); 
                                        
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Error loading recipe: $e')),
                                        );
                                      }
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.height * 0.25,
                                      margin: const EdgeInsets.only(right: 15),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.network(
                                              meal.strMealThumb,
                                              height: MediaQuery.of(context).size.height * 0.15,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) =>
                                                  const Icon(Icons.error),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            meal.strMeal,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      );
    }
    String getGreeting() {
      final hour = DateTime.now().hour;

      if (hour >= 5 && hour < 12) {
        return 'Good Morning';
      } else if (hour >= 12 && hour < 17) {
        return 'Good Day';
      } else if (hour >= 17 && hour < 22) {
        return 'Good Evening';
      } else {
        return 'Good Night';
      }
    }
  }
