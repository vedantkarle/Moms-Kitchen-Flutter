import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/main_drawer.dart';

class MealsScreen extends StatefulWidget {
  @override
  _MealsScreenState createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
          stream: Firestore.instance
              .collection('recipe')
              .orderBy(
                'date',
              )
              .snapshots(),
          builder: (ctx, recipeSnapshot) {
            if (recipeSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (recipeSnapshot.data.documents.length <= 0) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    'Moms Kitchen',
                  ),
                ),
                drawer: Drawer(
                  child: MainDrawer(futureSnapshot.data.providerData[0].email),
                ),
                body: Center(
                  child: Text('No Recipes!'),
                ),
              );
            }
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  'Moms Kitchen',
                ),
              ),
              drawer: Drawer(
                child: MainDrawer(futureSnapshot.data.providerData[0].email),
              ),
              body: ListView.builder(
                itemCount: recipeSnapshot.data.documents.length,
                itemBuilder: (context, index) => Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(recipeSnapshot
                                      .data.documents[index]['userImage']),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(recipeSnapshot.data.documents[index]
                                    ['username']),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.calendar_today),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(recipeSnapshot.data.documents[index]
                                    ['date']),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Stack(
                        children: <Widget>[
                          Image.network(
                            recipeSnapshot.data.documents[index]['image'],
                            height: 250,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            bottom: 20,
                            right: 10,
                            child: Container(
                              width: 300,
                              color: Colors.black54,
                              padding: EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 20,
                              ),
                              child: Text(
                                recipeSnapshot.data.documents[index]['title'],
                                style: TextStyle(
                                  fontSize: 26,
                                  color: Colors.white,
                                ),
                                softWrap: true,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.amber[50],
                            border: Border.all(
                              color: Colors.amber,
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Icon(Icons.control_point),
                                  Text('PREP:'),
                                  Text(
                                      '${recipeSnapshot.data.documents[index]['prepTime']} min'),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Icon(Icons.schedule),
                                  Text('COOK:'),
                                  Text(
                                      '${recipeSnapshot.data.documents[index]['duration']} min'),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Icon(Icons.local_dining),
                                  Text('FEEDS:'),
                                  Text(recipeSnapshot.data.documents[index]
                                      ['feeds']),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 20,
                          right: 20,
                          bottom: 20,
                        ),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.pink[50],
                            border: Border.all(
                              color: Colors.pink,
                              style: BorderStyle.solid,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.shopping_cart),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'INGREDIENTS',
                                    style: TextStyle(
                                      color: Colors.pink,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                recipeSnapshot.data.documents[index]
                                    ['ingredients'],
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Icon(Icons.room_service),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'RECIPE',
                                    style: TextStyle(
                                      color: Colors.pink,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                recipeSnapshot.data.documents[index]
                                    ['preparation'],
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
