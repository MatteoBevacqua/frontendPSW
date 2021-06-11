import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PasswordField extends StatefulWidget {
  final String labelText;
  final bool multiline;
  final bool enabled;
  final bool isPassword = true;
  final bool isUsername;
  final Function onChanged;
  final Function onSubmit;
  final Function onTap;
  final int maxLength;
  final TextAlign textAlign;
  final TextEditingController controller;
  final TextInputType keyboardType;
  bool enablePasswordVisibility;

  PasswordField({Key key,
    this.labelText,
    this.controller,
    this.onChanged,
    this.onSubmit,
    this.onTap,
    this.keyboardType,
    this.multiline,
    this.textAlign,
    this.maxLength,
    this.isUsername = false,
    this.enabled = true,
    this.enablePasswordVisibility = true})
      : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return FieldState(
        labelText: this.labelText,
        multiline: this.multiline,
        isPassword: this.isPassword,
        onTap: this.onTap,
        enabled: this.enabled,
        onChanged: this.onChanged,
        onSubmit: this.onSubmit,
        enablePasswordVisibility: this.enablePasswordVisibility,
       controller: this.controller
    );
  }
}

class FieldState extends State<PasswordField> {
  final String labelText;
  final bool multiline;
  final bool enabled;
  final bool isPassword;
  final bool isUsername;
  final Function onChanged;
  final Function onSubmit;
  final Function onTap;
  final int maxLength;
  final TextAlign textAlign;
  final TextEditingController controller;
  final TextInputType keyboardType;
  bool enablePasswordVisibility;

  FieldState(
      {Key key,
        this.labelText,
        this.controller,
        this.onChanged,
        this.onSubmit,
        this.onTap,
        this.keyboardType,
        this.multiline,
        this.textAlign,
        this.maxLength,
        this.isPassword = false,
        this.isUsername = false,
        this.enabled = true,
        this.enablePasswordVisibility = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Row(children: [
        Flexible(
          child: TextField(
            enabled: enabled,
            maxLength: maxLength,
            obscureText: enablePasswordVisibility,
            textAlign: this.textAlign == null ? TextAlign.left : this.textAlign,
            maxLines: multiline != null && multiline == true ? null : 1,
            keyboardType: keyboardType,
            inputFormatters: keyboardType == TextInputType.number
                ? <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ]
                : null,
            onChanged: onChanged,
            onSubmitted: onSubmit,
            onTap: onTap,
            controller: controller,
            cursorColor: Theme
                .of(context)
                .primaryColor,
            style: TextStyle(
              height: 1.0,
              color: Theme
                  .of(context)
                  .primaryColor,
            ),
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: new BorderRadius.circular(30.0),
                borderSide: BorderSide(
                  color: Theme
                      .of(context)
                      .primaryColor,
                ),
              ),
              fillColor: Theme
                  .of(context)
                  .primaryColor,
              focusedBorder: OutlineInputBorder(
                borderRadius: new BorderRadius.circular(30.0),
                borderSide: BorderSide(
                  color: Theme
                      .of(context)
                      .primaryColor,
                ),
              ),
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(30.0),
                borderSide: BorderSide(
                  color: Theme
                      .of(context)
                      .primaryColor,
                ),
              ),
              labelText: labelText,
              labelStyle: TextStyle(
                color: Theme
                    .of(context)
                    .primaryColor,
              ),
            ),
          ),
        ),
        if (isPassword)
          InkWell(
              child: Icon(
                enablePasswordVisibility ? Icons.visibility : Icons
                    .visibility_off_outlined,
                color: Colors.black,
              ),
              onTap: () {
                setState(() {
                  enablePasswordVisibility = !enablePasswordVisibility;
                });

              })
      ]),
    );
  }
}


