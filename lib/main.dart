import 'package:Moms_Kitchen/screens/tabs_sccreen.dart';
import 'package:Moms_Kitchen/screens/auth_screen.dart';
import 'package:Moms_Kitchen/screens/user_recipes.dart';
import 'package:Moms_Kitchen/widgets/onBoard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Moms Kitchen',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.amber,
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
        textTheme: ThemeData.light().textTheme.copyWith(
              bodyText1: TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              bodyText2: TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              headline6: TextStyle(
                fontSize: 20,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.bold,
              ),
            ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(
        seconds: 5,
        backgroundColor: Colors.pink,
        image: Image(
          image: AssetImage('assets/images/logo.png'),
        ),
        loaderColor: Colors.amber[50],
        photoSize: 150,
        navigateAfterSeconds: StreamBuilder(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (context, userSnapshot) {
            if (userSnapshot.hasData) {
              return TabsScreen();
            }
            return AuthScreen();
          },
        ),
      ),
      routes: {
        UserRecipes.routeName: (ctx) => UserRecipes(),
        OnBoard.routeName: (ctx) => OnBoard(),
        AuthScreen.routeName: (ctx) => AuthScreen(),
      },
    );
  }
}
