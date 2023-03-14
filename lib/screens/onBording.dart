import 'package:attendance/screens/create_class_screen.dart';
import 'package:attendance/screens/first_page.dart';
import 'package:attendance/screens/login_screen.dart';
import 'package:attendance/screens/signup_screen.dart';
import 'package:attendance/screens/t1_screen.dart';
import 'package:attendance/screens/t2_screen.dart';
import 'package:attendance/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const FirstPage(),
    const Center(child: Text('Notifications Screen')),
    const Center(child: Text('Profile'))
  ];

  @override
  Widget build(BuildContext context) {
    AuthState state = Provider.of<AuthState>(context, listen: false);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreateClass()));
        },
        child: const Text('NEW'),
      ),
      appBar: AppBar(
          elevation: 0,
          title: const Text(
            'A T T E N D A N C E',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.greenAccent),
      drawer: Drawer(
          child: Container(
        color: Colors.white,
        child: ListView(
          children: [
            DrawerHeader(
              child: Center(
                child: Text('L O G O'),
              ),
            ),
            ListTile(
              title: Text('LOGOUT'),
              onTap: () {
                state.logout();
              },
            )
          ],
        ),
      )),
      body: _pages[_selectedIndex],
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GNav(
            backgroundColor: Colors.white,
            gap: 8,
            color: Colors.black,
            activeColor: Colors.black,
            tabBackgroundColor: Colors.white,
            tabActiveBorder: const Border.fromBorderSide(BorderSide()),
            padding: const EdgeInsets.all(12),
            onTabChange: _navigateBottomBar,
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.notifications,
                text: 'Notifications',
              ),
              GButton(
                icon: Icons.person,
                text: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
