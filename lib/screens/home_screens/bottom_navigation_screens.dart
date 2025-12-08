import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_api/bloc/recipe_bloc.dart';
import 'package:nutrition_api/screens/home_screens/account_bar.dart';
import 'package:nutrition_api/screens/home_screens/home_bar.dart';
import 'package:nutrition_api/screens/home_screens/notification_bar.dart';
import 'package:nutrition_api/screens/home_screens/search_bar_screen.dart';


class BottomNavigationScreens extends StatefulWidget {
  const BottomNavigationScreens({super.key});

  @override
  State<BottomNavigationScreens> createState() => _BottomNavigationScreensState();
}

class _BottomNavigationScreensState extends State<BottomNavigationScreens> {
  final List<Widget> _screens = [
    HomeBar(),
    SearchBarScreen(),
    NotificationBar(),
    AccountBar()
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecipeBloc(),
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
                  icon: Icon(Icons.home, color: Color(0xFFD9D9D9)),
                  label: 'Home'
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search, color: Color(0xFFD9D9D9)),
                  label: 'Search'
                ),BottomNavigationBarItem(
                  icon: Icon(Icons.notifications, color: Color(0xFFD9D9D9)),
                  label: 'Notification'
                ),BottomNavigationBarItem(
                  icon: Icon(Icons.person, color: Color(0xFFD9D9D9)),
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