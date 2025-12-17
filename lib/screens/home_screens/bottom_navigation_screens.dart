  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:nutrition_api/bloc/recipe_bloc.dart';
  import 'package:nutrition_api/screens/home_screens/account_bar.dart';
  import 'package:nutrition_api/screens/home_screens/favorites_screen.dart';
  import 'package:nutrition_api/screens/home_screens/home_bar.dart';
  import 'package:nutrition_api/screens/home_screens/search_bar_screen.dart';
  import 'package:nutrition_api/service/api/api_service.dart';


  class BottomNavigationScreens extends StatefulWidget {
    const BottomNavigationScreens({super.key});

    @override
    State<BottomNavigationScreens> createState() => _BottomNavigationScreensState();
  }

  class _BottomNavigationScreensState extends State<BottomNavigationScreens> {  
    final List<Widget> _screens = [
      HomeBar(),
      SearchBarScreen(),
      FavoritesScreen(),
      AccountBar()
    ];

    final ApiService _apiService = ApiService();

    @override
    Widget build(BuildContext context) {
      return BlocProvider(
        create: (context) => RecipeBloc(_apiService)..add(LoadHomeData()),
        child: BlocBuilder<RecipeBloc, RecipeState>(
          builder: (context, state) {
            return Scaffold(
              body: _screens[state.selectedIndex],
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: state.selectedIndex,
                onTap: (index) {
                  context.read<RecipeBloc>().add(NavigationItemTapped(index));
                },
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home, color: state.selectedIndex == 0 ?  const Color(0xFF4D8194) : Colors.black),
                    label: 'Home'
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search, color: state.selectedIndex == 1 ?const Color(0xFF4D8194) :  Colors.black ),
                    label: 'Search'
                  ),BottomNavigationBarItem(
                    icon: Icon(Icons.favorite, color: state.selectedIndex == 2 ? const Color(0xFF4D8194) : Colors.black),
                    label: 'Favors'
                  ),BottomNavigationBarItem(
                    icon: Icon(Icons.person, color: state.selectedIndex == 3 ? const Color(0xFF4D8194) : Colors.black),
                    label: 'Account'
                  ),
                ], 
                type: BottomNavigationBarType.fixed,
              ),
            );
          },
        )
      );
    }
  }