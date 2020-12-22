import 'package:flutter/material.dart';
import 'package:userCritiqs/Component/Widget.Item.dart';
import 'package:userCritiqs/controller/ItemService.dart';
import 'package:userCritiqs/model/Item.dart';

import 'ReviewScreen.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ItemService _itemService = ItemService();
  Future<List<Item>> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1.0,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.all(30.0),
                    hintText: "Search an Item",
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    prefixIcon: IconButton(
                      icon: Icon(
                        Icons.keyboard_arrow_left,
                        color: Colors.black,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  onChanged: (string) {
                    setState(() {
                      items = _itemService.searchItems(string);
                    });
                  },
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: items,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Item>> snapshot) {
                    if (snapshot.hasData) {
                      List<Item> items = snapshot.data;

                      return items.length < 1
                          ? Center(
                              child: Text("Not Found"),
                            )
                          : ListView(
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
                                          child: wItem(
                                            item.imageUrl,
                                            item.name,
                                            item.numberOfReviews.toString(),
                                          )),
                                    ),
                                  )
                                  .toList());
                    }

                    return Center(
                      child: Text(""),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
