import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../shared/constants.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class AddRecipeScreen extends StatefulWidget {
  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();

  File sampleImage;
  String url;
  String _title;
  String _ingredients;
  String _preparation;
  String _duration;
  String _prepTime;
  String _feeds;
  final picker = ImagePicker();

  Future getImage() async {
    var tempImage = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      sampleImage = File(tempImage.path);
    });
  }

  bool validateAndSave() {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    }
    return null;
  }

  void uploadData() async {
    if (validateAndSave()) {
      final StorageReference storageReference =
          FirebaseStorage.instance.ref().child("Recipes");

      var timeKey = new DateTime.now();

      final StorageUploadTask uploadTask = storageReference
          .child(timeKey.toString() + ".jpg")
          .putFile(sampleImage);

      var imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();

      url = imageUrl.toString();

      saveToDatabase(url);
    }
  }

  void saveToDatabase(url) async {
    var dbKey = new DateTime.now();

    var formatDate = new DateFormat('MMM d, yyyy');
    var formatTime = new DateFormat('EEEE, hh:mm aaa');

    final user = await FirebaseAuth.instance.currentUser();
    final userData =
        await Firestore.instance.collection('users').document(user.uid).get();

    String date = formatDate.format(dbKey);

    String time = formatTime.format(dbKey);

    Firestore.instance.collection('recipe').add({
      "image": url,
      "userId": user.uid,
      "username": userData['username'],
      "userImage": userData['image_url'],
      "title": _title,
      "ingredients": _ingredients,
      "preparation": _preparation,
      "duration": _duration,
      "prepTime": _prepTime,
      "feeds": _feeds,
      "date": date,
      "time": time,
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              child: sampleImage == null
                  ? Center(
                      child: Text('Select Image'),
                    )
                  : Image(
                      image: FileImage(sampleImage),
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
              height: 300,
              width: double.infinity,
            ),
            RaisedButton(
              color: Colors.pink,
              child: Text(
                'Add Image',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: getImage,
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    decoration:
                        textInputDecoration.copyWith(hintText: 'Recipe Name'),
                    validator: (val) {
                      return val.isEmpty ? 'Recipe Name Required!' : null;
                    },
                    onSaved: (val) {
                      return _title = val;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                      hintText: 'Ingredients',
                    ),
                    maxLines: 6,
                    validator: (val) {
                      return val.isEmpty ? 'Ingredients Required!' : null;
                    },
                    onSaved: (val) {
                      return _ingredients = val;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration:
                        textInputDecoration.copyWith(hintText: 'Preparation'),
                    validator: (val) {
                      return val.isEmpty ? 'Preparation Required!' : null;
                    },
                    maxLines: 8,
                    onSaved: (val) {
                      return _preparation = val;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                        hintText: 'Preparation Time(in min)'),
                    validator: (val) {
                      return val.isEmpty ? 'Preparation Time Required!' : null;
                    },
                    onSaved: (val) {
                      return _prepTime = val;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                        hintText: 'Duration(in min)'),
                    validator: (val) {
                      return val.isEmpty ? 'Duration Required!' : null;
                    },
                    onSaved: (val) {
                      return _duration = val;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                        hintText: 'Feeds(Number of person)'),
                    validator: (val) {
                      return val.isEmpty ? 'Required!' : null;
                    },
                    onSaved: (val) {
                      return _feeds = val;
                    },
                  ),
                  RaisedButton(
                    child: Text(
                      'Add New Recipe',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      uploadData();
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Recipe added!'),
                          duration: Duration(
                            seconds: 2,
                          ),
                        ),
                      );
                    },
                    color: Colors.pink,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
