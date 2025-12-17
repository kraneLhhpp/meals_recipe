import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_api/bloc/recipe_bloc.dart';
import 'package:nutrition_api/screens/home_screens/widgets/meal_details_screen.dart';
import 'package:nutrition_api/service/api/api_service.dart';
import 'package:nutrition_api/service/model/meal_category.dart';
import 'package:nutrition_api/service/model/meals.dart';

class SearchBarScreen extends StatefulWidget {
  const SearchBarScreen({super.key});

  @override
  State<SearchBarScreen> createState() => _SearchBarScreenState();
}

class _SearchBarScreenState extends State<SearchBarScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeBloc, RecipeState>(
      builder: (context, state) {
        if (state is RecipeError) {
          return Scaffold(
            body: Center(child: Text(state.message)),
          );
        }

        if (state is RecipeLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is! RecipeLoaded) {
          return const Scaffold(body: SizedBox());
        }

        final categories = state.categories;
        final categoryMeals = state.categoryMeals;
        final areaMeals = state.areaMeals;
        final selectedCategory = state.selectedCategory;
        final selectedArea = state.selectedArea;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Center(
                    child: Text(
                      "Search",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.grey),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintText: "Search",
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              setState(() {});
                              context.read<RecipeBloc>().add(SearchMeals(value));
                            },
                          ),
                        ),
                        if (_searchController.text.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              setState(() {});
                              context.read<RecipeBloc>().add(SearchMeals(""));
                            },
                            child: const Icon(Icons.close, color: Colors.grey),
                          ),
                      ],
                    ),
                  ),
                  if (_searchController.text.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Text(
                      "Search results",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 15),

                    if (state.isSearchLoading)
                      const SizedBox(
                        height: 100,
                        child: Center(
                          child: CircularProgressIndicator(color: Color(0xFF7AB8C8)),
                        ),
                      )
                    else if (state.searchMeals.isNotEmpty)
                      SizedBox(
                        height: 160,
                        child: _MealsHorizontalList(state.searchMeals),
                      )
                    else
                      const SizedBox(
                        height: 100,
                        child: Center(
                          child: Text(
                            "Nothing found",
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ),
                      ),
                  ],
                  const SizedBox(height: 25),
                  const Text(
                    "Filter by Category",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, i) {
                        final MealCategory category = categories[i];
                        final bool isSelected =
                            category.strCategory == selectedCategory;

                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () {
                              context
                                  .read<RecipeBloc>()
                                  .add(CategorySelected(category.strCategory));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF7AB8C8)
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                category.strCategory,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 160,
                    child: categoryMeals.isEmpty
                        ? const Center(
                            child: Text('No meals for selected category'),
                          )
                        : _MealsHorizontalList(categoryMeals),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Filter by Area",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      _areaButton(context, "Canadian", selectedArea),
                      const SizedBox(width: 10),
                      _areaButton(context, "Japanese", selectedArea),
                      const SizedBox(width: 10),
                      _areaButton(context, "Vietnamese", selectedArea),
                    ],
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 160,
                    child: areaMeals.isEmpty
                        ? const Center(
                            child: Text('Select area to see meals'),
                          )
                        : _MealsHorizontalList(areaMeals),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _areaButton(
    BuildContext context,
    String area,
    String selectedArea,
  ) {
    final bool isActive = area == selectedArea;

    return GestureDetector(
      onTap: () {
        context.read<RecipeBloc>().add(AreaSelected(area));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF7AB8C8) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          area,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _MealsHorizontalList extends StatelessWidget {
  final List<Meals> meals;

  _MealsHorizontalList(this.meals);

  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: meals.length,
      itemBuilder: (context, index) {
        final meal = meals[index];

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
              if (!context.mounted) return;
              Navigator.of(context).pop();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error loading recipe: $e')),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    meal.strMealThumb,
                    height: 110,
                    width: 110,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.error),
                  ),
                ),    
                const SizedBox(height: 8),
                SizedBox(
                  width: 110,
                  child: Text(
                    meal.strMeal,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}