import 'package:flutter/material.dart';
import 'package:userCritiqs/Component/Widget.Category.dart';

import 'package:userCritiqs/controller/CategoryService.dart';
import 'package:userCritiqs/model/Category.dart';
import 'package:userCritiqs/screens/ItemScreenFromCategory.dart';
import 'package:userCritiqs/screens/SearchScreen.dart';

class ItemScreen extends StatefulWidget {
  @override
  _ItemScreenState createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  final CategoryService _categoryService = CategoryService();
  Future<List<Category>> _categories;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  _fetchCategories() {
    _categories = _categoryService.getCategories();
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Future<void> _getCategories() async {
    setState(() {
      _fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: [
          Container(
            height: 160.0,
            color: Colors.deepPurple,
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 5.0),
                  color: Colors.deepPurple,
                  width: MediaQuery.of(context).size.width,
                  height: 100.0,
                  child: Center(
                    child: Text(
                      "Discover",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ),
                ),
                Positioned(
                  top: 80.0,
                  left: 0.0,
                  right: 0.0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Container(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white),
                        child: Container(
                          child: TextField(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SearchPage())),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(20.0),
                                prefixIcon: Icon(Icons.search),
                                hintText: "Search",
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
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
                future: _categories,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<List<Category>> snapshot,
                ) {
                  if (snapshot.hasData) {
                    List<Category> categories = snapshot.data;

                    return RefreshIndicator(
                      onRefresh: _getCategories,
                      child: ListView(
                        padding: EdgeInsets.all(20.0),
                        children: categories
                            .map(
                              (Category category) => InkWell(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ItemSreenFromCategory(
                                                categoryId: category.id,
                                                categoryTitle: category.name))),
                                child: Container(
                                    margin: EdgeInsets.only(bottom: 20.0),
                                    child: wCategory(
                                        category.imageUrl,
                                        category.name,
                                        category.numberOfItems.toString())),
                              ),
                            )
                            .toList(),
                      ),
                    );
                  }

                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
