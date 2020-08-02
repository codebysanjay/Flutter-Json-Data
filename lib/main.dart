import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:convert/convert.dart' as convert;

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
  Future<List<User>> _getUser() async{
    var url="https://api.github.com/users/hadley/orgs";
    var data = await http.get(url);
    var jsonData = jsonDecode(data.body);

    List<User> users=[];
    for ( var u in jsonData){
      User user= User(u["id"], u["login"], u["avatar_url"]);
      users.add(user);
    }
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("JSON DATA"),
      ),
      body: Container(
        child: Center(child: FutureBuilder(builder: (BuildContext context,AsyncSnapshot snapshot),),),
      ),
    );
  }
}
class User{
  final String login;
  final int id;
  final String avatar_url;
  User(this.id,this.login,this.avatar_url)
}