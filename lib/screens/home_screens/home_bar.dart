import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_api/bloc/recipe_bloc.dart';

class HomeBar extends StatefulWidget {
  const HomeBar({super.key});

  @override
  State<HomeBar> createState() => _HomeBarState();
}

class _HomeBarState extends State<HomeBar> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeBloc, RecipeState>(
      builder: (context, state) {
        if (state is RecipeLoading){
          return const Center(child: CircularProgressIndicator());
        }

        if (state is RecipeError){
          return Center(child: Text("Error loading data: ${state.message}"),);
        }

        if(state is RecipeLoaded){
          return Scaffold(
            body: SafeArea(
              child:  Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const[
                            Icon(Icons.sunny, color:  Color(0xFF4D8194)),
                            SizedBox(width: 5),
                            Text('Good Morning', style: TextStyle(color: Color(0xFF0A2533))),
                          ],
                        ),
                        Text(user?.displayName ?? 'Guest', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text('Featured', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: ListView.builder(
                        itemCount: 4,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Container(
                            width: MediaQuery.of(context).size.height * 0.3,
                            margin: const EdgeInsets.only(right: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.grey
                            ),
                            child: Center(child: Text('Item: $index')),
                          );
                        },  
                      ),
                    ),

                    const SizedBox(height: 20),
                    const Text('Categories', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),

                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.1,
                      child:  ListView.builder(
                        itemCount: state.categories.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final category = state.categories[index];
                          final isSelected = category.strCategory == state.selectedCategory;

                          return GestureDetector(
                            onTap: (){
                              context.read<RecipeBloc>().add(CategorySelected(category.strCategory));
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFF4D8194) : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.grey)
                              ),
                              child: Row(
                                children: [
                                    Image.network(category.strCategoryThumb,
                                    width: 30,
                                    height: 30,     
                                    errorBuilder: (context, error, stackTrace) => Icon(Icons.error),                             
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    category.strCategory,
                                    style: TextStyle(color: isSelected ? Colors.white : Colors.black),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.meals.length,
                        itemBuilder: (context, index) {
                          final meal = state.meals[index];
                          return Container(
                            width: MediaQuery.of(context).size.height*0.25,
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
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.network(
                                    meal.strMealThumb,
                                    height: MediaQuery.of(context).size.height * 0.15,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  meal.strMeal,
                                  style: TextStyle(fontWeight: FontWeight.bold), 
                                )
                              ],
                            ),
                          );
                        },
                      )
                    )
                  ],
                ),
              ) 
            ),
          );
        }
        return const Center(child: Text('Unexcepted State'));
      },
    );
  }
}
