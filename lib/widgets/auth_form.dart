import 'dart:io';
import 'package:Moms_Kitchen/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isLoading);

  final bool isLoading;
  final void Function(
    String email,
    String password,
    String username,
    File image,
    List<Map<String, dynamic>> favouriteRecipes,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _email = "";
  var _username = "";
  var _password = "";
  List<Map<String, dynamic>> favouriteRecipes;
  File _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _submitForm() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_userImageFile == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Please Pick an image'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(
        _email.trim(),
        _password.trim(),
        _username.trim(),
        _userImageFile,
        favouriteRecipes,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Moms Kitchen',
          style: GoogleFonts.lobster(
            fontSize: 45,
            color: Colors.white,
          ),
        ),
        Center(
          child: Card(
            margin: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!_isLogin) UserImagePicker(_pickedImage),
                      TextFormField(
                        key: ValueKey('email'),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.pink,
                              width: 2,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty || !value.contains('@')) {
                            return 'Please Enter a valid email!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _email = value;
                        },
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      if (!_isLogin)
                        TextFormField(
                          key: ValueKey('username'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Username is required!';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _username = value;
                          },
                          decoration: InputDecoration(
                            labelText: 'Username',
                            fillColor: Colors.white,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.pink,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        key: ValueKey('password'),
                        validator: (value) {
                          if (value.isEmpty || value.length < 8) {
                            return 'Password Must be atleast 8 characters long!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _password = value;
                        },
                        decoration: InputDecoration(
                          labelText: 'Password',
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.pink,
                              width: 2,
                            ),
                          ),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      widget.isLoading
                          ? CircularProgressIndicator()
                          : RaisedButton(
                              onPressed: _submitForm,
                              child: Text(_isLogin ? 'Login' : 'Sign Up'),
                            ),
                      if (!widget.isLoading)
                        FlatButton(
                          child: Text(
                            _isLogin
                                ? 'Create a new account'
                                : 'Already have an account?',
                          ),
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          },
                          textColor: Theme.of(context).primaryColor,
                        )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        FlatButton.icon(
          icon: Icon(Icons.info),
          onPressed: () {
            Navigator.of(context).pushNamed('/on-board');
          },
          label: Text('About'),
          textColor: Theme.of(context).accentColor,
        ),
      ],
    );
  }
}
