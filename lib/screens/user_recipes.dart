import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRecipes extends StatefulWidget {
  static const routeName = '/user-recipes';

  @override
  _UserRecipesState createState() => _UserRecipesState();
}

class _UserRecipesState extends State<UserRecipes> {
  List<Map<String, dynamic>> userRecipes = [];
  var _isLoading = false;
  var _isInit = true;

  Future<void> getData() async {
    final List<Map<String, dynamic>> _loadedRecipes = [];
    final user = await FirebaseAuth.instance.currentUser();
    int i;

    await Firestore.instance.collection('recipe').getDocuments().then((val) {
      for (i = 0; i < val.documents.length; i++) {
        if (val.documents[i].data['userId'] == user.uid) {
          _loadedRecipes.add(val.documents[i].data);
          userRecipes = _loadedRecipes;
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      getData().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Recipes'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: userRecipes.length,
              itemBuilder: (context, index) {
                return Card(
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
                                  backgroundImage: NetworkImage(
                                      userRecipes[index]['userImage']),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(userRecipes[index]['username']),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.calendar_today),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(userRecipes[index]['date']),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Stack(
                        children: <Widget>[
                          Image.network(
                            userRecipes[index]['image'],
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
                                userRecipes[index]['title'],
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
                                  Text('${userRecipes[index]['prepTime']} min'),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Icon(Icons.schedule),
                                  Text('COOK:'),
                                  Text('${userRecipes[index]['duration']} min'),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Icon(Icons.local_dining),
                                  Text('FEEDS:'),
                                  Text(userRecipes[index]['feeds']),
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
                                userRecipes[index]['ingredients'],
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
                                userRecipes[index]['preparation'],
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
                );
              },
            ),
    );
  }
}
