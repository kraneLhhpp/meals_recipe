import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutrition_api/service/api/api_service.dart';
import 'package:nutrition_api/service/model/meals.dart';
import 'package:nutrition_api/service/model/meal_category.dart';

class HomeBar extends StatefulWidget {
  const HomeBar({super.key});

  @override
  State<HomeBar> createState() => _HomeBarState();
}

class _HomeBarState extends State<HomeBar> {
  final ApiService _apiService = ApiService();
  late Future<List<MealCategory>> _categoriesFuture;
  late Future<List<Meals>> _mealsFuture;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _mealsFuture = _apiService.fetchMeals('Seafood');
    _categoriesFuture = _apiService.fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.sunny, color: Color(0xFF4D8194)),
                          SizedBox(width: 5),
                          Text("Good Morning", style: TextStyle(color: Color(0xFF0A2533))),
                        ],
                      ),
                      Text(user.toString(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
                    ],
                   ),
                  IconButton(
                    onPressed: (){}, 
                    icon: const Icon(Icons.shopping_cart, color: Colors.black)
                  )
                ],
              ),
              const SizedBox(height: 20),
              const Text('Featured', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Container(
                      width: MediaQuery.of(context).size.height * 0.3,
                      margin: const EdgeInsets.only(right: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey[300]
                      ),
                      child: Center(child: Text('Item: $index')),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Categories', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  TextButton(onPressed: (){}, child: Text('See All'))
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05, 
                child: FutureBuilder<List<MealCategory>>(
                  future: _categoriesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No categories found'));
                    }
        
                    final categories = snapshot.data!;
        
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        final category = categories[index];
        
                        return Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Row(
                            children: [
                              Image.network(
                                category.strCategoryThumb,
                                width: 30,
                                height: 30,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                category.strCategory,
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              const Text('Popular Recipes'),
              const SizedBox(height: 10),
              Expanded(
                child: FutureBuilder<List<Meals>>(
                  future: _mealsFuture, 
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const Center(child: CircularProgressIndicator());
                    }else if(snapshot.hasError){
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }else if(!snapshot.hasData || snapshot.data!.isEmpty){
                      return const Center(child:  Text('No Categories'));
                    }
        
                    final meals = snapshot.data!;
        
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: meals.length,
                      itemBuilder: (context, index) {
                        final meal = meals[index];
                        return Container(
                          margin: EdgeInsets.all(20),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: Colors.white),
                          child: Column(
                            children: [
                              Image.network(
                                meal.strMealThumb, 
                                height: MediaQuery.of(context).size.height * 0.20, 
                                width: MediaQuery.of(context).size.height * 0.20,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(height: 5),
                              Text(
                                meal.strMeal,
                                maxLines: 2,
                                overflow: TextOverflow.visible,
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}