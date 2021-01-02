import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final TextEditingController _noteController = TextEditingController();
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

  Future<void> _loadItem() async {
    setState(() {
      _fecthItem();
    });
  }

  @override
  Widget build(BuildContext context) {
    void _updateReviewSheet(String content, int note, int id) async {
      TextEditingController _updateNoteController = TextEditingController()
        ..text = note.toString();
      TextEditingController _updateBodyController = TextEditingController()
        ..text = content;
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
                    flex: 1,
                    child: TextFormField(
                      controller: _updateNoteController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.only(left: 10.0, top: 20.0, right: 10.0),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                        hintStyle:
                            TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: TextField(
                      maxLines: 13,
                      controller: _updateBodyController,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.only(left: 10.0, top: 20.0, right: 10.0),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                        hintStyle:
                            TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      if (int.parse(_updateNoteController.text) <= 20) {
                        _reviewService
                            .updateReview(_updateBodyController.text,
                                int.parse(_updateNoteController.text), id)
                            .then((_) => _loadReviews())
                            .then((_) => _loadItem())
                            .then((_) => Navigator.of(context).pop());
                      } else {
                        displayDialog(context, "Error",
                            "Note should be inferior or equal 20");
                      }
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
      );
    }

    void _showReviewModal(
        String authorId, int id, context, String content, int note) async {
      String userId = await storage.read(key: "userId");
      showModalBottomSheet(
        context: context,
        builder: (context) {
          if (authorId == userId) {
            return Container(
              color: Color(0xFF737373),
              height: 130,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0)),
                ),
                child: Column(
                  children: [
                    ListTile(
                      onTap: () async => _reviewService
                          .deleteReview(id)
                          .then(
                            (_) => _loadReviews(),
                          )
                          .then((_) => _loadItem())
                          .then((_) => Navigator.of(context).pop()),
                      leading: Icon(
                        Icons.delete_outlined,
                        color: Colors.black,
                      ),
                      title: Text(
                        'Delete Review',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.of(context).pop();
                        _updateReviewSheet(content, note, id);
                      },
                      leading: Icon(
                        Icons.edit,
                        color: Colors.black,
                      ),
                      title: Text(
                        'Edit Review',
                        style: TextStyle(color: Colors.black),
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return Container(
              color: Color(0xFF737373),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.flag_outlined,
                    color: Colors.black,
                  ),
                  title: Text('Report'),
                ),
              ),
            );
          }
        },
      );
    }

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
                    flex: 1,
                    child: TextFormField(
                      controller: _noteController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.only(left: 10.0, top: 20.0, right: 10.0),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                        hintText: "give a note ",
                        hintStyle:
                            TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
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
                      if (int.parse(_noteController.text) <= 20) {
                        _reviewService
                            .addReview(_bodyController.text, uid,
                                int.parse(_noteController.text), itemId)
                            .then(
                              (_) => Navigator.of(context).pop(),
                            )
                            .then((_) => _noteController.text = "")
                            .then((_) => _bodyController.text = "");
                      } else {
                        displayDialog(context, "Error",
                            "the Note should be inferior than 20 ");
                      }
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
      ).then((_) => _loadReviews()).then((_) => _loadItem());
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
                                        SizedBox(height: 20.0),
                                        Container(
                                          height: 150,
                                          width: 500,
                                          child: Center(
                                            child: Text(
                                              '${item.note.toString()}/20',
                                              style: TextStyle(
                                                  fontSize: 48,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              color: item.note < 10
                                                  ? Colors.redAccent.shade400
                                                  : Colors
                                                      .greenAccent.shade400),
                                        ),
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                        Text(
                                          "Reviews & Critqs",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
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
                      Container(
                        child: FutureBuilder(
                          future: _reviews,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Review>> snapshot) {
                            if (snapshot.hasData) {
                              List<Review> reviews = snapshot.data;

                              return reviews.length < 1
                                  ? Container(
                                      height: 100,
                                      width: 500,
                                      padding: EdgeInsets.all(20.0),
                                      child: Center(
                                        child: Text(
                                          "There are no reviews yet , please be the first to add one",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )
                                  : ListView(
                                      shrinkWrap: true,
                                      primary: false,
                                      physics: ClampingScrollPhysics(),
                                      padding: EdgeInsets.all(20.0),
                                      children: reviews
                                          .map(
                                            (Review review) => InkWell(
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
                                              child: Container(
                                                width: 500,
                                                margin: EdgeInsets.only(
                                                    bottom: 20.0),
                                                padding: EdgeInsets.all(10.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade100,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.8),
                                                      spreadRadius: 2,
                                                      blurRadius: 3,
                                                      offset: Offset(0, 2),
                                                    )
                                                  ],
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          review
                                                              .author.userName,
                                                          style: TextStyle(
                                                              fontSize: 19,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Container(
                                                          width: 100,
                                                          height: 60,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0),
                                                            color: review
                                                                        .reviewNote <
                                                                    10
                                                                ? Colors
                                                                    .redAccent
                                                                    .shade400
                                                                : Colors
                                                                    .greenAccent
                                                                    .shade400,
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              '${review.reviewNote.toString()}/20',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 22,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 15.0,
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          top: 20.0,
                                                          bottom: 20.0),
                                                      child: Text(
                                                        review.body,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 20.0,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Icon(Icons.comment),
                                                            Text("  ${review.numberOfComments.toString()} comments"
                                                                .toString()),
                                                          ],
                                                        ),
                                                        IconButton(
                                                          icon: Icon(Icons
                                                              .more_horiz_outlined),
                                                          onPressed: () =>
                                                              _showReviewModal(
                                                                  review
                                                                      .authorId,
                                                                  review.id,
                                                                  context,
                                                                  review.body,
                                                                  review
                                                                      .reviewNote),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
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
