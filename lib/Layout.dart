import 'package:first_from_zero/BookRoute.dart';
import 'package:first_from_zero/SearchRoutes.dart';
import 'package:flutter/material.dart';
import 'package:first_from_zero/support/Constants.dart';

class Layout extends StatefulWidget {
  final String title;

  Layout({Key key, this.title}) : super(key: key);

  LayoutState createState() => LayoutState();
}

class LayoutState extends State<Layout> {
  TabController _controller;
  void goToBooking() {
      _controller.animateTo(1);
  }

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        initialIndex: index,
        child: Builder(builder: (BuildContext context) {
          _controller = DefaultTabController.of(context);
          return Scaffold(
              appBar: AppBar(
                title: Text(Constants.APP_NAME),
                bottom: TabBar(tabs: [
                  Tab(text: "Browse Routes", icon: Icon(Icons.train_outlined)),
                  Tab(
                      text: "Book your seats",
                      icon: Icon(Icons.shopping_cart_outlined))
                ]),
              ),
              body: TabBarView(
                children: [SearchRoutes(parentState: this), BookRoute()],
              ));
        }));
  }
}
