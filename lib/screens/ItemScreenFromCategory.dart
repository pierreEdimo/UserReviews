import 'package:flutter/material.dart';

import 'package:userCritiqs/Component/Widget.Item.dart';
import 'package:userCritiqs/controller/ItemService.dart';
import 'package:userCritiqs/model/Item.dart';

import 'ReviewScreen.dart';

class ItemSreenFromCategory extends StatefulWidget {
  final int categoryId;
  final String categoryTitle;

  ItemSreenFromCategory(
      {@required this.categoryId, @required this.categoryTitle});

  @override
  _ItemSreenFromCategoryState createState() => _ItemSreenFromCategoryState(
      categoryId: categoryId, categoryTitle: categoryTitle);
}

class _ItemSreenFromCategoryState extends State<ItemSreenFromCategory> {
  int categoryId;
  String categoryTitle;

  _ItemSreenFromCategoryState(
      {@required this.categoryId, @required this.categoryTitle});

  final ItemService _itemService = ItemService();
  Future<List<Item>> _items;

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  _fetchItems() {
    _items = _itemService.getItemsFromCategory(categoryId);
  }

  Future<void> _getItems() async {
    setState(() {
      _fetchItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 100,
              color: Colors.deepPurple,
              padding: EdgeInsets.only(left: 35.0, right: 35.0),
              child: Container(
                margin: EdgeInsets.only(top: 30.0),
                child: Center(
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.keyboard_arrow_left),
                        color: Colors.white,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            categoryTitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
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
                            padding: EdgeInsets.only(
                                top: 20.0,
                                right: 35.0,
                                left: 35.0,
                                bottom: 20.0),
                            children: items
                                .map((Item item) => InkWell(
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
                                    ))
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
      ),
    );
  }
}
