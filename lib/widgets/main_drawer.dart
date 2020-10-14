import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class MainDrawer extends StatefulWidget {
  final String userEmail;

  MainDrawer(this.userEmail);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  Widget buildListTile(String title, IconData icon, Function tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'RobotoCondensed',
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (context, futureSnapshot) {
          return Drawer(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 120,
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    alignment: Alignment.centerLeft,
                    color: Theme.of(context).accentColor,
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/dp_default.png'),
                          radius: 30,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Text(
                            widget.userEmail,
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 15,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  buildListTile('My Recipes', Icons.local_dining, () async {
                    Navigator.of(context).pushNamed('/user-recipes');
                  }),
                  buildListTile('Logout', Icons.keyboard_backspace, () async {
                    await FirebaseAuth.instance.signOut();
                  }),
                ],
              ),
            ),
          );
        });
  }
}
