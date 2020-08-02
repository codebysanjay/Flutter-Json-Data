import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<User>> _getUser() async {
    var url = "https://api.github.com/users/hadley/orgs";
    var data = await http.get(url);
    var jsonData = jsonDecode(data.body);

    List<User> users = [];
    for (var u in jsonData) {
      User user = User(u["id"], u["login"], u["avatar_url"]);
      users.add(user);
    }
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("JSON DATA"),
      ),
      body: Container(
        child: Center(
          child: FutureBuilder(
            future: _getUser(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Text('Loading..');
              } else {
                return ListView.builder(
                    itemBuilder: (BuildContext context, int id) {
                      return ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  DetailsPage(snapshot.data[id])));
                        },
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(snapshot.data[id].avatar_url),
                        ),
                        title: Text(snapshot.data[id].login),
                      );
                    },
                    itemCount: snapshot.data.length);
              }
            },
          ),
        ),
      ),
    );
  }
}

class User {
  final String login;
  final int id;
  final String avatar_url;
  User(this.id, this.login, this.avatar_url);
}

class DetailsPage extends StatelessWidget {
  final User user;

  DetailsPage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.login),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 100,
                width: 100,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: Image(
                  image: NetworkImage(user.avatar_url),
                ),
              ),
              Text(
                user.login,
                style: Theme.of(context).textTheme.headline3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
