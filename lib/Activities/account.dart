import 'package:chrona_1/Activities/article.dart';
import 'package:chrona_1/Activities/main.dart';
import 'package:chrona_1/Activities/question.dart';
import 'package:chrona_1/UserInfo/state.dart';
import 'package:chrona_1/news/web_view.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  int selectedIndex = 3;
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  DatabaseReference databaseReferenceNews;

  @override
  void setState(VoidCallback fn) {
    String s = StaticState.user.email;
    s = s.substring(0, s.indexOf("@"));
    databaseReferenceNews = firebaseDatabase
        .reference()
        .child("Users")
        .child(s.toString())
        .child("News");
  }

  @override
  Widget build(BuildContext context) {
    String s = StaticState.user.email;
    s = s.substring(0, s.indexOf("@"));
    return Scaffold(
        appBar: AppBar(
          title: new Text("Account"),
          actions: <Widget>[
            IconButton(
              icon: CircleAvatar(
                radius: 18.0,
                backgroundImage: NetworkImage(StaticState.user.photoUrl),
                backgroundColor: Colors.transparent,
              ),
            )
          ],
          backgroundColor: Colors.black,
        ),
        body: new Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(6.0),
            ),
            Text(
              "Liked article of user are ",
              style: TextStyle(
                  fontSize: 19.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Colors.indigo),
            ),
            Padding(
              padding: EdgeInsets.all(6.0),
            ),
            new Flexible(
              child: new FirebaseAnimatedList(
                  query: firebaseDatabase
                      .reference()
                      .child("Users")
                      .child(s)
                      .child("News")
                      .child("Likes"),
                  padding: new EdgeInsets.all(8.0),
                  reverse: false,
                  itemBuilder: (_, DataSnapshot snapshot,
                      Animation<double> animation, int x) {
                    print(snapshot);
                    return new Card(
                      child: Container(
                        height: 120.0,
                        width: 120.0,
                        child: Center(
                          child: ListTile(
                            title: Text(
                              '${snapshot.value["title"]}',
                              style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            leading: Container(
                              height: 100.0,
                              width: 100.0,
                              child: snapshot.value["urlToImage"] == null
                                  ? Image.asset(
                                      'images/no_image_available.png',
                                      height: 70,
                                      width: 70,
                                    )
                                  : Image.network(
                                      '${snapshot.value["urlToImage"]}',
                                      height: 70,
                                      width: 70,
                                    ),
                            ),
                            onTap: () => _onTapItem(
                                context,
                                snapshot.value["url"].toString(),
                                snapshot.value["source"]),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            Padding(
              padding: EdgeInsets.all(6.0),
            ),
            Text(
              "Disliked Items of user are",
              style: TextStyle(
                  fontSize: 19.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent),
            ),
            Padding(
              padding: EdgeInsets.all(6.0),
            ),
            new Flexible(
              child: new FirebaseAnimatedList(
                  query: firebaseDatabase
                      .reference()
                      .child("Users")
                      .child(s)
                      .child("News")
                      .child("Dislikes"),
                  padding: new EdgeInsets.all(8.0),
                  reverse: false,
                  itemBuilder: (_, DataSnapshot snapshot,
                      Animation<double> animation, int x) {
                    print(snapshot);
                    return new Card(
                      child: Container(
                        height: 80.0,
                        width: 120.0,
                        child: Center(
                          child: ListTile(
                            title: Text(
                              '${snapshot.value["title"]}',
                              style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            onTap: () => _onTapItem(
                                context,
                                snapshot.value["url"].toString(),
                                snapshot.value["source"]),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: new Text("Home")),
            BottomNavigationBarItem(
                icon: Icon(Icons.question_answer), title: new Text("Q/A")),
            BottomNavigationBarItem(
              icon: Icon(Icons.description),
              title: Text("Article"),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle), title: new Text("Account"),backgroundColor: Colors.black)
          ],
          currentIndex: selectedIndex,
          selectedItemColor: Colors.red,
          onTap: _ontappeditem,
        ));
  }

  void _ontappeditem(int value) {
    if (value == 0) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NewsMain()));
      //selectedIndex=0;
    }
    if (value == 1) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Question_Route()));
      //selectedIndex=1;
    }
    if (value == 2) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Article()));
    }
  }

  void _onTapItem(
    BuildContext context,
    url,
    source,
  ) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => WebView(url, source)));
  }
}