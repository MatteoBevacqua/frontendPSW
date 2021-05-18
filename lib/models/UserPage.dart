import 'package:first_from_zero/support/Model.dart';
import 'package:flutter/material.dart';

import '../CircularIconButton.dart';
import '../InputField.dart';
import 'Passenger.dart';

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
                  CircularIconButton(
                    icon: Icons.person_rounded,
                    onPressed: () {
                      _register();
                    },
                  ),
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

  void _register() {
    setState(() {
      _adding = true;
      _justAddedUser = null;
    });
    _justAddedUser  = Passenger(
      firstName: _firstNameFiledController.text,
      lastName: _lastNameFiledController.text,
      email: _emailFiledController.text,
      password: _passwordController.text,
    );
    Model.sharedInstance.addUser(_justAddedUser).then((result) {
      setState(() {
        _adding = false;
      });
      print(Model.sharedInstance.logIn(_justAddedUser.email, _justAddedUser.password).then((value) => print(value)));
    });
  }
}
