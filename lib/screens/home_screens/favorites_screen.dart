import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "My Favorites",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              /// GRID 2x3
              Expanded(
                child: GridView.builder(
                  itemCount: demoMeals.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.78,
                  ),
                  itemBuilder: (context, index) {
                    final meal = demoMeals[index];
                    return _mealCard(meal);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mealCard(MealItem meal) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.network(
                  meal.image,
                  height: 115,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Icon(Icons.favorite, color: Color(0xFF7AB8C8)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              meal.title,
              maxLines: 2,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),

          const SizedBox(height: 4),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 10,
                  backgroundImage: NetworkImage(meal.authorAvatar),
                ),
                const SizedBox(width: 6),
                Text(
                  meal.author,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// --- DEMO DATA ---

class MealItem {
  final String title;
  final String author;
  final String image;
  final String authorAvatar;

  MealItem({
    required this.title,
    required this.author,
    required this.image,
    required this.authorAvatar,
  });
}

final List<MealItem> demoMeals = [
  MealItem(
    title: "Sunny Egg & Toast Avocado",
    author: "Alice Fala",
    image: "https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=900",
    authorAvatar: "https://randomuser.me/api/portraits/women/44.jpg",
  ),
  MealItem(
    title: "Bowl of noodle with beef",
    author: "James Spader",
    image: "https://images.unsplash.com/photo-1604908177306-9898276a52d1?w=900",
    authorAvatar: "https://randomuser.me/api/portraits/men/77.jpg",
  ),
  MealItem(
    title: "Easy homemade beef burger",
    author: "Agnes",
    image: "https://images.unsplash.com/photo-1550547660-d9450f859349?w=900",
    authorAvatar: "https://randomuser.me/api/portraits/women/30.jpg",
  ),
  MealItem(
    title: "Half boiled egg sandwich",
    author: "Natalia Luca",
    image: "https://images.unsplash.com/photo-1525351484163-7529414344d8?w=900",
    authorAvatar: "https://randomuser.me/api/portraits/women/18.jpg",
  ),
  MealItem(
    title: "Sunny side up with avocado",
    author: "Navabi Balqis",
    image: "https://images.unsplash.com/photo-1547043738-1810c22878a1?w=900",
    authorAvatar: "https://randomuser.me/api/portraits/women/60.jpg",
  ),
  MealItem(
    title: "Sandwich with strawberry jam",
    author: "Alice Fala",
    image: "https://images.unsplash.com/photo-1610440045646-67f1820f09d1?w=900",
    authorAvatar: "https://randomuser.me/api/portraits/women/44.jpg",
  ),
];
