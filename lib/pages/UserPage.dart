import 'package:first_from_zero/support/Global.dart';
import 'package:first_from_zero/support/Model.dart';
import 'package:flutter/material.dart';
import '../myWidgets/CircularIconButton.dart';
import '../myWidgets/InputField.dart';
import '../models/Passenger.dart';

class UserPage extends StatefulWidget {
  UserPage({Key key}) : super(key: key);

  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<UserPage> {
  bool _adding = false;
  bool _isLoggedIn = false;
  Passenger _justAddedUser;
  TextEditingController _firstNameFiledController = TextEditingController();
  TextEditingController _lastNameFiledController = TextEditingController();
  TextEditingController _telephoneNumberFiledController =
      TextEditingController();
  TextEditingController _emailFiledController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GlobalData.instance.userHasAnAccount
        ? (_isLoggedIn ? Text("logged in") : login())
        : register();
  }

  Widget login() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Text(
                "Register",
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Column(
                children: [
                  InputField(
                    labelText: "Email",
                    controller: _firstNameFiledController,
                  ),
                  InputField(
                    labelText: "Password",
                    controller: _passwordController,
                    isPassword: true,
                  ),
                  Padding(
                      padding: EdgeInsets.all(15),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircularIconButton(
                              icon: Icons.arrow_forward,
                              onPressed: () {
                                _login();
                              },
                            ),
                            TextButton.icon(
                                style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) => Theme.of(context)
                                                .primaryColor)),
                                onPressed: () {
                                  setState(
                                    () {
                                      GlobalData.instance.userHasAnAccount =
                                          false;
                                    },
                                  );
                                },
                                icon: Icon(Icons.arrow_back),
                                label: Text(
                                    "Don't have an account ?\n     register"))
                          ])),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: _adding
                          ? CircularProgressIndicator()
                          : _justAddedUser != null
                              ? Text("just_added")
                              : SizedBox.shrink(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget register() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Text(
                "Register",
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Column(
                children: [
                  InputField(
                    labelText: "First Name",
                    controller: _firstNameFiledController,
                  ),
                  InputField(
                    labelText: "Last Name",
                    controller: _lastNameFiledController,
                  ),
                  InputField(
                    labelText: "Email",
                    controller: _emailFiledController,
                  ),
                  InputField(
                    labelText: "Password",
                    controller: _passwordController,
                    isPassword: true,
                  ),
                  Padding(
                      padding: EdgeInsets.all(15),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton.icon(
                                style: ButtonStyle(
                                    foregroundColor:
                                    MaterialStateProperty.resolveWith(
                                            (states) => Theme.of(context)
                                            .primaryColor)),
                                onPressed: () {
                                  _register();
                                },
                                icon: Icon(Icons.app_registration),
                                label: Text("Register")),
                            TextButton.icon(
                                style: ButtonStyle(
                                    foregroundColor:
                                    MaterialStateProperty.resolveWith(
                                            (states) => Theme.of(context)
                                            .primaryColor)),
                                onPressed: () => {
                                      setState(() {
                                        GlobalData.instance.userHasAnAccount =
                                            true;
                                      })
                                    },
                                label: Text(
                                    "Already have an account ? \n      Login"),
                                icon: Icon(Icons.login))
                          ])),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: _adding
                          ? CircularProgressIndicator()
                          : _justAddedUser != null
                              ? Text("just_added")
                              : SizedBox.shrink(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _login() {
    setState(() {
      Model.sharedInstance
          .logIn(_emailFiledController.text, _passwordController.text)
          .then((result) {
        setState(() {
          _isLoggedIn = result == LogInResult.logged;
        });
      });
    });
  }

  AlertDialog alert =
      AlertDialog(title: Text("First Name , Email and password are mandatory"));

  void _register() {
    if (_passwordController.text == '' ||
        _emailFiledController.text == '' ||
        _firstNameFiledController.text == '') {
      showDialog(
          context: this.context,
          builder: (BuildContext context) {
            return alert;
          });
      return;
    }
    setState(() {
      _adding = true;
      _justAddedUser = null;
    });
    _justAddedUser = Passenger(
      firstName: _firstNameFiledController.text,
      lastName: _lastNameFiledController.text,
      email: _emailFiledController.text,
      password: _passwordController.text,
    );
    Model.sharedInstance.addUser(_justAddedUser).then((result) {
      setState(() {
        _adding = false;
      });
    });
  }
}
