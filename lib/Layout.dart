import 'package:first_from_zero/SearchRoutes.dart';
import 'package:flutter/material.dart';
import 'package:first_from_zero/support/Constants.dart';

class Layout extends StatefulWidget {
  final String title;

  Layout({Key key, this.title}) : super(key: key);

  _LayoutState createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 1,
        child: Scaffold(
            appBar: AppBar(
              title: Text(Constants.APP_NAME),
              bottom: TabBar(tabs: [
                Tab(text: "Browse Routes", icon: Icon(Icons.train_outlined))
              ]),
            ),
            body: TabBarView(
              children: [SearchRoutes()],
            )));
  }
}
