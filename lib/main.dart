import 'package:attendance/providers/providers.dart';
import 'package:attendance/screens/create_class_screen.dart';
import 'package:attendance/screens/home_screen.dart';
import 'package:attendance/screens/login_screen.dart';
import 'package:attendance/screens/onBording.dart';
import 'package:attendance/screens/signup_screen.dart';
import 'package:attendance/screens/trash_screen.dart';
import 'package:attendance/screens/trying.dart';
import 'package:attendance/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primaryColor: Colors.deepPurpleAccent,
          ),
          home: Consumer<AuthState>(
            builder: (context, state, child) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return state.isLoggedIn ? const OnBoardingPage() : LoginPage();
            },
          )),
    );
  }
}
