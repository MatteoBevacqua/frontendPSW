import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class MyTypeAheadField<T> extends StatelessWidget {
  final String labelText;
  final Function onSuggestionSelected;
  final bool autofocus;
  final Function onSubmit;
  final TextEditingController textEditingController;
  const MyTypeAheadField(
      {Key key, this.labelText, this.autofocus = false, this.onSuggestionSelected,this.onSubmit,this.textEditingController})
      : super(key: key);

  Widget build(BuildContext context) {
    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
          autofocus: false,
          controller: textEditingController,
          style: DefaultTextStyle.of(context).style,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: new BorderRadius.circular(30.0),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
              ),
            ),
            fillColor: Theme.of(context).primaryColor,
            focusedBorder: OutlineInputBorder(
              borderRadius: new BorderRadius.circular(30.0),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
              ),
            ),
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(30.0),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
              ),
            ),
            labelText: labelText,
            labelStyle: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          )),
      suggestionsCallback: onSuggestionSelected,
      itemBuilder: (context, suggestion) {
        return ListTile(
          hoverColor: Colors.black,
          leading: Icon(Icons.location_city_rounded),
          title: Text(suggestion.name),
          subtitle: Text(suggestion.country),
        );
      },
      onSuggestionSelected: onSubmit,
    );
  }
}

