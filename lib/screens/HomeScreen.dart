import 'package:flutter/material.dart';
import 'package:userCritiqs/Component/Widget.Item.dart';

import 'package:userCritiqs/controller/ItemService.dart';
import 'package:userCritiqs/model/Item.dart';

import 'package:userCritiqs/screens/ReviewScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ItemService _itemService = ItemService();

  Future<List<Item>> _items;

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  _fetchItems() {
    _items = _itemService.getItems();
  }

  Future<void> _getItems() async {
    setState(() {
      _fetchItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SafeArea(
            child: Container(
              height: 60.0,
              color: Colors.deepPurple,
              padding: EdgeInsets.only(
                left: 20.0,
                right: 20.0,
              ),
              child: Container(
                child: Center(
                  child: Text(
                    "Home",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      topLeft: Radius.circular(10.0))),
              child: FutureBuilder(
                future: _items,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<List<Item>> snapshot,
                ) {
                  if (snapshot.hasData) {
                    List<Item> items = snapshot.data;

                    return RefreshIndicator(
                      onRefresh: _getItems,
                      child: ListView(
                          padding: EdgeInsets.all(20.0),
                          children: items
                              .map(
                                (Item item) => InkWell(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ReviewScreen(
                                        itemId: item.id,
                                        itemName: item.name,
                                      ),
                                    ),
                                  ),
                                  child: Container(
                                      margin: EdgeInsets.only(bottom: 20.0),
                                      child: wItem(item.imageUrl, item.name,
                                          item.numberOfReviews.toString())),
                                ),
                              )
                              .toList()),
                    );
                  }

                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
