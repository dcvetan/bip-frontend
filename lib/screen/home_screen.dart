import 'package:bip_frontend/screen/events_screen.dart';
import 'package:bip_frontend/screen/favorite_screen.dart';
import 'package:bip_frontend/screen/profile_screen.dart';
import 'package:bip_frontend/screen/ticket_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [EventsScreen(), ProfileScreen(), FavoriteScreen(), TicketScreen()];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF112537),
        selectedItemColor: Colors.green, // Color for selected icon
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 40), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person, size: 40), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.favorite, size: 40), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.credit_card_outlined, size: 40), label: ""),
        ],
      ),
    );
  }
}
