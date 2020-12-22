import 'package:flutter/material.dart';
import 'package:userCritiqs/Component/Widget.Review.dart';
import 'package:userCritiqs/Component/Widget.Row.dart';
import 'package:userCritiqs/controller/ItemService.dart';
import 'package:userCritiqs/controller/ReviewService.dart';
import 'package:userCritiqs/model/Item.dart';
import 'package:userCritiqs/model/Review.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:userCritiqs/screens/CommentScreen.dart';

import '../main.dart';

class ReviewScreen extends StatefulWidget {
  final int itemId;
  final String itemName;

  ReviewScreen({
    @required this.itemId,
    @required this.itemName,
  });

  @override
  _ReviewScreenState createState() => _ReviewScreenState(
        itemId: itemId,
        itemName: itemName,
      );
}

class _ReviewScreenState extends State<ReviewScreen> {
  int itemId;
  String itemName;

  _ReviewScreenState({
    @required this.itemId,
    @required this.itemName,
  });
  final ReviewService _reviewService = ReviewService();
  final ItemService _itemService = ItemService();
  Future<List<Review>> _reviews;
  final TextEditingController _bodyController = TextEditingController();
  Future<Item> _item;

  @override
  void initState() {
    super.initState();
    _fetchReviews();
    _fecthItem();
  }

  _fetchReviews() {
    _reviews = _reviewService.getReviews(itemId);
  }

  _fecthItem() {
    _item = _itemService.fetchItembyId(itemId);
  }

  Future<void> _loadReviews() async {
    setState(() {
      _fetchReviews();
    });
  }

  @override
  Widget build(BuildContext context) {
    void _showReviewSheet() async {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            child: Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: TextField(
                      maxLines: 13,
                      controller: _bodyController,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.only(left: 10.0, top: 20.0, right: 10.0),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                        hintText: "Add your Review",
                        hintStyle:
                            TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      var uid = await storage.read(key: "userId");
                      _reviewService
                          .addReview(_bodyController.text, uid, itemId)
                          .then(
                            (_) => Navigator.of(context).pop(),
                          )
                          .then((_) => _bodyController.text = "");
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 20.0),
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Text(
                          "send",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ).then((_) => _loadReviews());
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
        onPressed: () => _showReviewSheet(),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SafeArea(
              child: Container(
                height: 60.0,
                color: Colors.deepPurple,
                padding: EdgeInsets.only(
                    left: 20.0, top: 10.0, bottom: 20.0, right: 20.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.keyboard_arrow_left,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          itemName,
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        child: FutureBuilder(
                          future: _item,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              Item item = snapshot.data;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    height: 300,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0),
                                      ),
                                      image: DecorationImage(
                                          image: NetworkImage(item.imageUrl),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  SizedBox(height: 20.0),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 20.0, right: 20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Markdown(
                                          data: item.description,
                                          shrinkWrap: true,
                                          physics: ClampingScrollPhysics(),
                                          padding: EdgeInsets.all(0.0),
                                        ),
                                        SizedBox(height: 20.0),
                                        customRow(
                                            "Release date:", item.releaseDate),
                                        SizedBox(height: 20.0),
                                        customRow("Genre:", item.genre),
                                        SizedBox(height: 20.0),
                                        customRow("Publisher:", item.publisher),
                                        SizedBox(height: 20.0)
                                      ],
                                    ),
                                  )
                                ],
                              );
                            }
                            return Center(child: Text(""));
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Text(
                          "Reviews",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22.0),
                        ),
                      ),
                      Container(
                        child: FutureBuilder(
                          future: _reviews,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Review>> snapshot) {
                            if (snapshot.hasData) {
                              List<Review> reviews = snapshot.data;

                              return ListView(
                                  shrinkWrap: true,
                                  primary: false,
                                  physics: ClampingScrollPhysics(),
                                  padding: EdgeInsets.all(20.0),
                                  children: reviews
                                      .map((Review review) => InkWell(
                                            onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CommentScreen(
                                                        reviewId: review.id),
                                              ),
                                            ).then(
                                              (_) => _loadReviews(),
                                            ),
                                            child: wReview(
                                              context,
                                              review.author.userName,
                                              review.body,
                                              review.numberOfComments
                                                  .toString(),
                                            ),
                                          ))
                                      .toList());
                            }
                            return Center(child: CircularProgressIndicator());
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
